//
//  CSVReader.h
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVReader : NSObject

@property (nonatomic, strong) NSString *lineDelimiter;
@property (nonatomic, strong) NSString *valueDelimiter;
@property (nonatomic, assign) NSUInteger chunkSize;

+ (instancetype)reader;
- (void)openURL:(NSURL *)url error:(NSError **)error;
- (NSArray <NSString *> *)read;
- (void)close;

@end
