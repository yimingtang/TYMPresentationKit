//
//  TYMPageViewController.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMPageContentViewController.h"

@interface TYMPageContentViewController ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSArray *renderedViews;
@end

@implementation TYMPageContentViewController

#pragma mark - Accessors

@synthesize page = _page;
@synthesize scrollView = _scrollView;
@synthesize renderedViews = _renderedViews;

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


#pragma mark - NSObject

- (instancetype)initWithPage:(TYMPage *)page {
    if ((self = [super init])) {
        _page = page;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self.renderedViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self.scrollView addSubview:view];
    }];
    
    [self setupViewConstraints];
}


#pragma mark - Private Methods

- (void)setupViewConstraints {
    
}
@end
