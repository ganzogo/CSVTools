//
//  DDFileReader.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "DDFileReader.h"
#import "NSString+Utilities.h"

// TODO: Add unit tests for this file. Does it handle unicode characters?

@interface DDFileReader () {
  NSString *filePath;
  NSFileHandle *fileHandle;
  unsigned long long currentOffset;
  unsigned long long totalFileLength;
}

@end

@implementation DDFileReader

- (id)initWithURL:(NSURL *)url error:(NSError **)error
{
  if (url == nil) {
    // TODO: Come up with a consistent error code convention.
    *error = [NSError errorWithDomain:@"com.ganzogo.csvtools" code:1 userInfo:nil];
    return nil;
  }

  if (self = [super init]) {
    error = nil;
    fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:error];
    if (fileHandle == nil || error != nil) {
      return nil;
    }
    self.lineDelimiter = @"\n";
    currentOffset = 0ULL;
    self.chunkSize = 10;
    [fileHandle seekToEndOfFile];
    totalFileLength = [fileHandle offsetInFile];
  }
  return self;
}

- (void)dealloc
{
  [fileHandle closeFile];
  currentOffset = 0ULL;
}

- (NSString *)readLine
{
  NSUInteger chunkSize = self.chunkSize < self.lineDelimiter.length ? self.lineDelimiter.length : self.chunkSize;

  if (currentOffset >= totalFileLength) { return nil; }

  NSUInteger startOffset = currentOffset;

  NSData *newLineData = [self.lineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
  [fileHandle seekToFileOffset:currentOffset];
  NSMutableData *currentData = [[NSMutableData alloc] init];
  BOOL shouldReadMore = YES;

  @autoreleasepool {
    while (shouldReadMore) {
      if (currentOffset >= totalFileLength) { break; }
      NSData *chunk = [fileHandle readDataOfLength:chunkSize];
      [currentData appendData:chunk];
      NSRange newLineRange = [currentData rangeOfData:newLineData options:0 range:NSMakeRange(0, currentData.length)];
      if (newLineRange.location != NSNotFound) {
        currentData = [currentData subdataWithRange:NSMakeRange(0, newLineRange.location + [newLineData length])].mutableCopy;
        shouldReadMore = NO;
        currentOffset = startOffset + newLineRange.location + newLineData.length - chunk.length;
      }
      currentOffset += chunk.length;
    }
  }

  NSString *line = [[NSString alloc] initWithData:currentData encoding:NSUTF8StringEncoding];
  return line;
}

- (NSString *)readTrimmedLine
{
  return [[self readLine] stringByTrimmingSuffix:self.lineDelimiter];
}

@end
