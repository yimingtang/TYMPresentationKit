//
//  TYMSlideViewController.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import UIKit;

@class TYMSlide;

@interface TYMSlideViewController : UIViewController

@property (nonatomic) TYMSlide *slide;

- (instancetype)initWithSlide:(TYMSlide *)slide;

@end
