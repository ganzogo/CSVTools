//
//  CSVWriterTests.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CSVWriter.h"
#import "FileUtilities.h"
#import "CSVReader.h"

@interface CSVWriterTests : XCTestCase

@property (nonatomic, strong) CSVWriter *writer;

@end

@implementation CSVWriterTests

- (void)setUp
{
  [super setUp];
  self.writer = [CSVWriter writer];
}

- (void)tearDown
{
  [self.writer close];
  self.writer = nil;
  [super tearDown];
}

- (void)testWrite
{
  NSURL *url = [FileUtilities temporaryFileURL];

  NSError *error = nil;
  [self.writer openURL:url error:&error];
  XCTAssertNil(error);

  NSString *name1 = @"Barry Jones";
  NSString *name2 = @"Lucy White";

  NSString *email1 = @"bjones@hotmail.com";
  NSString *email2 = @"lw47@btinternet.co.uk";

  [self.writer write:@[name1, email1] error:&error];
  XCTAssertNil(error);
  [self.writer write:@[name2, email2] error:&error];
  XCTAssertNil(error);

  [self.writer close];

  CSVReader *reader = [CSVReader reader];
  [reader openURL:url error:&error];
  XCTAssertNil(error);

  NSArray <NSString *> *line1 = @[name1, email1];
  NSArray <NSString *> *line2 = @[name2, email2];

  XCTAssertEqualObjects(line1, [reader read]);
  XCTAssertEqualObjects(line2, [reader read]);
}

- (void)testWrite_directoryAlreadyExistsAtPath
{
  NSURL *url = [FileUtilities temporaryFileURL];
  [NSFileManager.defaultManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:nil];

  NSError *error = nil;
  [self.writer openURL:url error:&error];
  XCTAssertNotNil(error);
}

@end
