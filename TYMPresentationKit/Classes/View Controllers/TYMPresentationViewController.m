//
//  TYMPresentationViewController.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMPresentationViewController.h"
#import "TYMPageContentViewController.h"
#import "TYMPlaceholderView.h"
#import "TYMPage.h"
#import "UIColor+TYMPresentationKit.h"

@interface TYMPresentationViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, readonly) UIPageViewController *pageViewController;
@property (nonatomic, readonly) UIButton *forwardButton;
@property (nonatomic, readonly) UIButton *reverseButton;
@property (nonatomic, readonly) UIView *noContentView;
@property (nonatomic) BOOL controlsHidden;

@end

@implementation TYMPresentationViewController

#pragma mark - Accessors

@dynamic currentPageContentViewController;
@dynamic currentPage;
@synthesize pageViewController = _pageViewController;
@synthesize forwardButton = _forwardButton;
@synthesize reverseButton = _reverseButton;
@synthesize noContentView = _noContentView;
@synthesize controlsHidden = _controlsHidden;
@synthesize rootPage = _rootPage;
@synthesize delegate = _delegate;

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}


- (UIView *)noContentView {
    if (!_noContentView) {
        TYMPlaceholderView *noContentView = [[TYMPlaceholderView alloc] init];
        noContentView.translatesAutoresizingMaskIntoConstraints = NO;
        noContentView.textLabel.text = @"No Content";
        _noContentView = noContentView;
    }
    return _noContentView;
}


- (UIButton *)reverseButton {
    if (!_reverseButton) {
        _reverseButton = [[UIButton alloc] init];
        _reverseButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _reverseButton;
}


- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [[UIButton alloc] init];
        _forwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _forwardButton;
}


- (TYMPageContentViewController *)currentPageContentViewController {
    return [self.pageViewController.viewControllers firstObject];
}


- (TYMPage *)currentPage {
    return self.currentPageContentViewController.page;
}


#pragma mark - NSObject

- (instancetype)initWithRootPage:(TYMPage *)aPage {
    if ((self = [super init])) {
        _rootPage = aPage;
    }
    return self;
}


#pragma mark - UIViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor tym_whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll ^ UIRectEdgeTop;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.reverseButton];
    [self.view addSubview:self.forwardButton];
    [self setupViewConstraints];
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls:)];
    [self.view addGestureRecognizer:tap];
    
    if (!self.rootPage) {
        return;
    }
    
    TYMPageContentViewController *pageContentViewController = [[TYMPageContentViewController alloc] initWithPage:self.rootPage];
    [self.pageViewController setViewControllers:@[pageContentViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderViews:animated];
}

#pragma mark - Actions

- (void)toggleControls:(id)sender {
    [self setControlsHidden:!self.controlsHidden animated:YES];
}


- (void)showNext {
    
}


- (void)showPrevious {
    
}


#pragma mark - Private Methods

- (BOOL)hasContent {
    return self.rootPage != nil;
}


- (void)updatePlaceholderViews:(BOOL)animated {
    // Disable animated changes for now since they are buggy
    animated = NO;
    
    if ([self hasContent]) {
        [self hideNoContentView:animated];
    } else {
        [self showNoContentView:animated];
    }
}


- (void)showNoContentView:(BOOL)animated {
    if (!self.noContentView || self.noContentView.superview) {
        return;
    }
    
    self.noContentView.alpha = 0.0f;
    [self.view addSubview:self.noContentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[noContentView]|" options:kNilOptions metrics:nil views:@{@"noContentView": self.noContentView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[noContentView]|" options:kNilOptions metrics:nil views:@{@"noContentView": self.noContentView}]];
    
    void (^change)(void) = ^{
        self.noContentView.alpha = 1.0f;
    };
    
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:change completion:nil];
    } else {
        change();
    }
}


- (void)hideNoContentView:(BOOL)animated {
    if (!self.noContentView || !self.noContentView.superview) {
        return;
    }
    
    void (^change)(void) = ^{
        self.noContentView.alpha = 0.0f;
    };
    
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        [self.noContentView removeFromSuperview];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:change completion:completion];
    } else {
        change();
        completion(YES);
    }
}


- (void)setControlsHidden:(BOOL)controlsHidden animated:(BOOL)animated {
    if (self.controlsHidden == controlsHidden) {
        return;
    }
    self.controlsHidden = controlsHidden;
    
    void (^animations)(void) = ^{
        self.forwardButton.alpha = controlsHidden ? 0.0 : 1.0;
        self.reverseButton.alpha = controlsHidden ? 0.0 : 1.0;
    };
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.controlsHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:self.controlsHidden animated:animated];
    
    if (animated) {
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:animations completion:nil];
    } else {
        animations();
    }
}


- (void)setupViewConstraints {
    NSDictionary *views = @{
        @"pageView": self.pageViewController.view,
        @"reverseButton": self.reverseButton,
        @"forwardButton": self.forwardButton
    };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[reverseButton]" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reverseButton]-20-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[forwardButton]-40-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[forwardButton]-20-|" options:kNilOptions metrics:nil views:views]];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    TYMPageContentViewController *pageContentViewController = (TYMPageContentViewController *)viewController;
    TYMPage *page = pageContentViewController.page;
    TYMPage *previousPage = [page previousPage];
    
    if (!previousPage) {
        return nil;
    }
    
    return [[TYMPageContentViewController alloc] initWithPage:previousPage];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    TYMPageContentViewController *pageContentViewController = (TYMPageContentViewController *)viewController;
    TYMPage *page = pageContentViewController.page;
    TYMPage *nextPage = [page nextPage];
    
    if (!nextPage) {
        return nil;
    }
    
    return [[TYMPageContentViewController alloc] initWithPage:nextPage];
}

@end
