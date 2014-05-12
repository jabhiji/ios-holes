//
//  ViewController.m
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize model;
@synthesize motionManager;
@synthesize greenTable;
@synthesize ball;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize Ball object
    CGRect viewRect = CGRectMake(100, 100, 40, 40);
    ball = [[Ball alloc] initWithFrame:viewRect];
    [ball setBackgroundColor:[UIColor clearColor]];
    
    // initialize model
    model = [[GameModel alloc] init];
    model.width  = greenTable.frame.size.width;
    model.height = greenTable.frame.size.height;
    [model setInitialBallPosition];

    // initialize motion manager
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 1.0/60.0;
    
    if ([motionManager isAccelerometerAvailable]) {
        
        [self startGameLoop];
        
    } else {
        
        NSLog(@"No accelerometer! You may be running on the iOS simulator...");
    }

}

// get acceleration data and animate ball motion based on current acceleration
- (void) startGameLoop
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // acceleration components (X, Y and Z)
            model.ax = accelerometerData.acceleration.x;
            model.ay = accelerometerData.acceleration.y;
        });
    }];
    
    // begin animation
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(update)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

// update model parameters and plot the ball using the view
- (void) update
{
    // update ball position
    [model updateBallPosition];
    
    // draw the ball at the new location
    float x = model.x;
    float y = model.y;
    float R = model.R;
    
    ball.frame = CGRectMake(x-R, y-R, 2*R, 2*R);
    [greenTable addSubview:ball];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
