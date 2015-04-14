//
//  TYMPlaceholderView.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/14/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMPlaceholderView.h"

@implementation TYMPlaceholderView

#pragma mark - Accessors

@synthesize textLabel = _textLabel;

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}


#pragma mark - Private Methods

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    [self setupViewConstraints];
}


- (void)setupViewConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
