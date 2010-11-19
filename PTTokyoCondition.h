//
//  PTTokyoCondition.h
//  Clerk
//
//  Created by Sergey Lenkov on 19.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <tctdb.h>

typedef enum {
    TCStringEqual = TDBQCSTREQ,
    TCStringIncude = TDBQCSTRINC,
    TCStringBegin = TDBQCSTRBW,
    TCStringEnd = TDBQCSTREW,
    TCStringIncludeAll = TDBQCSTRAND,
    TCStringIncludeOne = TDBQCSTROR,
    TCStringEqualOne = TDBQCSTROREQ,
    TCStringEqualRegex = TDBQCSTRRX,
    TCNumberEqual = TDBQCNUMEQ,
    TCNumberGreater = TDBQCNUMGT,
    TCNumberGreaterOrEqual = TDBQCNUMGE,
    TCNumberLess = TDBQCNUMLT,
    TCNumberLessOrEqual = TDBQCNUMLE,
    TCNumberBeeween = TDBQCNUMBT,
    TCNumberEqualOne = TDBQCNUMOREQ 
} PTTokyoConditionTypes;

@interface PTTokyoCondition : NSObject {
    NSString *key;
    NSString *value;
    NSInteger condition;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger condition;

+ (PTTokyoCondition *)conditionWithKey:(NSString *)key value:(NSString *)value condition:(NSInteger)condition;

@end
