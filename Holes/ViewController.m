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
@synthesize flag;
@synthesize holeArray;
@synthesize ballCount, showScore;
@synthesize timer;
@synthesize gameOverMessage;

// flag to check whether ball reached the flag
int reachedFlag = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // hide "GAME OVER" label
    gameOverMessage.hidden = YES;
    
    // initialize flag view
    CGRect flagRect = CGRectMake(0, 0, 30, 30);
    flag = [[Flag alloc] initWithFrame:flagRect];
    [flag setBackgroundColor:[UIColor clearColor]];
    [greenTable addSubview:flag];
    
    // clip things outside the view
    greenTable.clipsToBounds = YES;
    
    // initialize Ball object
    CGRect ballRect = CGRectMake(100, 100, 40, 40);
    ball = [[Ball alloc] initWithFrame:ballRect];
    [ball setBackgroundColor:[UIColor clearColor]];
    
    // initialize model
    model = [[GameModel alloc] init];
    model.width  = greenTable.frame.size.width;
    model.height = greenTable.frame.size.height;
    [model setInitialBallPosition];
    [model resetHoles];
    
    // initial score is zero
    showScore.text = [NSString stringWithFormat:@"%i",0];
    ballCount.text = [NSString stringWithFormat:@"%i",model.ballsLeft];

    // init holeArray
    holeArray = [[NSMutableArray alloc] initWithCapacity:model.numberOfHoles];

    // draw holes
    for (int i=0; i<model.numberOfHoles; i++) {
        float xH = [[model.xBH objectAtIndex:i] floatValue];
        float yH = [[model.yBH objectAtIndex:i] floatValue];
        float rH = [[model.radiusBH objectAtIndex:i] floatValue];
        CGRect holeRect = CGRectMake(xH-rH, yH-rH, 2*rH, 2*rH);
        Holes* holeView = [[Holes alloc] initWithFrame:holeRect];
        [holeArray addObject:holeView];
        [holeArray[i] setBackgroundColor:[UIColor clearColor]];
        [greenTable addSubview:holeArray[i]];
    }
    
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
    timer = [NSTimer timerWithTimeInterval:1.0/60.0
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
    
    // update hole positions
    [model updateHoles];

    // draw updated holes
    for (int i=0; i<model.numberOfHoles; i++) {
        float xH = [[model.xBH objectAtIndex:i] floatValue];
        float yH = [[model.yBH objectAtIndex:i] floatValue];
        float rH = [[model.radiusBH objectAtIndex:i] floatValue];
        CGRect holeRect = CGRectMake(xH-rH, yH-rH, 2*rH, 2*rH);
        [holeArray[i] setFrame:holeRect];
        [holeArray[i] setBackgroundColor:[UIColor clearColor]];
        [greenTable addSubview:holeArray[i]];
    }

    // check if ball falls inside a hole
    [model checkHoleFall];
    
    if (model.ballInsideHole == 1) {
        model.ballsLeft--;
        if (model.ballsLeft == 0) {
            NSLog(@"GAME OVER");
            [timer invalidate];
            timer = nil;
            // show "GAME OVER" label
            [greenTable bringSubviewToFront:gameOverMessage];
            gameOverMessage.hidden = NO;
        }
        ballCount.text = [NSString stringWithFormat:@"%i",model.ballsLeft];
        model.ballInsideHole = 0;
    }
    
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
        showScore.text = [NSString stringWithFormat:@"%i",model.score];
        reachedFlag = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restartGame:(id)sender {
    NSLog(@"RESTARTING GAME");
    
    // get rid of the "GAME OVER" label
    gameOverMessage.hidden = YES;
    
    [timer invalidate];
    timer = nil;

    [model setInitialBallPosition];
    [model resetHoles];
    
    model.score = 0;
    model.ballsLeft = 3;
    model.ballInsideHole = 0;
    
    showScore.text = [NSString stringWithFormat:@"%i",model.score];
    ballCount.text = [NSString stringWithFormat:@"%i",model.ballsLeft];
    
    // begin animation
    timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                    target:self
                                  selector:@selector(update)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

@end