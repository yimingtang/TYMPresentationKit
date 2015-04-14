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
NSString *const kTYMPageNextPageKey = @"next";
NSString *const kTYMPagePreviousPageKey = @"previous";


@implementation TYMPage

#pragma mark - Accessors

@synthesize note = _note;
@synthesize author = _author;
@synthesize revision = _revision;
@synthesize nextPageName = _nextPageName;
@synthesize previousPageName = _previousPageName;


#pragma mark - TYMDescriptor

+ (NSString *)descriptorTypeName {
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


- (UIView *)renderedView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *subViews = [NSMutableArray arrayWithCapacity:self.subdescriptors.count];
    [self.subdescriptors enumerateObjectsUsingBlock:^(TYMDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        UIView *view = [descriptor renderedView];
        if (view) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [subViews addObject:view];
            [scrollView addSubview:view];
        }
    }];
    
    UIView *lastView = nil;
    for (UIView *view in subViews) {
        if (lastView) {
            [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.0]];
        } else {
            [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:10.0]];
        }
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0.0]];
        
        lastView = view;
    }
    
    if (lastView) {
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0]];
    }
    
    return scrollView;
}


- (NSDictionary *)customDescriptorInfo {
    return @{
        kTYMPageAuthorKey: self.author,
        kTYMPageRevisionKey: self.revision,
        kTYMPageNoteKey: self.note,
        kTYMPagePreviousPageKey: self.previousPageName ? : [NSNull null],
        kTYMPageNextPageKey: self.nextPageName ? : [NSNull null],
    };
}


#pragma mark - Public

- (TYMPage *)nextPage {
    return [TYMPage descriptorNamed:self.nextPageName];
}


- (TYMPage *)previousPage {
    return [TYMPage descriptorNamed:self.previousPageName];
}

@end
