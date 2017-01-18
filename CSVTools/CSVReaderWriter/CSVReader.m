//
//  CSVReader.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "CSVReader.h"
#import "DDFileReader.h"
#import "NSString+Utilities.h"

@interface CSVReader ()

@property (nonatomic, strong) DDFileReader *fileReader;

@end

@implementation CSVReader

+ (instancetype)reader
{
  CSVReader *reader = [[self alloc] init];
  reader.lineDelimiter = @"\n";
  reader.valueDelimiter = @"\t";
  return reader;
}

- (void)openURL:(NSURL *)url error:(NSError **)error
{
  self.fileReader = [[DDFileReader alloc] initWithURL:url error:error];
}

- (NSArray <NSString *> *)decode:(NSString *)string
{
  return [string componentsSeparatedByString:self.valueDelimiter];
}

- (NSArray <NSString *> *)read
{
  NSString *line = [self.fileReader readTrimmedLine];

  if (line == nil) {
    return nil;
  }

  if (line.length == 0) {
    return @[];
  }

  return [self decode:line];
}

- (void)close
{
  self.fileReader = nil;
}

- (NSString *)lineDelimiter
{
  return self.fileReader.lineDelimiter;
}

- (void)setLineDelimiter:(NSString *)lineDelimiter
{
  self.fileReader.lineDelimiter = lineDelimiter;
}

- (NSUInteger)chunkSize
{
  return self.fileReader.chunkSize;
}

- (void)setChunkSize:(NSUInteger)chunkSize
{
  self.fileReader.chunkSize = chunkSize;
}

@end
