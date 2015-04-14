//
//  TYMPage.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMDescriptor.h"

extern NSString *const kTYMPageAuthorKey;
extern NSString *const kTYMPageRevisionKey;
extern NSString *const kTYMPageNoteKey;
extern NSString *const kTYMPageNextPageKey;
extern NSString *const kTYMPagePreviousPageKey;

@interface TYMPage : TYMDescriptor

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *revision;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *previousPageName;
@property (nonatomic, copy) NSString *nextPageName;

+ (instancetype)pageNamed:(NSString *)name;
+ (instancetype)pageNamed:(NSString *)name inBundle:(NSBundle *)bundleOrNil;
+ (instancetype)pageWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (TYMPage *)nextPage;
- (TYMPage *)previousPage;

@end
