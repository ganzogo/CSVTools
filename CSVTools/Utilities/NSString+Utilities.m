//
//  NSString+Utilities.m
//  CSVTools
//
//  Created by Matthew Hasler on 17/01/2017.
//  Copyright © 2017 Ganzogo. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)stringByTrimmingSuffix:(NSString *)suffix
{
  if ([self hasSuffix:suffix]) {
    return [self substringToIndex:self.length - suffix.length];
  }
  return self;
}

@end
