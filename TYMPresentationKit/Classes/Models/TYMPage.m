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

@interface TYMPage ()

@property (nonatomic) NSMutableArray *mutableDescriptors;

@end

@implementation TYMPage

#pragma mark - Accessors

@synthesize name = _name;
@synthesize note = _note;
@synthesize author = _author;
@synthesize revision = _revision;
@synthesize previousPageName = _previousPageName;
@synthesize nextPageName = _nextPageName;
@synthesize mutableDescriptors = _mutableDescriptors;


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


#pragma mark - NSObject

- (NSString *)description {
    //    return [NSString stringWithFormat:@"[%@] %@: %@;\r%@: %@;\r%@: %@;\r", [self class], kCBTSlideTitleKey, self.title, kCBTSlideAuthorKey, self.author, kCBTSlideImageNameKey, self.imageName];
    return nil;
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


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        _author = [dictionary tym_objectForKey:kTYMPageAuthorKey];
        _note = [dictionary tym_objectForKey:kTYMPageNoteKey];
        _revision = [dictionary tym_objectForKey:kTYMPageRevisionKey];
        _nextPageName = [dictionary tym_objectForKey:kTYMPageNextPageKey];
        _previousPageName = [dictionary tym_objectForKey:kTYMPagePreviousPageKey];
        
        NSArray *array = [dictionary tym_objectForKey:kTYMPageDescriptorsKey];
        TYMDescriptor *descriptor = nil;
        _mutableDescriptors = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            descriptor = [TYMDescriptor descriptorWithDictionary:dictionary];
            if (descriptor) {
                descriptor.page = self;
                [_mutableDescriptors addObject:descriptor];
            }
        }
    }
    return self;
}


#pragma mark - Public

- (TYMPage *)nextPage {
    return [TYMPage pageNamed:self.nextPageName];
}


- (TYMPage *)previousPage {
    return [TYMPage pageNamed:self.previousPageName];
}


- (NSArray *)descriptors {
    return [self.mutableDescriptors copy];
}


- (NSArray *)renderedViews {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.descriptors.count];
    [self.descriptors enumerateObjectsUsingBlock:^(TYMDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        [mutableArray addObject:[descriptor renderedView]];
    }];
    return mutableArray;
}


- (void)removeDescriptorAtIndex:(NSUInteger)index {
    [self.mutableDescriptors removeObjectAtIndex:index];
}


- (void)addDescriptor:(TYMDescriptor *)descriptor {
    [self.mutableDescriptors addObject:descriptor];
}


- (void)exchangeDescriptorAtIndex:(NSUInteger)idx1 withDescriptorAtIndex:(NSUInteger)idx2 {
    [self.mutableDescriptors exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}


- (void)insertDescriptor:(TYMDescriptor *)descriptor atIndex:(NSUInteger)index {
    [self.mutableDescriptors insertObject:descriptor atIndex:index];
}

@end
