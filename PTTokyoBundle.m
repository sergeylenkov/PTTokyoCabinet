//
//  PTTokyoBundle.m
//  TokyoCabinet
//
//  Created by Sergey Lenkov on 12.11.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "PTTokyoBundle.h"

@implementation PTTokyoBundle

@synthesize bundleName;
@synthesize bundlePath;

- (id)initWithPath:(NSString *)path name:(NSString *)name icon:(NSImage *)icon {
    if (self = [super init]) {
        self.bundleName = name;
        self.bundlePath = path;
        stores = [[NSMutableDictionary alloc] init];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        path = [path stringByAppendingPathComponent:name];

        if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            
            [[NSWorkspace sharedWorkspace] setIcon:icon forFile:path options:NSExclude10_4ElementsIconCreationOption];
            [self setBundleBitOfFile:path toBool:YES];
            
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden]; 
            
            [fileManager setAttributes:attributes ofItemAtPath:path error:nil];
        }
    }
    
    return self;
}

- (void)addStore:(NSString *)name {
    PTTokyoStore *store = [[PTTokyoStore alloc] initWithPath:[self fullPath] name:name];
    [stores setObject:store forKey:name];
    [store release];
}

- (PTTokyoStore *)storeWithName:(NSString *)name {
    return [stores objectForKey:name];
}

- (void)setBundleBitOfFile:(NSString*)path toBool:(BOOL)newValue {
    const char* pathFSR = [path fileSystemRepresentation];
    FSRef ref;
    OSStatus err = FSPathMakeRef((const UInt8*)pathFSR, &ref, NULL);
    
    if (err == noErr) {
        struct FSCatalogInfo catInfo;
        err = FSGetCatalogInfo(&ref, kFSCatInfoFinderInfo, &catInfo, NULL, NULL, NULL);
        
        if (err == noErr) {
            if (newValue) {
                ((FolderInfo*)&catInfo.finderInfo)->finderFlags |=  kHasBundle;
            } else {
                ((FolderInfo*)&catInfo.finderInfo)->finderFlags &= ~kHasBundle;
            }
            
            FSSetCatalogInfo(&ref, kFSCatInfoFinderInfo, &catInfo);
        }
    }    
}

- (NSString *)fullPath {
    return [bundlePath stringByAppendingPathComponent:bundleName];
}

- (void)close {
    for (id key in stores) {
        PTTokyoStore *store = [stores objectForKey:key];
        [store close];
    }
}

- (void)dealloc {
    [bundleName release];
    [bundlePath release];
    [stores release];
    
    [super dealloc];
}

@end
