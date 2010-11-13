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

- (BOOL)insertDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    TCMAP *cols;
    
    cols = tcmapnew();
        
    for (id key in dict) {
        tcmapput2(cols, [key UTF8String], [[dict objectForKey:key] UTF8String]);
    }
        
    NSString *pk = [self generateUID];
        
    if (!tctdbput(tdb, [pk UTF8String], [pk length], cols)) {
        int ecode = tctdbecode(tdb);
        NSLog(@"put error: %s\n", tctdberrmsg(ecode));
        return NO;
    }
        
    tcmapdel(cols);
        
    return YES;
}

- (BOOL)removeObjectForKey:(NSString *)key {
    return tctdbout2(tdb, [key UTF8String]);
}

- (BOOL)setIndexForColumn:(NSString *)name type:(NSInteger)type {
    return tctdbsetindex(tdb, [name UTF8String], type);
}

- (NSArray *)allObjects {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    TCMAP *cols;
    const char *pk;
    
    tctdbiterinit(tdb);
    
    while ((cols = tctdbiternext3(tdb)) != NULL) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        tcmapiterinit(cols);
        
        while ((pk = tcmapiternext2(cols)) != NULL) {            
            NSString *key = [NSString stringWithUTF8String:pk];
            NSString *value = [NSString stringWithUTF8String:tcmapget2(cols, pk)];

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

- (NSArray *)allObjectsForClass:(NSString *)name {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in [self allObjects]) {
        id object = [[NSClassFromString(name) alloc] init];
        
        for (id key in dict) {
            [object setValue:[dict objectForKey:key] forKey:key];
        }
        
        [results addObject:object];
    }
    
    return results;
}

- (NSArray *)searchObjects {
    TDBQRY *qry;
    TCLIST *res;
    TCMAP *cols;
    int rsiz;
    const char *rbuf, *name;
        
    qry = tctdbqrynew(tdb);
    
    tctdbqryaddcond(qry, "age", TDBQCNUMGE, "20");
    tctdbqryaddcond(qry, "lang", TDBQCSTROR, "ja,en");
    tctdbqrysetorder(qry, "name", TDBQOSTRASC);
    tctdbqrysetlimit(qry, 10, 0);
    
    res = tctdbqrysearch(qry);
    
    for (int i = 0; i < tclistnum(res); i++) {
        rbuf = tclistval(res, i, &rsiz);
        cols = tctdbget(tdb, rbuf, rsiz);
        
        if (cols) {
            printf("%s", rbuf);
            tcmapiterinit(cols);
            while ((name = tcmapiternext2(cols)) != NULL) {
                printf("\t%s\t%s", name, tcmapget2(cols, name));
            }

            tcmapdel(cols);
        }
    }
    
    tclistdel(res);
    tctdbqrydel(qry);
    
    return nil;
}
    
- (void)dealloc {
    [storeName release];
    [storePath release];
    
    [super dealloc];
}

@end
