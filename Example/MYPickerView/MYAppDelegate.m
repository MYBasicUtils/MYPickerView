//
//  MYAppDelegate.m
//  MYPickerView
//
//  Created by wenmingyan1990@gmail.com on 09/04/2019.
//  Copyright (c) 2019 wenmingyan1990@gmail.com. All rights reserved.
//

#import "MYAppDelegate.h"
#import "MYViewController.h"

@implementation MYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[MYViewController alloc] init]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _window;
}

@end
