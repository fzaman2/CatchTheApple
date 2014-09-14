//
//  Obstacle.m
//  1stShot
//
//  Created by Faisal on 5/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Apple.h"
@implementation Apple
//{
//    CCNode *_apple;
//    int _random;
//    int _xPosition;
//   CGFloat _elapsedTime;
//
//}
//// distance between top and bottom pipe
////static const CGFloat pipeDistance = 50.f;
////static const CGFloat scrollSpeed = 1.f;
//
//- (void)setupRandomPosition {
//    _random = arc4random() % 4;
//    switch(_random)
//    {
//        case 0:
//            _xPosition = 110; // hero position 330
////          _yPosition = 210;
//            break;
//        case 1:
//            _xPosition = 110;//hero position 250
////          _yPosition = 210;
//            break;
//        case 2:
//            _xPosition = 110; // hero position 170
////          _yPosition = 210;
//            break;
//        case 3:
//            _xPosition = 110; // hero position 90
////          _yPosition = 210;
//            break;
//        default:
//            break;
//    }
//    _apple.position = ccp(_xPosition, _apple.position.y);
////    _bottomPipe.position = ccp(_bottomPipe.position.x, _topPipe.position.y + pipeDistance);
////    CCLOG(@"%d",_yPosition);
//   //    CCLOG(@"%f",_bottomPipe.position.x);
////    CCLOG(@"%f",_topPipe.position.y);
//}
//
//-(void)update:(CCTime)delta
//{
//      _elapsedTime += delta;
//      if(_elapsedTime > 0.5)
//      {
//         self.position = ccp(self.position.x, self.position.y + delta/4);
         //            CCLOG(@"%f",_target.position.y);
//      }
//}

- (void)didLoadFromCCB {
   self.physicsBody.collisionType = @"level";

//    _apple.physicsBody.collisionType = @"level";
//    _apple.physicsBody.sensor = TRUE;
//    _bottomPipe.physicsBody.collisionType = @"level";
//    _bottomPipe.physicsBody.sensor = TRUE;
}

@end