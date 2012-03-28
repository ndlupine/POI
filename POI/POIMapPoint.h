//
//  POIMapPoint.h
//  POI
//
//  Created by Nick Lupinetti on 3/27/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface POIMapPoint : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;


@end
