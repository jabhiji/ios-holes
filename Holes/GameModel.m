//
//  GameModel.m
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
@synthesize x, y, R;
@synthesize ux, uy, COR;
@synthesize ax, ay;
@synthesize width, height;

// Override superclass implementation of init

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        R = 10.0;

        ux = 0.0;
        uy = 0.0;
        COR = 0.5;
        
        ax = 0.0;
        ay = 0.0;
    }
    
    return self;
}

// initialize ball at the lower right of the view
- (void) setInitialBallPosition
{
    x = width - R;
    y = height - R;
}

- (void) updateBallPosition
{
    // update velocity
    ux += 0.2*ax;
    uy += 0.2*ay;
    
    // update position
    x += 0.5*ux;
    y += -0.5*uy;

    // check for collisions with walls
    if (x > width - R) {
        x = width - R;
        ux = -fabsf(ux)*COR;
    }
    if (y > height - R) {
        y = height - R;
        uy = fabsf(uy)*COR;
    }
    if (x < R) {
        x = R;
        ux = fabsf(ux)*COR;
    }
    if (y < R) {
        y = R;
        uy = -fabsf(uy)*COR;
    }
}

@end