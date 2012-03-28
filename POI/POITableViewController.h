//
//  POITableViewController.h
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POITableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic,strong) NSArray *poiList;
@property (nonatomic,strong) NSArray *sectionList;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UISearchDisplayController *searchCtrl;
@property (nonatomic,strong) NSArray *searchResultList;

@end
