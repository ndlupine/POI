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
//@property (nonatomic,strong) UILabel *addressLabel;
//@property (nonatomic,strong) UILabel *subtypeLabel;
//@property (nonatomic,strong) UIImageView *typeView;
//@property (nonatomic,strong) POIPriceRangeView *priceView;


@end

@implementation POIDetailViewController

@synthesize selectedPOI;
@synthesize summaryView;
@synthesize locationView;
@synthesize availableItems;
//@synthesize addressLabel;
//@synthesize subtypeLabel;
//@synthesize priceView;
//@synthesize typeView;

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(self.selectedPOI.name, nil);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat cellWidth = self.tableView.frame.size.width - 20;
    
    self.summaryView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, cellWidth, 150)];
    self.summaryView.backgroundColor = [UIColor lightGrayColor];
    self.summaryView.layer.cornerRadius = 10.0;
    self.summaryView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.summaryView.layer.borderWidth = 1.0;
    self.summaryView.clipsToBounds = YES;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(10, 0, cellWidth, 150)];
    [footer addSubview:self.summaryView];
    self.tableView.tableFooterView = footer;
//    [self.view addSubview:self.summaryView];
    
    self.locationView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, cellWidth, 100)];
    self.locationView.userInteractionEnabled = NO;
    self.locationView.layer.cornerRadius = 10.0;
    self.locationView.layer.borderColor = self.summaryView.layer.borderColor;
    self.locationView.layer.borderWidth = self.summaryView.layer.borderWidth;
    self.locationView.clipsToBounds = YES;
    
    CALayer *googleLogo = [self.locationView.layer.sublayers lastObject];
    
    if (googleLogo) {
        googleLogo.hidden = YES;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 120)];
    [header addSubview:self.locationView];
    self.tableView.tableHeaderView = header;
    
//    UILabel *addressView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 205, 20)];
//    self.addressLabel = addressView;
//    self.addressLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.addressLabel];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 45, 30, 30)];
//    self.typeView = imageView;
//    
//    UILabel *subtypeView = [[UILabel alloc] initWithFrame:CGRectMake(130, 45, 175, 20)];
//    self.subtypeLabel = subtypeView;
//    self.subtypeLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.subtypeLabel];
    
    //price view
    
//    NDLRoundedCornerView *cornerView = [[NDLRoundedCornerView alloc] initWithFrame:webView.bounds];
//    cornerView.backgroundColor = self.view.backgroundColor;
//    [self.summaryView addSubview:cornerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    NSLog(@"%@",self.selectedPOI);
    
    NSString *css = @"<style type=\"text/css\">\
    body {\
        background-color:#F8F8F8;\
        font-family:Helvetica;\
        line-height:150%;\
    }</style>";
    NSString *content = self.selectedPOI.summary;
    NSString *html = [NSString stringWithFormat:@"%@%@",css,content];
    [self.summaryView loadHTMLString:html baseURL:nil];
    
    double latitude = self.selectedPOI.latitude.doubleValue;
    double longitude = self.selectedPOI.longitude.doubleValue;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    [self.locationView setRegion:region];
    
    MapPoint *point = [[MapPoint alloc] init];
    point.coordinate = coordinate;
    [self.locationView addAnnotation:point];
    
//    self.addressLabel.text = self.selectedPOI.address;
//    self.subtypeLabel.text = self.selectedPOI.subtype;
//    self.typeView.image = [UIImage imageForPOIType:self.selectedPOI.type];
//    self.priceView.dollarSigns = self.selectedPOI.price.unsignedIntegerValue;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.summaryView sizeToFit];
    
    UIView *footer = self.tableView.tableFooterView;
    CGRect footerFrame = footer.frame;
    footerFrame.size.height = self.summaryView.bounds.size.height + 20;
    footer.frame = footerFrame;
    self.tableView.tableFooterView = footer;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    summaryView = nil;
    locationView = nil;
//    addressLabel = nil;
//    subtypeLabel = nil;
//    typeView = nil;
//    priceView = nil;
}

#pragma mark - table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *items = [NSMutableArray array];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = [self.availableItems objectAtIndex:indexPath.section];
    
    if ([selectedItem isEqualToString:@"phone"]) {
        <#statements#>
    }
}

@end
