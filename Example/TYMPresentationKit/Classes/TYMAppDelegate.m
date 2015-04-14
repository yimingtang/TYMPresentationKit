//
//  TYMAppDelegate.m
//  TYMPresentationKit
//
//  Created by Yiming Tang on 04/13/2015.
//  Copyright (c) 2015 Yiming Tang. All rights reserved.
//

#import "TYMAppDelegate.h"
#import "TYMDemoViewController.h"
#import  <TYMPresentationKit/TYMPage.h>

@implementation TYMAppDelegate

#pragma mark - Accessors

@synthesize window = _window;

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[TYMDemoViewController alloc] initWithRootPage:[TYMPage descriptorNamed:@"page-1"]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
