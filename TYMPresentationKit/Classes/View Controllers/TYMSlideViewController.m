//
//  TYMSlideViewController.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMSlideViewController.h"
#import "TYMSlide.h"

@interface TYMSlideViewController ()
@property (nonatomic) UIView *contentView;
@end

@implementation TYMSlideViewController

#pragma mark - Accessors

@synthesize slide = _slide;


#pragma mark - NSObject

- (instancetype)initWithSlide:(TYMSlide *)slide {
    if ((self = [super init])) {
        _slide = slide;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [self.slide renderView];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];
    
    [self setupViewConstraints];
}


#pragma mark - Private Methods

- (void)setupViewConstraints {
    NSDictionary *views = @{
        @"contentView": self.contentView,
    };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
}
@end
