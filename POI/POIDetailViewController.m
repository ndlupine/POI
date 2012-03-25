//
//  POIDetailViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIDetailViewController.h"

@interface POIDetailViewController ()

@end

@implementation POIDetailViewController

@synthesize selectedPOI;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(self.selectedPOI.name, nil);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
