//
//  NDLAppDelegate.h
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDLViewController;

@interface NDLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NDLViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
