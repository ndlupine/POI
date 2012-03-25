//
//  POIDetailViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIDetailViewController.h"

@interface POIDetailViewController ()

@property (nonatomic,weak) UIWebView *summaryView;

@end

@implementation POIDetailViewController

@synthesize selectedPOI;
@synthesize summaryView;

//- (void)setSelectedPOI:(POI *)poi {
//    selectedPOI = poi;
//    
//    self.summaryView.text = poi.summary;
//}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(self.selectedPOI.name, nil);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 50, 290, 350)];
    self.summaryView = webView;
    self.summaryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.summaryView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *css = @"<style type=\"text/css\">body{font-family:Baskerville;}</style>";
    NSString *content = self.selectedPOI.summary;
    NSString *html = [NSString stringWithFormat:@"%@%@",css,content];
    [self.summaryView loadHTMLString:html baseURL:nil];
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
