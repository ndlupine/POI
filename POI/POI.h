//
//  POI.h
//  POI
//
//  Created by Nick Lupinetti on 3/24/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    POIPriceLevelOne,
    POIPriceLevelTwo,
    POIPriceLEvelThree
}POIPriceLevel;

@interface POI : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *subtype;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSDecimalNumber *longitude;
@property (nonatomic,strong) NSDecimalNumber *latitude;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSArray *URLs;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,strong) NSDictionary *origData;

- (id)initWithAttributes:(NSDictionary*)attributes;


@end
