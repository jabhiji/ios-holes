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
@synthesize ballCount, showScore;

// flag to check whether ball reached the flag
int reachedFlag = 0;

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
    [model createHoles];
    [self drawHoles];
    
    // initial score is zero
    showScore.text = [NSString stringWithFormat:@"%i",0];
    ballCount.text = [NSString stringWithFormat:@"%i",model.ballsLeft];
    
    // initialize motion manager
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 1.0/60.0;
    
    if ([motionManager isAccelerometerAvailable]) {
        
        [self startGameLoop];
        
    } else {
        
        NSLog(@"No accelerometer! You may be running on the iOS simulator...");
    }

}

- (void) drawHoles
{
    
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
    
    // check if ball reaches the flag
    if (x < 1.1*R && y < 1.1*R && reachedFlag == 0) {
        reachedFlag = 1;
        model.x = model.width - R;
        model.y = model.height - R;
        model.ux = 0.0;
        model.uy = 0.0;
        model.score ++;
        showScore.text    = [NSString stringWithFormat:@"%i",model.score];
        reachedFlag = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
