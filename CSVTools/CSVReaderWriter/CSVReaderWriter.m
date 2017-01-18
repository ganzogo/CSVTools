//
//  CSVReaderWriter.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "CSVReaderWriter.h"
#import "CSVReader.h"
#import "CSVWriter.h"

@interface CSVReaderWriter ()

@property (nonatomic, strong) CSVReader *reader;
@property (nonatomic, strong) CSVWriter *writer;

@end

@implementation CSVReaderWriter

- (void)open:(NSString *)path mode:(FileMode)mode
{
  NSError *error = nil;
  NSURL *url = [NSURL fileURLWithPath:path];

  switch (mode) {
    case FileModeRead:
      self.reader = [CSVReader reader];
      [self.reader openURL:url error:&error];
      break;
    case FileModeWrite:
      self.writer = [CSVWriter writer];
      [self.writer openURL:url error:&error];
      break;
  }
}

- (BOOL)read:(NSMutableString **)column1 column2:(NSMutableString **)column2
{
  NSArray <NSString *> *columns = [self.reader read];
  if (columns.count < 2) {
    return NO;
  }

  *column1 = [NSMutableString stringWithString:columns[0]];
  *column2 = [NSMutableString stringWithString:columns[1]];
  return YES;
}

- (BOOL)read:(NSMutableArray *)columns
{
  NSArray *array = [self.reader read];
  if (array.count < 2) {
    return NO;
  }

  columns[0] = array[0];
  columns[1] = array[1];
  return YES;
}

- (void)write:(NSArray *)columns
{
  [self.writer write:columns error:nil];
}

- (void)close
{
  [self.reader close];
  [self.writer close];
}

@end
