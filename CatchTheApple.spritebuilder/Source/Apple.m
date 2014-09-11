//
//  Obstacle.m
//  1stShot
//
//  Created by Faisal on 5/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Apple.h"
@implementation Apple {
    CCNode *_apple;
    int _random;
    int _yPosition;
}
// distance between top and bottom pipe
//static const CGFloat pipeDistance = 50.f;
//static const CGFloat scrollSpeed = 1.f;

- (void)setupRandomPosition {
    _random = arc4random() % 3;
    switch(_random)
    {
        case 0:
            _yPosition = 210; // hero position 330
//          _yPosition = 210;
            break;
        case 1:
            _yPosition = 290;//hero position 250
//          _yPosition = 210;
            break;
        case 2:
            _yPosition = 370; // hero position 170
//          _yPosition = 210;
            break;
//        case 3:
//            _yPosition = 450; // hero position 90
////          _yPosition = 210;
//            break;
        default:
            break;
    }
    _apple.position = ccp(_apple.position.x, _yPosition);
//    _bottomPipe.position = ccp(_bottomPipe.position.x, _topPipe.position.y + pipeDistance);
//    CCLOG(@"%d",_yPosition);
   //    CCLOG(@"%f",_bottomPipe.position.x);
//    CCLOG(@"%f",_topPipe.position.y);
}

- (void)didLoadFromCCB {
    _apple.physicsBody.collisionType = @"level";
    _apple.physicsBody.sensor = TRUE;
//    _bottomPipe.physicsBody.collisionType = @"level";
//    _bottomPipe.physicsBody.sensor = TRUE;
}

@end