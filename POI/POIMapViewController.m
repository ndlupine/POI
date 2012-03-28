//
//  POIMapViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/27/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIMapViewController.h"
#import "POIDetailViewController.h"
#import "POI.h"
#import "POIMapPoint.h"

@interface POIMapViewController ()

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) NSArray *mapAnnotations;

- (void)listButtonTapped:(id)sender;

@end

@implementation POIMapViewController

@synthesize pointsOfInterest;
@synthesize mapAnnotations;
@synthesize mapView;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self.mapView addAnnotations:self.mapAnnotations];
    
    POIMapPoint *point = [self.mapAnnotations objectAtIndex:0];
    CLLocationCoordinate2D coord = point.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    self.navigationItem.title = NSLocalizedString(@"Map", @"Map");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"List",@"List");
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(listButtonTapped:);
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
    
    for (POI *poi in POIs) {
        POIMapPoint *point = [[POIMapPoint alloc] initWithPOI:poi];
        [mapPoints addObject:point];
    }
    
    self.mapAnnotations = [mapPoints copy];
}

#pragma mark - map view delegate

- (MKAnnotationView*)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView;
    
    annotationView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:@"POIAnnotation"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"POIAnnotation"];
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    POIMapPoint *point = view.annotation;
    POI *pointOfInterest = point.poi;
    POIDetailViewController *viewController = [[POIDetailViewController alloc] initWithPOI:pointOfInterest];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
