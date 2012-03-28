//
//  POIDetailViewController.h
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//
//  Show details for a given point of interest in a 
//  grouped table view with an expanding map and 
//  summary view sized to show the entire content

#import <UIKit/UIKit.h>
#import "POI.h"

@interface POIDetailViewController : UITableViewController <UIAlertViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) POI *selectedPOI;

- (id)initWithPOI:(POI*)poi;

@end
