//
//  FileUtilities.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "FileUtilities.h"

@implementation FileUtilities

+ (NSURL *)urlForTestCSVFileWithName:(NSString *)name
{
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  return [bundle URLForResource:name withExtension:@"csv"];
}

+ (NSString *)pathForTestCSVFileWithName:(NSString *)name
{
  return [[self urlForTestCSVFileWithName:name] path];
}

+ (NSURL *)temporaryFileURL
{
  return [NSURL fileURLWithPath:[self temporaryFilePath]];
}

+ (NSString *)temporaryFilePath
{
  NSString *temporaryDirectory = NSTemporaryDirectory();
  NSString *fileName = [NSProcessInfo.processInfo globallyUniqueString];
  return [temporaryDirectory stringByAppendingPathComponent:fileName];
}

@end
