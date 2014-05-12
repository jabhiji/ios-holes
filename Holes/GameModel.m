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
@synthesize score, ballsLeft;
@synthesize numberOfHoles, xBH, yBH, radiusBH;
@synthesize ballInsideHole;

// specify black holes

- (void) resetHoles
{
    float xH, yH;
    
    xH = 0.25*width;
    yH = 0.25*height;
    [xBH insertObject:@(xH) atIndex:0];
    [yBH insertObject:@(yH) atIndex:0];
    
    xH = 0.75*width;
    yH = 0.25*height;
    [xBH insertObject:@(xH) atIndex:1];
    [yBH insertObject:@(yH) atIndex:1];
    
    xH = 0.50*width;
    yH = 0.50*height;
    [xBH insertObject:@(xH) atIndex:2];
    [yBH insertObject:@(yH) atIndex:2];
    
    xH = 0.25*width;
    yH = 0.75*height;
    [xBH insertObject:@(xH) atIndex:3];
    [yBH insertObject:@(yH) atIndex:3];
    
    xH = 0.75*width;
    yH = 0.75*height;
    [xBH insertObject:@(xH) atIndex:4];
    [yBH insertObject:@(yH) atIndex:4];
}

// Override superclass implementation of init

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        R = 15.0;

        ux = 0.0;
        uy = 0.0;
        COR = 0.45;
        
        ax = 0.0;
        ay = 0.0;
        
        score = 0;
        ballsLeft = 3;
        ballInsideHole = 0;
        
        numberOfHoles = 5;
        
        xBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        yBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        radiusBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        
        [xBH addObject:@(0.25*width)];
        [yBH addObject:@(0.25*height)];
        [radiusBH addObject:@(20.0)];
        
        [xBH addObject:@(0.75*width)];
        [yBH addObject:@(0.25*height)];
        [radiusBH addObject:@(20.0)];
        
        [xBH addObject:@(0.50*width)];
        [yBH addObject:@(0.50*height)];
        [radiusBH addObject:@(20.0)];
        
        [xBH addObject:@(0.25*width)];
        [yBH addObject:@(0.75*height)];
        [radiusBH addObject:@(20.0)];
        
        [xBH addObject:@(0.75*width)];
        [yBH addObject:@(0.75*height)];
        [radiusBH addObject:@(20.0)];
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

- (void) updateHoles
{
    // update hole positions and check if the ball falls inside the holes
    for (int i = 0; i < numberOfHoles; i++) {
        
        // initial location
        float xH = [[xBH objectAtIndex:i] floatValue];
        float yH = [[yBH objectAtIndex:i] floatValue];
        float rH = [[radiusBH objectAtIndex:i] floatValue];
        
        // translate
        xH += 1.0;
        yH += 1.0;
        [xBH insertObject:@(xH) atIndex:i];
        [yBH insertObject:@(yH) atIndex:i];
        
        float distance = sqrtf((x-xH)*(x-xH) + (y-yH)*(y-yH));
        
        if (distance < rH) {
            [self setInitialBallPosition];
            ux = 0.0;
            uy = 0.0;
            ballInsideHole = 1;
        }
    }
}

@end