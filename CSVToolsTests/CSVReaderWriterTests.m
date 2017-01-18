//
//  CSVReaderWriterTests.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import <XCTest/XCTest.h>
#import "CSVReaderWriter.h"
#import "FileUtilities.h"

@interface CSVReaderWriterTests : XCTestCase

@property (nonatomic, strong) CSVReaderWriter *readerWriter;

@end

@implementation CSVReaderWriterTests

- (void)setUp
{
  [super setUp];
  self.readerWriter = [[CSVReaderWriter alloc] init];
}

- (void)tearDown
{
  [self.readerWriter close];
  self.readerWriter = nil;
  [super tearDown];
}

- (void)testRead_2Values
{
  NSString *path = [FileUtilities pathForTestCSVFileWithName:@"test1"];
  [self.readerWriter open:path mode:FileModeRead];

  NSString *name;
  NSString *email;

  [self.readerWriter read:&name column2:&email];
  XCTAssertEqualObjects(@"John Smith", name);
  XCTAssertEqualObjects(@"john.smith@hotmail.com", email);

  [self.readerWriter read:&name column2:&email];
  XCTAssertEqualObjects(@"Dave Brown", name);
  XCTAssertEqualObjects(@"dave.brown@gmail.com", email);

  [self.readerWriter read:&name column2:&email];
  XCTAssertEqualObjects(@"Suzie Godfrey", name);
  XCTAssertEqualObjects(@"suzie342@yahoo.co.uk", email);
}

- (void)testRead_array
{
  NSString *path = [FileUtilities pathForTestCSVFileWithName:@"test1"];
  [self.readerWriter open:path mode:FileModeRead];

  NSMutableArray<NSString *> *columns = @[].mutableCopy;

  [self.readerWriter read:columns];
  XCTAssertEqualObjects(@"John Smith", columns[0]);
  XCTAssertEqualObjects(@"john.smith@hotmail.com", columns[1]);

  [self.readerWriter read:columns];
  XCTAssertEqualObjects(@"Dave Brown", columns[0]);
  XCTAssertEqualObjects(@"dave.brown@gmail.com", columns[1]);

  [self.readerWriter read:columns];
  XCTAssertEqualObjects(@"Suzie Godfrey", columns[0]);
  XCTAssertEqualObjects(@"suzie342@yahoo.co.uk", columns[1]);
}

- (void)testWrite
{
  NSString *name1 = @"Barry Jones";
  NSString *name2 = @"Lucy White";

  NSString *email1 = @"bjones@hotmail.com";
  NSString *email2 = @"lw47@btinternet.co.uk";

  NSString *path = [FileUtilities temporaryFilePath];
  [self.readerWriter open:path mode:FileModeWrite];
  [self.readerWriter write:@[name1, email1]];
  [self.readerWriter write:@[name2, email2]];
  [self.readerWriter close];

  [self.readerWriter open:path mode:FileModeRead];

  NSString *name;
  NSString *email;

  [self.readerWriter read:&name column2:&email];
  XCTAssertEqualObjects(name1, name);
  XCTAssertEqualObjects(email1, email);

  [self.readerWriter read:&name column2:&email];
  XCTAssertEqualObjects(name2, name);
  XCTAssertEqualObjects(email2, email);
}

@end
