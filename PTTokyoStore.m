//
//  PTTokyoStore.m
//  TokyoCabinet
//
//  Created by Sergey Lenkov on 12.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "PTTokyoStore.h"

@implementation PTTokyoStore

@synthesize storeName;
@synthesize storePath;

- (id)initWithPath:(NSString *)path name:(NSString *)name {
    if (self = [super init]) {
        self.storeName = name;
        self.storePath = path;
        
        tdb = tctdbnew();
        
        if  (!tctdbopen(tdb, [[storePath stringByAppendingPathComponent:storeName] UTF8String], TDBOWRITER | TDBOCREAT | TDBOREADER)) {
            int ecode = tctdbecode(tdb);
            NSLog(@"open error: %s\n", tctdberrmsg(ecode));
        }
    }
    
    return self;
}

- (void)close {
    if (!tctdbclose(tdb)) {
        int ecode = tctdbecode(tdb);
        NSLog(@"close error: %s\n", tctdberrmsg(ecode));
    }
    
    tctdbdel(tdb);
}

- (BOOL)sync {
    return tctdbsync(tdb);
}

- (BOOL)vanish {
    return tctdbvanish(tdb);
}

- (NSInteger)count {
    return tctdbrnum(tdb);
}

- (NSInteger)size {
    return tctdbfsiz(tdb);
}

- (NSString *)generateUID {
    return [NSString stringWithFormat:@"%ld", (long)tctdbgenuid(tdb)];
}

- (BOOL)insertDictionary:(NSDictionary *)dict withKey:(NSString *)pk {
    TCMAP *cols;
    
    cols = tcmapnew();
        
    for (id key in dict) {
        tcmapput2(cols, [key UTF8String], [[dict objectForKey:key] UTF8String]);
    }
        
    if (!tctdbput(tdb, [pk UTF8String], [pk length], cols)) {
        int ecode = tctdbecode(tdb);
        NSLog(@"put error: %s\n", tctdberrmsg(ecode));
        return NO;
    }
        
    tcmapdel(cols);
        
    return YES;
}

- (BOOL)removeObjectWithKey:(NSString *)key {
    return tctdbout2(tdb, [key UTF8String]);
}

- (BOOL)setIndexForColumn:(NSString *)name type:(NSInteger)type {
    return tctdbsetindex(tdb, [name UTF8String], type);
}

- (NSArray *)allObjects {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    TCMAP *cols;
    const char *name;
    
    tctdbiterinit(tdb);
    
    while ((cols = tctdbiternext3(tdb)) != NULL) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        tcmapiterinit(cols);
        
        while ((name = tcmapiternext2(cols)) != NULL) {            
            NSString *key = [NSString stringWithUTF8String:name];
            NSString *value = [NSString stringWithUTF8String:tcmapget2(cols, name)];

            if ([key isEqualToString:@""]) {
                key = @"_id";
            }
            
            [dict setObject:value forKey:key];
        }
        
        [results addObject:[dict autorelease]];
        
        tcmapdel(cols);
    }
    
    return [results autorelease];
}

- (NSArray *)searchObjects:(PTTokyoSearch *)search {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    TDBQRY *qry;
    TCLIST *res;
    TCMAP *cols;
    int rsiz;
    const char *rbuf, *name;
    
    qry = tctdbqrynew(tdb);
    
    for (PTTokyoCondition *condition in search.conditions) {
        tctdbqryaddcond(qry, [condition.key UTF8String], condition.type, [condition.value UTF8String]);
    }

    if ([search.orderByKey length] > 0) {
        tctdbqrysetorder(qry, [search.orderByKey UTF8String], search.orderType);
    }
        
    if (search.limit != -1 &&  search.offset != -1) {
        tctdbqrysetlimit(qry, search.limit, search.offset);
    }    
    
    res = tctdbqrysearch(qry);

    for (int i = 0; i < tclistnum(res); i++) {
        rbuf = tclistval(res, i, &rsiz);
        cols = tctdbget(tdb, rbuf, rsiz);
        
        if (cols) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[NSString stringWithUTF8String:rbuf] forKey:@"_id"];
            
            tcmapiterinit(cols);
            
            while ((name = tcmapiternext2(cols)) != NULL) {
                [dict setObject:[NSString stringWithUTF8String:tcmapget2(cols, name)] forKey:[NSString stringWithUTF8String:name] ];
            }
            
            [results addObject:[dict autorelease]];
            
            tcmapdel(cols);            
        }
    }
    
    tclistdel(res);
    tctdbqrydel(qry);
    
    return [results autorelease];
}

- (void)dealloc {
    [storeName release];
    [storePath release];
    
    [super dealloc];
}

@end
