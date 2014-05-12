//
//  ViewController.h
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "GameModel.h"
#import "Ball.h"
#import "Holes.h"

@interface ViewController : UIViewController

// model
@property (nonatomic, strong) GameModel* model;

// motion manager
@property (nonatomic, strong) CMMotionManager* motionManager;

// view where the game is played
@property (strong, nonatomic) IBOutlet UIView *greenTable;

// view in which the ball is drawn
@property (strong, nonatomic) Ball* ball;

// display the number of balls left
@property (strong, nonatomic) IBOutlet UILabel *ballCount;

// display the score
@property (strong, nonatomic) IBOutlet UILabel *showScore;

// view inside which the hole is drawn
@property (strong, nonatomic) Holes* hole;

@end
