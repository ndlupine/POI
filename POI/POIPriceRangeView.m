//
//  POIPriceRangeView.m
//  POI
//
//  Created by Nick Lupinetti on 3/26/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "POIPriceRangeView.h"

@implementation POIPriceRangeView

@synthesize dollarSigns,maxDollars;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxDollars = 3;
    }
    return self;
}

- (void)setRange:(NSUInteger)numberOfDollarSigns outOf:(NSUInteger)max {
    self.dollarSigns = numberOfDollarSigns;
    self.maxDollars = max;
}

@end
