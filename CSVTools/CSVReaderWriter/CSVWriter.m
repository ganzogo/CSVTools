//
//  CSVWriter.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "CSVWriter.h"

@interface CSVWriter ()

@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation CSVWriter

+ (instancetype)writer
{
  CSVWriter *writer = [[self alloc] init];
  writer.lineDelimiter = @"\n";
  writer.valueDelimiter = @"\t";
  return writer;
}

- (void)dealloc
{
  [self close];
}

- (void)openURL:(NSURL *)url error:(NSError **)error
{
  self.stream = [NSOutputStream outputStreamWithURL:url append:NO];
  [self.stream open];
  *error = self.stream.streamError;
}

- (NSString *)encode:(NSArray <NSString *> *)values
{
  return [values componentsJoinedByString:self.valueDelimiter];
}

- (void)write:(NSArray <NSString *> *)values error:(NSError **)error
{
  NSString *line = [NSString stringWithFormat:@"%@\n", [self encode:values]];
  NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

  const void* bytes = [data bytes];
  NSInteger result = [self.stream write:bytes maxLength:[data length]];

  if (result == -1) {
    *error = self.stream.streamError;
  }
}

- (void)close
{
  [self.stream close];
}

@end
