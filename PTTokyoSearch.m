//
//  PTTokyoSearch.m
//  Prismo
//
//  Created by Sergey Lenkov on 05.01.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import "PTTokyoSearch.h"

@implementation PTTokyoSearch

@synthesize orderByKey;
@synthesize orderType;
@synthesize limit;
@synthesize offset;
@synthesize conditions;

- (id)init {
    if (self = [super init]) {
        self.orderByKey = @"";        
        self.limit = -1;
        self.offset = -1;
        self.conditions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)orderBy:(NSString *)key type:(PTTokyoOrderTypes)_type {
    self.orderByKey = key;
    self.orderType = _type;
}

- (void)dealloc {
    [orderByKey release];
    [conditions release];
    [super dealloc];
}

@end
