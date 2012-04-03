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
#import "POIMapPoint.h"

@interface POIDetailViewController ()

@property (nonatomic,strong) UIWebView *summaryView;
@property (nonatomic,strong) MKMapView *locationView;
@property (nonatomic,strong) NSArray *availableItems;
@property (nonatomic,strong) NSString *htmlContent;
@property (nonatomic) BOOL mapExpanded;

- (void)resizeFooterWithReload:(BOOL)reload;

@end

@implementation POIDetailViewController

@synthesize selectedPOI;
@synthesize summaryView;
@synthesize locationView;
@synthesize availableItems;
@synthesize htmlContent;
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
    
    self.navigationItem.title = self.selectedPOI.name;
    
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
    
    // hide the map's logo. google won't notice.
    CALayer *googleLogo = [self.locationView.layer.sublayers lastObject];
    
    if (googleLogo) {
        googleLogo.hidden = YES;
    }
    
    // set placemarker on map
    POIMapPoint *point = [[POIMapPoint alloc] initWithPOI:self.selectedPOI];
    [self.locationView addAnnotation:point];
    
    // set region for map
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 200, 200);
    [self.locationView setRegion:region];
    
    // configure webview footer for POI description
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(10, 0, cellWidth, 100)];
    self.tableView.tableFooterView = footer;
    
    // configure webview
    self.summaryView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 10, cellWidth, 100)];
    self.summaryView.backgroundColor = [UIColor lightGrayColor];
    self.summaryView.layer.cornerRadius = 10.0;
    self.summaryView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.summaryView.layer.borderWidth = 1.0;
    self.summaryView.clipsToBounds = YES;
    self.summaryView.delegate = self;
    [footer addSubview:self.summaryView];
    
    // insert webview content -- we'll resize based on content 
    // after webview has loaded it (using webview delegate method)
    NSString *css = @"<style type=\"text/css\">\
    body {\
        background-color:#F8F8F8;\
        font-family:Helvetica;\
        font-size:medium;\
        line-height:150%;\
    }</style>";
    
    NSString *content = self.selectedPOI.summary;
    
    if (!content) {
        content = NSLocalizedString(@"We're looking into it.", nil);
    }
    
    self.htmlContent = [NSString stringWithFormat:@"%@%@",css,content];
    [self.summaryView loadHTMLString:self.htmlContent baseURL:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.summaryView = nil;
    self.locationView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
//    NSLog(@"%@",self.selectedPOI);
    [self resizeFooterWithReload:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return !(orientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self resizeFooterWithReload:YES];
}

- (void)resizeFooterWithReload:(BOOL)reload {
    // resize the webview to show everything it contains
    // and size the containing footer view in relation
    
    UIView *footer = self.tableView.tableFooterView;
    
    CGRect webFrame = self.summaryView.frame;
    webFrame.size = CGSizeMake(footer.frame.size.width-20, 50);
    self.summaryView.frame = webFrame;
    
    if (reload) {
        [self.summaryView loadHTMLString:self.htmlContent baseURL:nil];
        return;
    }
    
    [self.summaryView sizeToFit];
    
    CGRect footerFrame = footer.frame;
    footerFrame.size.height = self.summaryView.bounds.size.height + 20;
    footer.frame = footerFrame;
    self.tableView.tableFooterView = footer;
}

#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // after web view loads, resize it to fit content
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self resizeFooterWithReload:NO];
}

#pragma mark - table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // store a list of the properties actually available for this POI
    NSMutableArray *items = [NSMutableArray array];
    
    if (self.selectedPOI.latitude && self.selectedPOI.longitude) {
        [items addObject:@"map"];
    }
    if (self.selectedPOI.address) {
        [items addObject:NSLocalizedString(@"Address", @"Address")];
    }
    if (self.selectedPOI.phoneNumber) {
        [items addObject:NSLocalizedString(@"Phone",@"Phone")];
    }
    if (self.selectedPOI.type || self.selectedPOI.subtype) {
        [items addObject:NSLocalizedString(@"Type", @"Type")];
    }
    if (self.selectedPOI.hours) {
        [items addObject:NSLocalizedString(@"Hours", @"Hours")];
    }
    
    self.availableItems = [items copy];
    
    return items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
//        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    //which cell are we currently creating?
    NSString *currentItem = [self.availableItems objectAtIndex:indexPath.section];
    cell.textLabel.text = currentItem;
    
    if ([currentItem isEqualToString:@"map"]) {
        cell.backgroundView = self.locationView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = nil;
    }
    
    if ([currentItem isEqualToString:NSLocalizedString(@"Address", @"Address")]) {
        cell.detailTextLabel.text = self.selectedPOI.address;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    if ([currentItem isEqualToString:NSLocalizedString(@"Phone", @"Phone")]) {
        cell.detailTextLabel.text = self.selectedPOI.phoneNumber;
    }
    
    if ([currentItem isEqualToString:NSLocalizedString(@"Type", @"Type")]) {
        cell.detailTextLabel.text = self.selectedPOI.fullType;
    }
    
    if ([currentItem isEqualToString:NSLocalizedString(@"Hours", @"Hours")]) {
        cell.detailTextLabel.text = self.selectedPOI.hours;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    return cell;
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // return the map cell's height as taller if it's been tapped
    NSString *selectedItem = [self.availableItems objectAtIndex:indexPath.section];
    
    if ([selectedItem isEqualToString:@"map"]) {
        return self.mapExpanded ? 370 : 100;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItem = [self.availableItems objectAtIndex:indexPath.section];
    
    // expand the map view when selected
    if ([selectedItem isEqualToString:@"map"]) {
        [self.tableView beginUpdates];
        self.mapExpanded = !self.mapExpanded;
        [self.tableView endUpdates];
    }
    
    if ([selectedItem isEqualToString:NSLocalizedString(@"Phone", @"Phone")]) {
        UIDevice *device = [UIDevice currentDevice];
        UIAlertView *alert;
        
        // make sure this is, you know... a phone
        if ([device.model isEqualToString:@"iPhone"]) {
            // show the number and offer to call/cancel
            alert = [[UIAlertView alloc] initWithTitle:self.selectedPOI.phoneNumber
                                               message:@""
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                     otherButtonTitles:NSLocalizedString(@"Call", nil), nil];
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
    
    // if they clicked the "call" button after tapping the phone number, place the call
    NSString *urlString = [NSString stringWithFormat:@"tel://%@",self.selectedPOI.phoneNumber];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSURL *dialURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:dialURL];
}
    

@end
