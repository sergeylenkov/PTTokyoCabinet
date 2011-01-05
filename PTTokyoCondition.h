//
//  PTTokyoCondition.h
//  Clerk
//
//  Created by Sergey Lenkov on 19.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <tctdb.h>
#import "PTTokyoTypes.h"

@interface PTTokyoCondition : NSObject {
    NSString *key;
    NSString *value;
    NSInteger type;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger type;

+ (PTTokyoCondition *)conditionWithKey:(NSString *)_key value:(NSString *)_value type:(PTTokyoConditionTypes)_type;

@end
