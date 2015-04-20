//
//  TYMSlideRenderer.m
//  TYMPrensentationKit
//
//  Created by Yiming Tang on 4/20/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMSlideRenderer.h"
#import "TYMDescriptor.h"

@implementation TYMSlideRenderer

#pragma mark - TYMRenderer

- (UIView *)renderView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *subViews = [NSMutableArray arrayWithCapacity:self.descriptor.subdescriptors.count];
    [self.descriptor.subdescriptors enumerateObjectsUsingBlock:^(TYMDescriptor *descriptor, NSUInteger idx, BOOL *stop) {
        UIView *view = [descriptor renderView];
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

@end
