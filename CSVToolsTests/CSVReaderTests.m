//
//  CSVReaderTests.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CSVReader.h"
#import "FileUtilities.h"

@interface CSVReaderTests : XCTestCase

@property (nonatomic, strong) CSVReader *reader;

@end

@implementation CSVReaderTests

- (void)setUp
{
  [super setUp];
  self.reader = [CSVReader reader];
}

- (void)tearDown
{
  [self.reader close];
  self.reader = nil;
  [super tearDown];
}

- (void)openFileWithName:(NSString *)name
{
  NSURL *url = [FileUtilities urlForTestCSVFileWithName:name];

  NSError *error = nil;
  [self.reader openURL:url error:&error];
  XCTAssertNil(error);
}

- (void)testRead
{
  [self openFileWithName:@"test1"];

  NSArray <NSString *> *line1 = @[@"John Smith", @"john.smith@hotmail.com"];
  NSArray <NSString *> *line2 = @[@"Dave Brown", @"dave.brown@gmail.com"];
  NSArray <NSString *> *line3 = @[@"Suzie Godfrey", @"suzie342@yahoo.co.uk"];

  XCTAssertEqualObjects(line1, [self.reader read]);
  XCTAssertEqualObjects(line2, [self.reader read]);
  XCTAssertEqualObjects(line3, [self.reader read]);
}

- (void)testRead_longLinesAndEmptyLines
{
  [self openFileWithName:@"test2"];

  NSArray <NSString *> *line1 = @[@"value1", @"value2", @"value3", @"value4",
                                  @"value5", @"value6", @"value7", @"value8"];
  NSArray <NSString *> *emptyLine = @[];
  NSArray <NSString *> *line2 = @[@"foo bar"];

  XCTAssertEqualObjects(line1, [self.reader read]);
  XCTAssertEqualObjects(emptyLine, [self.reader read]);
  XCTAssertEqualObjects(emptyLine, [self.reader read]);
  XCTAssertEqualObjects(emptyLine, [self.reader read]);
  XCTAssertEqualObjects(emptyLine, [self.reader read]);
  XCTAssertEqualObjects(line2, [self.reader read]);
}

- (void)testRead_pastEOF
{
  [self openFileWithName:@"test1"];
  [self.reader read];
  [self.reader read];
  [self.reader read];

  XCTAssertNil([self.reader read]);
}

- (void)testRead_varyingDelimitersAndChunkSize
{
  [self openFileWithName:@"test3"];

  self.reader.lineDelimiter = @" or ";
  self.reader.valueDelimiter = @" and ";
  self.reader.chunkSize = 1;

  NSArray <NSString *> *expected1 = @[@"fish", @"chips"];
  NSArray <NSString *> *expected2 = @[@"bangers", @"mash"];
  NSArray <NSString *> *expected3 = @[@"peas", @"gravy\n"];

  XCTAssertEqualObjects(expected1, [self.reader read]);
  XCTAssertEqualObjects(expected2, [self.reader read]);
  XCTAssertEqualObjects(expected3, [self.reader read]);
}

- (void)testRead_nonexistentFile
{
  NSURL *url = [FileUtilities urlForTestCSVFileWithName:@"nonexistent_file"];

  NSError *error = nil;
  [self.reader openURL:url error:&error];
  XCTAssertNotNil(error);
}

@end
