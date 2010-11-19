//
//  PTTokyoBundle.h
//  TokyoCabinet
//
//  Created by Sergey Lenkov on 12.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "PTTokyoStore.h"

@interface PTTokyoBundle : NSObject {
    NSString *bundleName;
    NSString *bundlePath;
    NSMutableDictionary *stores;
}

@property (copy) NSString *bundleName;
@property (copy) NSString *bundlePath;

- (id)initWithPath:(NSString *)path name:(NSString *)name icon:(NSImage *)icon;

- (void)addStore:(NSString *)name;
- (PTTokyoStore *)storeWithName:(NSString *)name;

- (void)setBundleBitOfFile:(NSString*)path toBool:(BOOL)newValue;
- (NSString *)fullPath;

@end
