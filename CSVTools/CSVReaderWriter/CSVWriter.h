//
//  CSVWriter.h
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVWriter : NSObject

@property (nonatomic, strong) NSString *lineDelimiter;
@property (nonatomic, strong) NSString *valueDelimiter;

+ (instancetype)writer;
- (void)openURL:(NSURL *)url error:(NSError **)error;
- (void)write:(NSArray <NSString *> *)values error:(NSError **)error;
- (void)close;

@end
