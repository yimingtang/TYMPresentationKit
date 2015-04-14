//
//  TYMDescriptor.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMDescriptor.h"
#import "TYMButtonDescriptor.h"
#import "TYMImageDescriptor.h"
#import "TYMTextDescriptor.h"
#import "TYMTextFieldDescriptor.h"
#import "NSDictionary+TYMPresentationKit.h"

NSString *const kTYMDescriptorSubdescriptorsKey = @"subdescriptors";
NSString *const kTYMDescriptorTypeKey = @"type";


@interface TYMDescriptor ()

@property (nonatomic) NSMutableArray *mutableSubdescriptors;
@property (nonatomic, weak, readwrite) TYMDescriptor *superdescriptor;

@end

@implementation TYMDescriptor

#pragma mark - Accessors

@dynamic subdescriptors;
@synthesize name = _name;
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize superdescriptor = _superdescriptor;
@synthesize mutableSubdescriptors = _mutableSubdescriptors;


+ (NSCache *)_cache {
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}


- (NSMutableArray *)mutableSubdescriptors {
    if (!_mutableSubdescriptors) {
        _mutableSubdescriptors = [NSMutableArray array];
    }
    return _mutableSubdescriptors;
}


- (NSArray *)subdescriptors {
    return [self.mutableSubdescriptors copy];
}


#pragma mark - Class Cluster

+ (instancetype)descriptorWithDictionary:(NSDictionary *)dictionary {
    NSString *type = [dictionary tym_objectForKey:@"type"];

    if ([type isEqualToString:@"text"]) {
        return [[TYMTextDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"image"]) {
        return [[TYMImageDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"button"]) {
        return [[TYMButtonDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else if ([type isEqualToString:@"text_field"]) {
        return [[TYMButtonDescriptor alloc] initWithDictionary:dictionary];
    }
    
    else {
        return nil;
    }
}


#pragma mark - Class Methods

+ (NSString *)descriptorTypeName {
    // Subclasses may override this method
    return @"descriptor";
}


+ (instancetype)descriptorNamed:(NSString *)name {
    return [self descriptorNamed:name inBundle:nil];
}


+ (instancetype)descriptorNamed:(NSString *)name inBundle:(NSBundle *)bundleOrNil {
    if (!name) {
        return nil;
    }
    
    TYMDescriptor *cachedDescriptor = [[self _cache] objectForKey:name];
    
    if (!cachedDescriptor) {
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
            NSLog(@"[TYMDescriptor] Could not find file named: %@ in bundle: %@", name, bundleOrNil.bundleIdentifier);
        } else {
            cachedDescriptor = [[self alloc] initWithContentsOfFile:path];
            if (cachedDescriptor) {
                [[self _cache] setObject:cachedDescriptor forKey:name];
            }
        }
    }
    
    return cachedDescriptor;
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
        NSArray *array = [dictionary tym_objectForKey:kTYMDescriptorSubdescriptorsKey];
        TYMDescriptor *subdescriptor = nil;
        for (NSDictionary *dictionary in array) {
            subdescriptor = [TYMDescriptor descriptorWithDictionary:dictionary];
            if (subdescriptor) {
                [self addSubdescriptor:subdescriptor];
            }
        }
    }
    return self;
}


#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@]: %@", [self class], [self dictionaryRepresentation]];
}


#pragma mark - Public

- (UIView *)renderedView {
    // Subclasses must override this method
    return nil;
}


- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [mutableDictionary setObject:[[self class] descriptorTypeName] forKey:kTYMDescriptorTypeKey];
    NSMutableArray *dictionaryArray = [NSMutableArray arrayWithCapacity:self.subdescriptors.count];
    for (TYMDescriptor *subdescriptor in self.subdescriptors) {
        [dictionaryArray addObject:[subdescriptor dictionaryRepresentation]];
    }
    [mutableDictionary setObject:dictionaryArray forKey:kTYMDescriptorSubdescriptorsKey];
    if ([self customDescriptorInfo]) {
        [mutableDictionary addEntriesFromDictionary:[self customDescriptorInfo]];
    }
    
    return mutableDictionary;
}


- (NSDictionary *)customDescriptorInfo {
    // Subclasses may override this method to add custom key-value pairs into `dictionaryRepresentation`
    return nil;
}


#pragma mark - Descriptor Hierarchy

- (void)removeFromSuperdescriptor {
    [self.superdescriptor willRemoveSubdescriptor:self];
    [self willMoveToSuperdescriptor:nil];
    [self.superdescriptor.mutableSubdescriptors removeObject:self];
    self.superdescriptor = nil;
    [self didMoveToSuperdescriptor];
}


- (void)addSubdescriptor:(TYMDescriptor *)descriptor {
    [descriptor willMoveToSuperdescriptor:self];
    [self.mutableSubdescriptors addObject:descriptor];
    descriptor.superdescriptor = self;
    [self didAddSubdescriptor:descriptor];
    [descriptor didMoveToSuperdescriptor];
}


- (void)insertSubdescriptor:(TYMDescriptor *)descriptor atIndex:(NSInteger)index {
    [descriptor willMoveToSuperdescriptor:self];
    [self.mutableSubdescriptors insertObject:descriptor atIndex:index];
    descriptor.superdescriptor = self;
    [self didAddSubdescriptor:descriptor];
    [descriptor didMoveToSuperdescriptor];
}


- (void)exchangeSubdescriptorAtIndex:(NSInteger)index1 withSubdescriptorAtIndex:(NSInteger)index2 {
    [self.mutableSubdescriptors exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


- (void)insertSubdescriptor:(TYMDescriptor *)descriptor afterSubdescriptor:(TYMDescriptor *)siblingSubdescriptor {
    NSInteger index = [self.mutableSubdescriptors indexOfObject:siblingSubdescriptor];
    
    [descriptor willMoveToSuperdescriptor:self];
    [self.mutableSubdescriptors insertObject:descriptor atIndex:(index + 1)];
    descriptor.superdescriptor = self;
    [self didAddSubdescriptor:descriptor];
    [descriptor didMoveToSuperdescriptor];
}


- (void)insertSubdescriptor:(TYMDescriptor *)descriptor beforeSubdescriptor:(TYMDescriptor *)siblingSubdescriptor {
    NSInteger index = [self.mutableSubdescriptors indexOfObject:siblingSubdescriptor];
    
    [descriptor willMoveToSuperdescriptor:self];
    [self.mutableSubdescriptors insertObject:descriptor atIndex:index];
    descriptor.superdescriptor = self;
    [self didAddSubdescriptor:descriptor];
    [descriptor didMoveToSuperdescriptor];
}


- (void)bringSubdescriptorToFront:(TYMDescriptor *)descriptor {
    [self.mutableSubdescriptors removeObject:descriptor];
    [self.mutableSubdescriptors insertObject:descriptor atIndex:0];
}


- (void)sendSubdescriptorToBack:(TYMDescriptor *)descriptor {
    [self.mutableSubdescriptors removeObject:descriptor];
    [self.mutableSubdescriptors addObject:descriptor];
}


- (void)didAddSubdescriptor:(TYMDescriptor *)subdescriptor {
    // Nothing
}


- (void)willRemoveSubdescriptor:(TYMDescriptor *)subdescriptor {
    // Nothing
}


- (void)willMoveToSuperdescriptor:(TYMDescriptor *)newSuperdescriptor {
    // Nothing
}


- (void)didMoveToSuperdescriptor {
    // Nothing
}


- (BOOL)isDescendantOfDescriptor:(TYMDescriptor *)descriptor {
    return self == descriptor || self.superdescriptor == descriptor || [descriptor.subdescriptors containsObject:self];
}

@end
