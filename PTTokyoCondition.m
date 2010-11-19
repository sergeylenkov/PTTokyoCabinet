//
//  PTTokyoCondition.m
//  Clerk
//
//  Created by Sergey Lenkov on 19.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "PTTokyoCondition.h"


@implementation PTTokyoCondition

@synthesize key;
@synthesize value;
@synthesize condition;

+ (PTTokyoCondition *)conditionWithKey:(NSString *)_key value:(NSString *)_value condition:(NSInteger)_condition {
    PTTokyoCondition *tokyoCondition = [[PTTokyoCondition alloc] init];
    tokyoCondition.key = _key;
    tokyoCondition.value = _value;
    tokyoCondition.condition = _condition;
    
    return [tokyoCondition autorelease];
}

@end
