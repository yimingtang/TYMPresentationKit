//
//  TYMPresentationViewController.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import UIKit;

@class TYMSlide;
@class TYMSlideViewController;
@protocol TYMPresentationViewControllerDelegate;

@interface TYMPresentationViewController : UIViewController

@property (nonatomic, readonly) TYMSlide *rootSlide;
@property (nonatomic, readonly) TYMSlide *currentSlide;
@property (nonatomic, readonly) TYMSlideViewController *currentSlideViewController;
@property (nonatomic, weak) id<TYMPresentationViewControllerDelegate> delegate;

- (instancetype)initWithRootSlide:(TYMSlide *)aSlide;
- (void)showNext;
- (void)showPrevious;

@end


@protocol TYMPresentationViewControllerDelegate <NSObject>
@optional
- (BOOL)presentationViewController:(TYMPresentationViewController *)viewController shouldShowNextSlide:(TYMSlide *)slide;
- (void)presentationViewController:(TYMPresentationViewController *)viewController willShowNextSlide:(TYMSlide *)slide;
- (void)presentationViewController:(TYMPresentationViewController *)viewController didShowNextSlide:(TYMSlide *)slide;
- (BOOL)presentationViewController:(TYMPresentationViewController *)viewController shouldShowPreviousSlide:(TYMSlide *)slide;
- (void)presentationViewController:(TYMPresentationViewController *)viewController willShowPreviousSlide:(TYMSlide *)slide;
- (void)presentationViewController:(TYMPresentationViewController *)viewController didShowPreviousSlide:(TYMSlide *)slide;
- (void)presentationViewControllerDidReachTheEnd;
- (void)presentationViewControllerDidReachTheBeginning;

@end
