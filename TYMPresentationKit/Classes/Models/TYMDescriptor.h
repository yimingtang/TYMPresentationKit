//
//  TYMDescriptor.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import Foundation;

extern NSString *const kTYMDescriptorTypeKey;
extern NSString *const kTYMDescriptorSubdescriptorsKey;

@protocol TYMDescriptorDelegate;

@interface TYMDescriptor : NSObject

@property (nonatomic, copy, readonly) NSString *name; // usually file name
@property (nonatomic) NSInteger tag;
@property (nonatomic, weak) id<TYMDescriptorDelegate> delegate;

+ (NSString *)descriptorTypeName;
+ (instancetype)descriptorWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)descriptorNamed:(NSString *)name;
+ (instancetype)descriptorNamed:(NSString *)name inBundle:(NSBundle *)bundleOrNil;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithContentsOfFile:(NSString *)path;
- (UIView *)renderedView;
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)customDescriptorInfo;


///----------------------------------------
/// @name Managing the Descriptor Hierarchy
///----------------------------------------

@property (nonatomic, weak, readonly) TYMDescriptor *superdescriptor;
@property (nonatomic, copy, readonly) NSArray *subdescriptors;

- (void)removeFromSuperdescriptor;
- (void)insertSubdescriptor:(TYMDescriptor *)descriptor atIndex:(NSInteger)index;
- (void)exchangeSubdescriptorAtIndex:(NSInteger)index1 withSubdescriptorAtIndex:(NSInteger)index2;

- (void)addSubdescriptor:(TYMDescriptor *)descriptor;
- (void)insertSubdescriptor:(TYMDescriptor *)descriptor afterSubdescriptor:(TYMDescriptor *)siblingSubdescriptor;
- (void)insertSubdescriptor:(TYMDescriptor *)descriptor beforeSubdescriptor:(TYMDescriptor *)siblingSubdescriptor;

- (void)bringSubdescriptorToFront:(TYMDescriptor *)descriptor;
- (void)sendSubdescriptorToBack:(TYMDescriptor *)descriptor;

- (void)didAddSubdescriptor:(TYMDescriptor *)subdescriptor;
- (void)willRemoveSubdescriptor:(TYMDescriptor *)subdescriptor;

- (void)willMoveToSuperdescriptor:(TYMDescriptor *)newSuperdescriptor;
- (void)didMoveToSuperdescriptor;

- (BOOL)isDescendantOfDescriptor:(TYMDescriptor *)descriptor;

@end


@protocol TYMDescriptorDelegate <NSObject>
@end
