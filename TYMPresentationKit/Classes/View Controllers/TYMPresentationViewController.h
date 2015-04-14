//
//  TYMPresentationViewController.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import UIKit;

@class TYMPage;
@class TYMPageContentViewController;
@protocol TYMPresentationViewControllerDelegate;

@interface TYMPresentationViewController : UIViewController

@property (nonatomic, readonly) TYMPage *rootPage;
@property (nonatomic, readonly) TYMPage *currentPage;
@property (nonatomic, readonly) TYMPageContentViewController *currentPageContentViewController;
@property (nonatomic, weak) id<TYMPresentationViewControllerDelegate> delegate;

- (instancetype)initWithRootPage:(TYMPage *)aPage;
- (void)showNext;
- (void)showPrevious;

@end


@protocol TYMPresentationViewControllerDelegate <NSObject>
@optional
- (BOOL)presentationViewController:(TYMPresentationViewController *)viewController shouldShowNextPage:(TYMPage *)page;
- (void)presentationViewController:(TYMPresentationViewController *)viewController willShowNextPage:(TYMPage *)page;
- (void)presentationViewController:(TYMPresentationViewController *)viewController didShowNextPage:(TYMPage *)page;
- (BOOL)presentationViewController:(TYMPresentationViewController *)viewController shouldShowPreviousPage:(TYMPage *)page;
- (void)presentationViewController:(TYMPresentationViewController *)viewController willShowPreviousPage:(TYMPage *)page;
- (void)presentationViewController:(TYMPresentationViewController *)viewController didShowPreviousPage:(TYMPage *)page;
- (void)presentationViewControllerDidReachTheEnd;
- (void)presentationViewControllerDidReachTheBeginning;

@end
