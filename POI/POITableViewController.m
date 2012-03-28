//
//  POITableViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POITableViewController.h"
#import "POI.h"
#import "POIDetailViewController.h"
#import "POIMapViewController.h"
#import "UIImage+POIType.h"


@interface POITableViewController ()

- (void)ingestPOIData;
- (POI*)poiAtIndexPath:(NSIndexPath*)indexPath;
- (void)flipToMap:(id)sender;

@end



@implementation POITableViewController

@synthesize poiList;
@synthesize sectionList;
@synthesize searchBar;
@synthesize searchResultList;
@synthesize searchCtrl;

#pragma mark - Data handling

- (POI*)poiAtIndexPath:(NSIndexPath*)indexPath {
    // convenience method for finding 
    NSArray *section = [self.sectionList objectAtIndex:indexPath.section];
    return [section objectAtIndex:indexPath.row];
}

- (void)setPoiList:(NSArray *)array {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    poiList = array;
    
    NSMutableArray *sections = [NSMutableArray array];
    
    for (POI *poi in poiList) {
        NSUInteger section = [collation sectionForObject:poi 
                                 collationStringSelector:@selector(name)];
        
        while (sections.count <= section) {
            [sections addObject:[NSMutableArray array]];
        }
        
        [[sections objectAtIndex:section] addObject:poi];
    }
    
    for (NSUInteger section = 0; section < sections.count; section++) {
        NSArray *thisSection = [sections objectAtIndex:section];
        NSArray *sortedSection = [collation sortedArrayFromArray:thisSection
                                         collationStringSelector:@selector(name)];
        [sections replaceObjectAtIndex:section withObject:sortedSection];
    }
    
    self.sectionList = sections;
}

- (void)ingestPOIData {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [bundlePath stringByAppendingPathComponent:@"pois.json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath];
    NSArray *JSONList = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
    
    NSMutableArray *POIs = [NSMutableArray arrayWithCapacity:[JSONList count]];
    
    for (NSDictionary *dictionary in JSONList) {
        [POIs addObject:[[POI alloc] initWithAttributes:[dictionary valueForKey:@"poi"]]];
    }
    
    [self setPoiList:POIs];
}

- (void)flipToMap:(id)sender {
    POIMapViewController *mapController = [[POIMapViewController alloc] init];
    mapController.pointsOfInterest = self.poiList;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mapController];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:nav animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ingestPOIData];
    
    self.navigationItem.title = NSLocalizedString(@"Points of Interest", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"POIs", @"POIs");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Map", @"Map");
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(flipToMap:);
    
    CGSize contentSize = self.tableView.contentSize;
    contentSize.height += 40;
    self.tableView.contentSize = contentSize;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-20, 44)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    self.searchCtrl = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchCtrl.delegate = self;
    self.searchCtrl.searchResultsDataSource = self;
    self.searchCtrl.searchResultsDelegate = self;
    
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.searchBar = nil;
    self.searchCtrl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultList.count;
        
    }
    
    return [[self.sectionList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    POI *poi;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        poi = [self.searchResultList objectAtIndex:indexPath.row];
    }
    else {
        poi = [self poiAtIndexPath:indexPath];
    }
    
    [[cell textLabel] setText:[poi name]];
    [[cell detailTextLabel] setText:[poi fullType]];
    [[cell imageView] setImage:[UIImage imageForPOIType:[poi type]]];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {  
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    
    NSArray *search = [NSArray arrayWithObject:UITableViewIndexSearch];
    NSArray *titles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    return [search arrayByAddingObjectsFromArray:titles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    }
    
    if (title == UITableViewIndexSearch) {
        [self.tableView scrollRectToVisible:self.searchBar.frame animated:YES];
        return -1;
    }
    
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index - 1];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    POI *poi = [self poiAtIndexPath:indexPath];
    
    POIDetailViewController *detailVC = [[POIDetailViewController alloc] init];
    detailVC.selectedPOI = poi;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.poiList.count];
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"subtype contains[cd] %@",searchString];
    NSArray *predicateArray = [NSArray arrayWithObjects:namePredicate,typePredicate, nil];
    NSPredicate *searchPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
    
    for (POI* poi in self.poiList) {
        if ([searchPredicate evaluateWithObject:poi]) {
            [results addObject:poi];
        }
    }
    
    self.searchResultList = [results copy];
    
    return YES;
}

@end
