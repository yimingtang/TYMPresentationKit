//
//  TYMPage.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMPage.h"
#import "TYMDescriptor.h"
#import "NSDictionary+TYMPresentationKit.h"

NSString *const kTYMPageAuthorKey = @"author";
NSString *const kTYMPageNoteKey = @"note";
NSString *const kTYMPageRevisionKey = @"revision";
NSString *const kTYMPageDescriptorsKey = @"descriptors";
NSString *const kTYMPageNextPageKey = @"next";
NSString *const kTYMPagePreviousPageKey = @"previous";


@implementation TYMPage

#pragma mark - Accessors

@synthesize name = _name;
@synthesize note = _note;
@synthesize author = _author;
@synthesize revision = _revision;
@synthesize nextPageName = _nextPageName;
@synthesize previousPageName = _previousPageName;


#pragma mark - Class Methods

+ (NSCache *)_cache {
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}


+ (instancetype)pageNamed:(NSString *)name {
    return [self pageNamed:name inBundle:nil];
}


+ (instancetype)pageNamed:(NSString *)name inBundle:(NSBundle *)bundleOrNil {
    if (!name) {
        return nil;
    }
    
    TYMPage *cachedPage = [[self _cache] objectForKey:name];
    
    if (!cachedPage) {
        if (!bundleOrNil) {
            bundleOrNil = [NSBundle mainBundle];
        }
        
        NSString *fileName = [[name pathComponents] lastObject];
        NSString *fileExtension = [name pathExtension];
        if ([fileExtension isEqualToString:@""]) {
            fileExtension = @"json";
        }
        
        NSString *path = [bundleOrNil pathForResource:fileName ofType:fileExtension];
        if (!path) {
            NSLog(@"[TYMPage] Could not find file named: %@ in bundle: %@", name, bundleOrNil.bundleIdentifier);
        } else {
            cachedPage = [[self alloc] initWithContentsOfFile:path];
            if (cachedPage) {
                [[self _cache] setObject:cachedPage forKey:name];
            }
        }
    }
    
    return cachedPage;
}


+ (instancetype)pageWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}


#pragma mark - Initialization

- (instancetype)initWithContentsOfFile:(NSString *)path {
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    
    if (!fileURL) {
        NSLog(@"[TYMPage] NSURL is nil for path: %@", path);
        return nil;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        NSLog(@"[TYMPage] File doesn't exist at path: %@", path);
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSError *error = nil;
    NSDictionary *dictionary =  [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:&error];
    if (error) {
        NSLog(@"[TYMPage] Can't read json file at path: %@, error: %@", path, error);
        return nil;
    }
    
    if ((self = [self initWithDictionary:dictionary])) {
        _name = [[path pathComponents] lastObject];
    }
    return self;
}


#pragma mark - TYMDescriptor

+ (NSString *)descriptorName {
    return @"page";
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        _author = [dictionary tym_objectForKey:kTYMPageAuthorKey];
        _note = [dictionary tym_objectForKey:kTYMPageNoteKey];
        _revision = [dictionary tym_objectForKey:kTYMPageRevisionKey];
        _nextPageName = [dictionary tym_objectForKey:kTYMPageNextPageKey];
        _previousPageName = [dictionary tym_objectForKey:kTYMPagePreviousPageKey];
    }
    return self;
}


- (NSArray *)renderedView {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.subdescriptors.count];
    [self.subdescriptors enumerateObjectsUsingBlock:^(TYMDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        [mutableArray addObject:[descriptor renderedView]];
    }];
    return mutableArray;
}


- (NSDictionary *)customDescriptorInfo {
    return @{
        kTYMPageAuthorKey: self.author,
        kTYMPageRevisionKey: self.revision,
        kTYMPageNoteKey: self.note,
        kTYMPagePreviousPageKey: self.previousPageName,
        kTYMPageNextPageKey: self.nextPageName,
    };
}


#pragma mark - Public

- (TYMPage *)nextPage {
    return [TYMPage pageNamed:self.nextPageName];
}


- (TYMPage *)previousPage {
    return [TYMPage pageNamed:self.previousPageName];
}

@end
