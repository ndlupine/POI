//
//  POIPriceRangeView.h
//  POI
//
//  Created by Nick Lupinetti on 3/26/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POIPriceRangeView : UIView

@property (nonatomic) NSUInteger dollarSigns;
@property (nonatomic) NSUInteger maxDollars;

- (void)setRange:(NSUInteger)numberOfDollarSigns outOf:(NSUInteger)max;

@end
