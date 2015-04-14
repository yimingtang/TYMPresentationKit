//
//  TYMPageViewController.h
//  TYMPresentationKit
//
//  Created by Yiming Tang on 4/13/15.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

@import UIKit;

@class TYMPage;

@interface TYMPageContentViewController : UIViewController

@property (nonatomic) TYMPage *page;

- (instancetype)initWithPage:(TYMPage *)page;

@end
