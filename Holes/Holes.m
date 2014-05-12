//
//  Holes.m
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "Holes.h"

@implementation Holes

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// custom drawing of a black hole
- (void)drawRect:(CGRect)rect
{
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // context size in pixels
    size_t WIDTH = CGBitmapContextGetWidth(context);
    size_t HEIGHT = CGBitmapContextGetHeight(context);
    
    // for retina display, 1 point = 2 pixels
    // context size in screen points
    float width = WIDTH/2.0;
    float height = HEIGHT/2.0;
    
    // center coordinates
    float xCen = width/2.0;
    float yCen = height/2.0;
    float maxR = width/2.0;     // WIDTH = HEIGHT in this case
    
    // big circle to fill corners
    CGContextBeginPath(context);
    CGContextAddArc(context, xCen, yCen, maxR, 0, 2*M_PI, YES);
    [[UIColor blackColor] setFill];
    CGContextDrawPath(context, kCGPathFill);
}

@end
