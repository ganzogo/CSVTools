//
//  FileUtilities.h
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtilities : NSObject

+ (NSURL *)urlForTestCSVFileWithName:(NSString *)name;
+ (NSString *)pathForTestCSVFileWithName:(NSString *)name;
+ (NSURL *)temporaryFileURL;
+ (NSString *)temporaryFilePath;

@end
