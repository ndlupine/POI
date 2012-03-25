//
//  POITableViewController.m
//  POI
//
//  Created by Nick Lupinetti on 3/23/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POITableViewController.h"
#import "POI.h"

@interface POITableViewController ()

- (void)ingestPOIData;

@end

@implementation POITableViewController

@synthesize poiList,sectionList;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (NSArray*)poiList {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        poi
//    });
//}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self ingestPOIData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@",self.tableView.tableHeaderView);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.sectionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.sectionList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *poi = [[[self sectionList] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[poi valueForKey:@"name"]];
    [[cell detailTextLabel] setText:[poi valueForKey:@"type"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    UILocalizedIndexedCollation *currentCollation = [UILocalizedIndexedCollation currentCollation];
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
