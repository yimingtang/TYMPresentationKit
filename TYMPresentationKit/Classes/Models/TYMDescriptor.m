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
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize superdescriptor = _superdescriptor;
@synthesize mutableSubdescriptors = _mutableSubdescriptors;


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


+ (NSString *)descriptorName {
    // Subclasses may override this method
    return @"descriptor";
}


#pragma mark - NSObjecy

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
    [mutableDictionary setObject:[[self class] descriptorName] forKey:kTYMDescriptorTypeKey];
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
