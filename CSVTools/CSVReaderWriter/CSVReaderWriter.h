//
//  CSVReaderWriter.h
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <Foundation/Foundation.h>

__deprecated
typedef NS_OPTIONS(NSUInteger, FileMode) {
  FileModeRead = 1,
  FileModeWrite = 2,
};

__deprecated
@interface CSVReaderWriter : NSObject

- (void)open:(NSString *)path mode:(FileMode)mode __deprecated;
- (BOOL)read:(NSMutableString **)column1 column2:(NSMutableString **)column2 __deprecated;
- (BOOL)read:(NSMutableArray *)columns __deprecated;
- (void)write:(NSArray *)columns __deprecated;
- (void)close __deprecated;

@end
