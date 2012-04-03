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
#import "UIImage+POIType.h"

@interface POIMapViewController ()

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) NSArray *mapAnnotations;

- (void)listButtonTapped:(id)sender;

@end

@implementation POIMapViewController

@synthesize pointsOfInterest;
@synthesize mapAnnotations;
@synthesize mapView;

#pragma mark - view lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // configure map view
//    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view.superview addSubview:self.mapView];
    self.view = self.mapView;
    
    [self.mapView addAnnotations:self.mapAnnotations];
    
    POIMapPoint *point = [self.mapAnnotations objectAtIndex:0];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    // configure navigation item
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
    
//    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return !(orientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    self.mapView.frame = self.view.bounds;
}

#pragma mark - view ingress/egress

- (void)listButtonTapped:(id)sender {
    // go back to list view by dismissing this modal view controller
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
    // we create annotations a la table view cells
    annotationView = (MKPinAnnotationView*)[mv dequeueReusableAnnotationViewWithIdentifier:@"POIAnnotation"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"POIAnnotation"];
    }
    
    // set image on the left side of the annotation view
    POIMapPoint *point = annotation;
    UIImage *typeImage = [UIImage imageForPOIType:point.poi.type];
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:typeImage];
    // disclosure button on the right side
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // when the disclosure button is tapped, push a detail view on the nav stack
    POIMapPoint *point = view.annotation;
    POI *pointOfInterest = point.poi;
    POIDetailViewController *viewController = [[POIDetailViewController alloc] initWithPOI:pointOfInterest];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
