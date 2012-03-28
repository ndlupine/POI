//
//  POIMapViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/27/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIMapViewController.h"
#import "POI.h"
#import "POIMapPoint.h"
#import <MapKit/MapKit.h>

@interface POIMapViewController ()

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) UIButton *listButton;
@property (nonatomic,strong) NSArray *mapAnnotations;

- (void)listButtonTapped:(id)sender;

@end

@implementation POIMapViewController

@synthesize pointsOfInterest;
@synthesize mapAnnotations;
@synthesize mapView;
@synthesize listButton;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    [self.mapView addAnnotations:self.mapAnnotations];
    
    POIMapPoint *point = [self.mapAnnotations objectAtIndex:0];
    CLLocationCoordinate2D coord = point.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    self.listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.listButton.frame = CGRectMake(265, 7, 50, 32);
    [self.listButton setTitle:NSLocalizedString(@"List",@"List") forState:UIControlStateNormal];
    [self.listButton addTarget:self action:@selector(listButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.listButton];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.mapView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)listButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setPointsOfInterest:(NSArray *)POIs {
    pointsOfInterest = POIs;
    NSMutableArray *mapPoints = [NSMutableArray arrayWithCapacity:POIs.count];
    
    @autoreleasepool {
        for (POI *poi in POIs) {
            double latitude = poi.latitude.doubleValue;
            double longitude = poi.longitude.doubleValue;
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
            
            POIMapPoint *point = [[POIMapPoint alloc] init];
            point.coordinate = coord;
            point.title = poi.name;
            
            NSString *type = poi.type;
            
            if (poi.subtype) {
                type = [type stringByAppendingFormat:@" - %@",poi.subtype];
            }
            
            point.subtitle = type;
            [mapPoints addObject:point];
        }
    }
    
    self.mapAnnotations = [mapPoints copy];
}

@end
