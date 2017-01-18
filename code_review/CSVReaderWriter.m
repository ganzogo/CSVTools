// I have prefixed code review comments with my initials (MVH) for clarity.

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, FileMode) { // MVH: This should be NS_ENUM.
    FileModeRead = 1,
    FileModeWrite = 2 // MVH: Add a trailing comma.
};

// MVH: Why is this class responsible for both reading and writing? There doesn't
// seem to be any overlap between the two responsibilities. Better to split this
// out into reader and writer classes.
@interface CSVReaderWriter : NSObject

// MVH: The class name is potentially misleading - it actually only supports
// tab-separated data right now, (not comma-separated).

- (void)open:(NSString*)path mode:(FileMode)mode;

// MVH: Since this should be a _reusable_ implementation, this method probably
// doesn't belong here. Seems to be specific to the use case and could be carried
// out in a wrapper class or a category, perhaps.
- (BOOL)read:(NSMutableString**)column1 column2:(NSMutableString**)column2;
- (BOOL)read:(NSMutableArray*)columns;
- (void)write:(NSArray*)columns;
- (void)close;

@end

@implementation CSVReaderWriter {
    NSInputStream* inputStream;
    NSOutputStream* outputStream;
}

// MVH: Don't use NSString for paths - from Apple documentation: "URL objects are the preferred way to refer to local files."
- (void)open:(NSString*)path mode:(FileMode)mode {
  // MVH: If you used a switch here, there would be no need to handle the else
  // case, since you would get a compile-time warning if not all cases were handled.
    if (mode == FileModeRead) {
        inputStream = [NSInputStream inputStreamWithFileAtPath:path];
        [inputStream open]; // MVH: open can fail. You should check the streamError.
    }
    else if (mode == FileModeWrite) {
        outputStream = [NSOutputStream outputStreamToFileAtPath:path
                                                         append:NO];
        [outputStream open]; // MVH: open can fail. For example, what if the file already existed, but was a directory?
    }
    else {
      // MVH: Generally, you should only throw an exception in the case of an
      // unrecoverable error. Anyway, you can remove this clause (see above).
        NSException* ex = [NSException exceptionWithName:@"UnknownFileModeException"
                                                  reason:@"Unknown file mode specified"
                                                userInfo:nil];
        @throw ex;
    }
}

// MVH: This is essentially a "private" method. Does the style guide say anything
// about naming private methods?
- (NSString*)readLine {
    uint8_t ch = 0;
    NSMutableString* str = [NSMutableString string];
     // MVH: This may be slow - you are reading one character at a time.
    while ([inputStream read:&ch maxLength:1] == 1) {
      // MVH: Might be nice to make the newline string configurable. For example, for dealing with carriage returns.
      // At least pull it out into a variable because it is currently hardcoded twice.
        if (ch == '\n')
            break;
        [str appendFormat:@"%c", ch];
    }
    return str;
}

// MVH: Might be nice to have some documentation so that it's clear what the
// return value means here. Same for method below.
- (BOOL)read:(NSMutableString**)column1 column2:(NSMutableString**)column2 { // MVH: Return value should probably be a bool - BOOL is an unsigned char.
  // MVH: This method name isn't the best - how about readColumn1:column2: ?

    int FIRST_COLUMN = 0; // MVH: This is not the best place to define these constants. Perhaps pull them out and make them part of the API?
    int SECOND_COLUMN = 1;

    NSString* line = [self readLine];

    if ([line length] == 0) {
        *column1 = nil;
        *column2 = nil;
        return false; // MVH: Go with YES and NO for consistency.
    }

    // MVH: Might be nice to make this delimiter configurable. At the very least,
    // pull it out to a single location, because you have it hardcoded three times right now.
    NSArray* splitLine = [line componentsSeparatedByString: @"\t"];

    if ([splitLine count] == 0) {
        *column1 = nil;
        *column2 = nil;
        return false;
    }
    else {
      // MVH: What if there is only one value on the line? This will crash.
        *column1 = [NSMutableString stringWithString:splitLine[FIRST_COLUMN]];
        *column2 = [NSMutableString stringWithString:splitLine[SECOND_COLUMN]];
        return true;
    }
}

// MVH: This should be a reusable implementation. How do I get more than 2 values out of this method?
- (BOOL)read:(NSMutableArray*)columns {
    int FIRST_COLUMN = 0;
    int SECOND_COLUMN = 1;

    NSString* line = [self readLine];

    if ([line length] == 0) {
        columns[FIRST_COLUMN]=nil; // MVH: Inconsistent whitespace here.
        columns[SECOND_COLUMN] = nil;
        return false;
    }

    NSArray* splitLine = [line componentsSeparatedByString: @"\t"];

    if ([splitLine count] == 0) {
        columns[FIRST_COLUMN] = nil;
        columns[SECOND_COLUMN] = nil;
        return false;
    }
    else {
        columns[FIRST_COLUMN] = splitLine[FIRST_COLUMN];
        columns[SECOND_COLUMN] = splitLine[SECOND_COLUMN];
        return true;
    }
}

- (void)writeLine:(NSString*)line {
    NSData* data = [line dataUsingEncoding:NSUTF8StringEncoding];

    const void* bytes = [data bytes];
    [outputStream write:bytes maxLength:[data length]];

// MVH: You could avoid the second call to write by appending the new line
// character to the string. I expect this would be more performant because
// write is going to hit the disk.
    unsigned char* lf = (unsigned char*)"\n";
    [outputStream write: lf maxLength: 1];
}

- (void)write:(NSArray*)columns { // MVH: You are assuming this is an array of NSStrings - make this explicit using generics.
    NSMutableString* outPut = [@"" mutableCopy]; // MVH: Output is one word, so make the p lowercase.

    for (int i = 0; i < [columns count]; i++) {
        [outPut appendString: columns[i]];
        if (([columns count] - 1) != i) {
            [outPut appendString: @"\t"];
        }
    }

    // MVH: The above algorithm could be replaced with a single call to
    // componentsJoinedByString.

    [self writeLine:outPut];
}

// MVH: This close method should get called on dealloc.
- (void)close {
    if (inputStream != nil) { // MVH: No need to check for nil in either of these cases: sending a message to nil is a no-op.
        [inputStream close];
    }
    if (inputStream != nil) { // MVH: Copy/paste error - this should close the outputStream.
        [inputStream close];
    }
}

// MVH: Perhaps worth documenting something about the lack of thread-safety.

// MVH: You don't support values which contain (escaped) tab characters. Probably
// worth documenting this issue.

// MVH: What if I open for reading and then try to write or vice-versa? Will it crash?

@end
