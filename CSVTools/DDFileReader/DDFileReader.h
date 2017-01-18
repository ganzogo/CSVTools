//
//  DDFileReader.h
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

// This implementation is adapted from here: http://stackoverflow.com/a/8027618/577432

#import <Foundation/Foundation.h>

@interface DDFileReader : NSObject

@property (nonatomic, copy) NSString *lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id)initWithURL:(NSURL *)url error:(NSError **)error;
- (NSString *)readTrimmedLine;

@end
