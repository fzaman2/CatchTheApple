//
//  Apple.h
//  CatchTheApple
//
//  Created by Faisal on 10/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Apple : CCSprite

@property (nonatomic, assign) BOOL Dropped;
@property (nonatomic, assign) NSInteger Number;
@property (nonatomic, assign) CGFloat Time;

@end
