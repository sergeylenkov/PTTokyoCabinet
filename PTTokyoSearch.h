//
//  PTTokyoSearch.h
//  Prismo
//
//  Created by Sergey Lenkov on 05.01.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTTokyoTypes.h"

@interface PTTokyoSearch : NSObject {
    NSString *orderByKey;
    NSInteger orderType;
    NSInteger limit;
    NSInteger offset;
    NSMutableArray *conditions;
}

@property (nonatomic, copy) NSString *orderByKey;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, retain) NSMutableArray *conditions;

- (void)orderBy:(NSString *)key type:(PTTokyoOrderTypes)_type;

@end
