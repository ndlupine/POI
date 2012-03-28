//
//  POIDetailViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIDetailViewController.h"
#import "POIPriceRangeView.h"
#import "UIImage+POIType.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "NDLRoundedCornerView.h"

@interface MapPoint : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@end

@implementation MapPoint

@synthesize coordinate,title,subtitle;

@end

@interface POIDetailViewController ()

@property (nonatomic,strong) UIWebView *summaryView;
@property (nonatomic,strong) MKMapView *locationView;
@property (nonatomic,strong) NSArray *availableItems;
@property (nonatomic) BOOL mapExpanded;

@end

@implementation POIDetailViewController

@synthesize selectedPOI;
@synthesize summaryView;
@synthesize locationView;
@synthesize availableItems;
@synthesize mapExpanded;

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithPOI:(POI *)poi {
    self = [self init];
    
    if (self) {
        self.selectedPOI = poi;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(self.selectedPOI.name, nil);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat cellWidth = self.tableView.frame.size.width - 20;
    
    // configure POI map
    self.locationView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, cellWidth, 100)];
    self.locationView.zoomEnabled = NO;
    self.locationView.scrollEnabled = NO;
    self.locationView.layer.cornerRadius = 10.0;
    self.locationView.layer.borderColor = self.summaryView.layer.borderColor;
    self.locationView.layer.borderWidth = self.summaryView.layer.borderWidth;
    self.locationView.clipsToBounds = YES;
    
    // hide POI map logo
    CALayer *googleLogo = [self.locationView.layer.sublayers lastObject];
    
    if (googleLogo) {
        googleLogo.hidden = YES;
    }
    
    // set region for map
    double latitude = self.selectedPOI.latitude.doubleValue;
    double longitude = self.selectedPOI.longitude.doubleValue;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    [self.locationView setRegion:region];
    
    // set placemarker on map
    MapPoint *point = [[MapPoint alloc] init];
    point.coordinate = coordinate;
    [self.locationView addAnnotation:point];
    
    // configure webview footer for POI description
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(10, 0, cellWidth, 150)];
    [footer addSubview:self.summaryView];
    self.tableView.tableFooterView = footer;
    
    // configure webview
    self.summaryView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, cellWidth, 150)];
    self.summaryView.backgroundColor = [UIColor lightGrayColor];
    self.summaryView.layer.cornerRadius = 10.0;
    self.summaryView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.summaryView.layer.borderWidth = 1.0;
    self.summaryView.clipsToBounds = YES;
    self.summaryView.delegate = self;
    
    // insert webview content -- we'll resize based on content 
    // after webview has loaded it (using webview delegate method)
    NSString *css = @"<style type=\"text/css\">\
    body {\
        background-color:#F8F8F8;\
        font-family:Helvetica;\
        line-height:150%;\
    }</style>";
    NSString *content = self.selectedPOI.summary;
    NSString *html = [NSString stringWithFormat:@"%@%@",css,content];
    [self.summaryView loadHTMLString:html baseURL:nil];
    
    //price view
    
//    NDLRoundedCornerView *cornerView = [[NDLRoundedCornerView alloc] initWithFrame:webView.bounds];
//    cornerView.backgroundColor = self.view.backgroundColor;
//    [self.summaryView addSubview:cornerView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.summaryView = nil;
    self.locationView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    NSLog(@"%@",self.selectedPOI);
}

#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.summaryView sizeToFit];
    
    UIView *footer = self.tableView.tableFooterView;
    CGRect footerFrame = footer.frame;
    footerFrame.size.height = self.summaryView.bounds.size.height + 20;
    footer.frame = footerFrame;
    self.tableView.tableFooterView = footer;
}

#pragma mark - table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *items = [NSMutableArray array];
    if (self.selectedPOI.latitude && self.selectedPOI.longitude) {
        [items addObject:@"map"];
    }
    if (self.selectedPOI.address) {
        [items addObject:@"address"];
    }
    if (self.selectedPOI.subtype || self.selectedPOI.subtype) {// || self.selectedPOI.price) {
        [items addObject:@"type"];
    }
    if (self.selectedPOI.phoneNumber) {
        [items addObject:@"phone"];
    }
    if (self.selectedPOI.hours) {
        [items addObject:@"hours"];
    }
    
    self.availableItems = [items copy];
    
    return items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    //which cell are we currently creating?
    NSString *currentItem = [self.availableItems objectAtIndex:indexPath.section];
    
    if ([currentItem isEqualToString:@"map"]) {
        cell.backgroundView = self.locationView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([currentItem isEqualToString:@"address"]) {
        cell.textLabel.text = self.selectedPOI.address;
    }
    
    if ([currentItem isEqualToString:@"type"]) {
        NSString *cellText = self.selectedPOI.type;
        
        if (self.selectedPOI.subtype) {
            cellText = [NSString stringWithFormat:@"%@ - %@",cellText,self.selectedPOI.subtype];
        }
//        if (self.selectedPOI.price) {
//            cellText = [NSString stringWithFormat:@"%@ price", cellText];
//        }
        
        cell.textLabel.text = cellText;
    }
    
    if ([currentItem isEqualToString:@"phone"]) {
        cell.textLabel.text = self.selectedPOI.phoneNumber;
    }
    
    if ([currentItem isEqualToString:@"hours"]) {
        cell.textLabel.text = self.selectedPOI.hours;
    }
    
    return cell;
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = [self.availableItems objectAtIndex:indexPath.section];
    
    if ([selectedItem isEqualToString:@"map"]) {
        return self.mapExpanded ? 370 : 100;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = [self.availableItems objectAtIndex:indexPath.section];
    
    if ([selectedItem isEqualToString:@"map"]) {
        [self.tableView beginUpdates];
        self.mapExpanded = !self.mapExpanded;
        [self.tableView endUpdates];
    }
    
    if ([selectedItem isEqualToString:@"phone"]) {
        UIDevice *device = [UIDevice currentDevice];
        UIAlertView *alert;
        
        if ([device.model isEqualToString:@"iPhone"]) {
            alert = [[UIAlertView alloc] initWithTitle:self.selectedPOI.phoneNumber
                                               message:@""
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not Permitted",nil)
                                               message:NSLocalizedString(@"Your device cannot dial this phone number.",nil)
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                     otherButtonTitles:nil];
        }
        
        [alert show];
    }
    
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *selectedCell = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedCell animated:YES];

    if (buttonIndex == 0) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@",self.selectedPOI.phoneNumber];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSURL *dialURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:dialURL];
}
    

@end
