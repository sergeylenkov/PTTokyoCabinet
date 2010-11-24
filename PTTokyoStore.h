//
//  PTTokyoStore.h
//  TokyoCabinet
//
//  Created by Sergey Lenkov on 12.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <tcutil.h>
#include <tctdb.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#import "PTTokyoCondition.h"

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

typedef enum {
    TDStringAscending = TDBQOSTRASC,
    TDStringDescending = TDBQOSTRDESC,
    TDNumberAscending = TDBQONUMASC,
    TDNumberDscending = TDBQONUMDESC
} PTTokyoOrderTypes;


@interface PTTokyoStore : NSObject {
    TCTDB *tdb;
    NSString *storeName;
    NSString *storePath;
}

@property (copy) NSString *storeName;
@property (copy) NSString *storePath;

- (id)initWithPath:(NSString *)path name:(NSString *)name;
- (void)close;
- (BOOL)sync;
- (BOOL)vanish;
- (NSInteger)count;
- (NSInteger)size;
- (NSString *)generateUID;
- (BOOL)insertDictionary:(NSDictionary *)dict withKey:(NSString *)key;
- (BOOL)removeObjectWithKey:(NSString *)key;
- (BOOL)setIndexForColumn:(NSString *)name type:(NSInteger)type;
- (NSArray *)allObjects;
- (NSArray *)searchObjectsWithConditions:(NSArray *)conditions;
- (NSArray *)searchObjectsWithConditions:(NSArray *)conditions orderBy:(NSString *)key orderType:(PTTokyoOrderTypes)type;

@end
