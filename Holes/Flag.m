//
//  Flag.m
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "Flag.h"

@implementation Flag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// custom drawing for the flag
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
    
    // flag
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.2*width, 0.9*height);
    CGContextAddLineToPoint(context, 0.2*width, 0.1*height);
    CGContextAddLineToPoint(context, 0.8*width, 0.3*height);
    CGContextAddLineToPoint(context, 0.2*width, 0.5*height);
    CGContextClosePath(context);
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
