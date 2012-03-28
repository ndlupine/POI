//
//  UIImage+POIType.m
//  POI
//
//  Created by Nick Lupinetti on 3/26/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "UIImage+POIType.h"

@implementation UIImage (POIType)

+ (UIImage*)imageForPOIType:(NSString*)type {
    return [UIImage imageNamed:type];
}

@end
