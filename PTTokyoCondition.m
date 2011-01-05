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
@synthesize type;

+ (PTTokyoCondition *)conditionWithKey:(NSString *)_key value:(NSString *)_value type:(PTTokyoConditionTypes)_type {
    PTTokyoCondition *condition = [[PTTokyoCondition alloc] init];
    condition.key = _key;
    condition.value = _value;
    condition.type = _type;
    
    return [condition autorelease];
}

@end
