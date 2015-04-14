//
//  TYMPage.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import Foundation;

extern NSString *const kTYMPageAuthorKey;
extern NSString *const kTYMPageRevisionKey;
extern NSString *const kTYMPageNoteKey;
extern NSString *const kTYMPageDescriptorsKey;
extern NSString *const kTYMPageNextPageKey;
extern NSString *const kTYMPagePreviousPageKey;

@class TYMDescriptor;

@interface TYMPage : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *revision;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *previousPageName;
@property (nonatomic, copy) NSString *nextPageName;
@property (nonatomic, readonly) NSArray *descriptors;

+ (instancetype)pageNamed:(NSString *)name;
+ (instancetype)pageNamed:(NSString *)name inBundle:(NSBundle *)bundleOrNil;
+ (instancetype)pageWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (TYMPage *)nextPage;
- (TYMPage *)previousPage;
- (NSArray *)renderedViews;

- (void)removeDescriptorAtIndex:(NSUInteger)index;
- (void)addDescriptor:(TYMDescriptor *)descriptor;
- (void)exchangeDescriptorAtIndex:(NSUInteger)idx1 withDescriptorAtIndex:(NSUInteger)idx2;
- (void)insertDescriptor:(TYMDescriptor *)descriptor atIndex:(NSUInteger)index;

@end
