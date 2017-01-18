//
//  NSStringUtilitiesTests.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Utilities.h"

@interface NSStringUtilitiesTests : XCTestCase

@end

@implementation NSStringUtilitiesTests

- (void)testStringByTrimmingSuffix
{
  XCTAssertEqualObjects(@"blah", [@"blah\n" stringByTrimmingSuffix:@"\n"]);
  XCTAssertEqualObjects(@"blah", [@"blah\r\n" stringByTrimmingSuffix:@"\r\n"]);
  XCTAssertEqualObjects(@"blah", [@"blah" stringByTrimmingSuffix:@"\n"]);
  XCTAssertEqualObjects(@"blah", [@"blah" stringByTrimmingSuffix:@""]);
  XCTAssertEqualObjects(@"", [@"blah" stringByTrimmingSuffix:@"blah"]);
  XCTAssertEqualObjects(@"", [@"" stringByTrimmingSuffix:@""]);
}

@end
