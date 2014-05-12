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
@synthesize dtheta;

// specify black holes

- (void) resetHoles
{
    float xH, yH;
    
    xH = 0.2*width;
    yH = 0.2*height;
    [xBH insertObject:@(xH) atIndex:0];
    [yBH insertObject:@(yH) atIndex:0];
    
    xH = 0.8*width;
    yH = 0.2*height;
    [xBH insertObject:@(xH) atIndex:1];
    [yBH insertObject:@(yH) atIndex:1];
    
    xH = 0.5*width;
    yH = 0.5*height;
    [xBH insertObject:@(xH) atIndex:2];
    [yBH insertObject:@(yH) atIndex:2];
    
    xH = 0.2*width;
    yH = 0.8*height;
    [xBH insertObject:@(xH) atIndex:3];
    [yBH insertObject:@(yH) atIndex:3];
    
    xH = 0.8*width;
    yH = 0.8*height;
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
        dtheta = M_1_PI/1000;

        xBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        yBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        radiusBH = [[NSMutableArray alloc] initWithCapacity:numberOfHoles];
        
        [xBH addObject:@(0.2*width)];
        [yBH addObject:@(0.2*height)];
        [radiusBH addObject:@(25.0)];
        
        [xBH addObject:@(0.8*width)];
        [yBH addObject:@(0.2*height)];
        [radiusBH addObject:@(25.0)];
        
        [xBH addObject:@(0.5*width)];
        [yBH addObject:@(0.5*height)];
        [radiusBH addObject:@(25.0)];
        
        [xBH addObject:@(0.2*width)];
        [yBH addObject:@(0.8*height)];
        [radiusBH addObject:@(25.0)];
        
        [xBH addObject:@(0.8*width)];
        [yBH addObject:@(0.8*height)];
        [radiusBH addObject:@(25.0)];
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
    
    // trajectory inside the holes
    float acc_x = 0.0;
    float acc_y = 0.0;
    for (int i = 0; i < numberOfHoles; i++) {
        
        // initial location
        float xH = [[xBH objectAtIndex:i] floatValue];
        float yH = [[yBH objectAtIndex:i] floatValue];
        float rH = [[radiusBH objectAtIndex:i] floatValue];
        
        float distance = sqrtf((x-xH)*(x-xH) + (y-yH)*(y-yH));
        
        if (distance < rH) {
            // non-dimensional distance
            float dis = distance/rH;
            
            // force magnitude (force is center-to-center)
            if (dis > 0.1 && dis < 1) {
                float fBH = 0.5/(dis*dis);
                float COSINE = ((xH - x)/rH)/dis;
                float SINE   = ((yH - y)/rH)/dis;
                
                // force components
                acc_x = fBH*COSINE;
                acc_y = -fBH*SINE;
                
                // velocity reduces
                ux = 0.8*ux;
                uy = 0.8*uy;
            }
        }
    }
    
    // dynamics
    ux += 0.2*(ax + acc_x);
    uy += 0.2*(ay + acc_y);
}

// rotate the hole pattern
- (void) updateHoles
{
    // update hole positions and check if the ball falls inside the holes
    for (int i = 0; i < numberOfHoles; i++) {
        
        // initial location
        float xH = [[xBH objectAtIndex:i] floatValue];
        float yH = [[yBH objectAtIndex:i] floatValue];
        
        // translate pattern to origin
        xH -= width/2.0;
        yH -= height/2.0;
        
        // rotate about the origin
        float xnew =  xH*cosf(dtheta) + yH*sinf(dtheta);
        float ynew = -xH*sinf(dtheta) + yH*cosf(dtheta);

        // translate back
        xnew += width/2.0;
        ynew += height/2.0;
        
        xBH[i] = @(xnew);
        yBH[i] = @(ynew);
    }
}

- (void) checkHoleCapture
{
    // check if the ball is captured by the holes
    for (int i = 0; i < numberOfHoles; i++) {
        
        // initial location
        float xH = [[xBH objectAtIndex:i] floatValue];
        float yH = [[yBH objectAtIndex:i] floatValue];
        float rH = [[radiusBH objectAtIndex:i] floatValue];

        float distance = sqrtf((x-xH)*(x-xH) + (y-yH)*(y-yH));
        
        if (distance < 0.1*rH) {
            [self setInitialBallPosition];
            ux = 0.0;
            uy = 0.0;
            ballInsideHole = 1;
        }
    }
}

@end