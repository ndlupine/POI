//
//  POI.m
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POI.h"

@implementation POI

@synthesize name;
@synthesize type;
@synthesize subtype;
@synthesize summary;
@synthesize longitude;
@synthesize latitude;
@synthesize address;
@synthesize phoneNumber;
@synthesize URLs;
@synthesize price;
@synthesize hours;
@synthesize origData;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    
    if (self) {
        self.name = [attributes valueForKey:@"name"];
        self.type = [attributes valueForKey:@"type"];
        self.subtype = [attributes valueForKey:@"subtype"];
        self.summary = [attributes valueForKeyPath:@"review.summary"];
        self.longitude = [attributes valueForKey:@"longitude"];
        self.latitude = [attributes valueForKey:@"latitude"];
        self.address = [attributes valueForKeyPath:@"address.street"];
        self.phoneNumber = [[attributes valueForKeyPath:@"telephones.click_to_dial"] lastObject];
        self.URLs = [attributes valueForKey:@"urls"];
        self.hours = [attributes valueForKey:@"hours"];
        self.price = [attributes valueForKey:@"price_range"];
        self.origData = attributes;
    }
    
    return self;
}

- (NSString*)description {
    return self.origData.description;
}

@end
