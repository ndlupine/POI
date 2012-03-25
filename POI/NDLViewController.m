//
//  NDLViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NDLViewController.h"

@interface NDLViewController ()

@end

@implementation NDLViewController

@synthesize poiTableVC;

- (POITableViewController*)poiTableVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        poiTableVC = [[POITableViewController alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return poiTableVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.poiTableVC.view];
    
    CGRect tableFrame = self.poiTableVC.view.frame;
    self.poiTableVC.view.frame = CGRectOffset(tableFrame, 0, -20);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
