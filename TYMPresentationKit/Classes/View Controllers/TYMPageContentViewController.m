//
//  TYMPageViewController.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMPageContentViewController.h"
#import "TYMPage.h"

@interface TYMPageContentViewController ()
@property (nonatomic) UIView *contentView;
@end

@implementation TYMPageContentViewController

#pragma mark - Accessors

@synthesize page = _page;


#pragma mark - NSObject

- (instancetype)initWithPage:(TYMPage *)page {
    if ((self = [super init])) {
        _page = page;
        NSLog(@"%@", page);
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentView = [self.page renderedView];
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
