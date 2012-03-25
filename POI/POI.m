//
//  POI.m
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POI.h"

@implementation POI

@synthesize name,type,longitude,latitude,address,phoneNumber,URLs,price;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    
    if (self) {
        self.name = [attributes valueForKey:@"name"];
        self.type = [attributes valueForKey:@"type"];
        self.longitude = [attributes valueForKey:@"longitude"];
        self.latitude = [attributes valueForKey:@"latitude"];
        self.address = [attributes valueForKey:@"address"];
        self.phoneNumber = [attributes valueForKey:@"click_to_dial"];
        self.URLs = [attributes valueForKey:@"urls"];
        self.price = [attributes valueForKey:@"price"];
    }
    
    return self;
}

@end
