//
//  GameModel.h
//  Holes
//
//  Created by Abhijit Joshi on 5/12/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

// center of the ball
@property float x, y, R;

// ball velocity
@property float ux, uy;

// coefficient of restitution
@property float COR;

// ball acceleration
@property float ax, ay;

// view size in points
@property float width;
@property float height;

// methods
- (void) setInitialBallPosition;
- (void) updateBallPosition;

@end