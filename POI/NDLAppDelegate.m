//
//  NDLAppDelegate.m
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NDLAppDelegate.h"


@implementation NDLAppDelegate

@synthesize window, viewController, navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[POITableViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
