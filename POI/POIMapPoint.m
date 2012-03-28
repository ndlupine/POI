//
//  POIMapPoint.m
//  POI
//
//  Created by Nick Lupinetti on 3/27/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIMapPoint.h"

@implementation POIMapPoint

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize poi;


- (id)initWithPOI:(POI *)point {
    self = [super init];
    
    if (self) {
        self.POI = point;
    }
    
    return self;
}

- (void)setPOI:(POI *)point {
    double latitude = point.latitude.doubleValue;
    double longitude = point.longitude.doubleValue;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    
    self.coordinate = coord;
    self.title = point.name;
    
    NSString *type = point.type;
    
    if (point.subtype) {
        type = [type stringByAppendingFormat:@" - %@",point.subtype];
    }
    
    self.subtitle = type;
    
    poi = point;
}


@end
