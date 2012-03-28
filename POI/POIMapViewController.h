//
//  POIMapViewController.h
//  POI
//
//  Created by Nick Lupinetti on 3/27/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface POIMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic,strong) NSArray *pointsOfInterest;

@end
