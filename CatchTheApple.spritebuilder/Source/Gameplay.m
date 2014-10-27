//
//  Gameplay.m
//  1stShot
//
//  Created by Faisal on 4/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Apple.h"
#import "Spider.h"

static const CGFloat scrollSpeedRate = 250.f;
static const CGFloat yAccelSpeedRate = 5.f;
static const CGFloat firstApplePosition = 0.f;
static const CGFloat distanceBetweenApples = 50.f;

#define kRemoveAdsProductIdentifier @"com.bakwasgames.movethedot.removeads"
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


// fixing the drawing order. forcing the ground to be drawn above the pipes.
typedef NS_ENUM(NSInteger, DrawingOrder) {
   DrawingOrderGround,
   DrawingOrdeHero,
   DrawingOrderApple,
   DrawingOrderSpider
};

@implementation Gameplay
{
    CCPhysicsNode *_physicsNode;
    CCSprite *_hero;
    CCNode *_ground1;
    NSArray *_grounds;
    NSMutableArray *_apples;
    BOOL _gameOver;
    CGFloat _scrollSpeed;
   CGFloat  _yAccelSpeed;
    CGFloat _elapsedTime;
    NSInteger _points;
   NSInteger _localCounter;
    CCLabelTTF *_scoreLabel;
    CGFloat _swiped;
    CGFloat _newHeroPosition;
    CCNode *_gameOverBox;
   CCNode *_scoreLabelBox;
   CCNode *_banner;
    CCLabelTTF *_highScoreValue;
    CCLabelTTF *_scoreValue;
   AVAudioPlayer *clickSound, *gameOverSound;
   UIImage *_image;
   GADInterstitial *interstitial;
   CCButton *_removeAdsButton;
   UIActivityIndicatorView *spinner;
   NSString *osVersion;
   Apple *_apple1, *_apple2, *_apple3, *_apple4;
   Apple *_apple5, *_apple6, *_apple7, *_apple8;
   Spider *_spider1;
   UITapGestureRecognizer *tapped;
   UIPanGestureRecognizer  *panned;
   CCDrawNode *_drawNode;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
   
    _physicsNode.collisionDelegate = self;
   
    _grounds = @[_ground1];
   
    _apples = [NSMutableArray array];

   _apple1 = (Apple *)[CCBReader load:@"Apple"];
   _apple2 = (Apple *)[CCBReader load:@"Apple"];
   _apple3 = (Apple *)[CCBReader load:@"Apple"];
   _apple4 = (Apple *)[CCBReader load:@"Apple"];
   _apple5 = (Apple *)[CCBReader load:@"Apple"];
   _apple6 = (Apple *)[CCBReader load:@"Apple"];
   _apple7 = (Apple *)[CCBReader load:@"Apple"];
   _apple8 = (Apple *)[CCBReader load:@"Apple"];

   [_physicsNode addChild:_apple1];
   [_physicsNode addChild:_apple2];
   [_physicsNode addChild:_apple3];
   [_physicsNode addChild:_apple4];
   [_physicsNode addChild:_apple5];
   [_physicsNode addChild:_apple6];
   [_physicsNode addChild:_apple7];
   [_physicsNode addChild:_apple8];
   
   _spider1 = (Spider *)[CCBReader load:@"Spider"];
   [_physicsNode addChild:_spider1];

   _spider1.visible = FALSE;
//   [self spawnNewSpider:_spider1];
   
   int min = 0;
   int max = 7;
   int random = (arc4random()%(max-min))+min;
   
   switch (random) {
      case 0:
      {
         [self spawnNewApple:_apple1 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:8 appleColor:@"Red"];
         _apple1.Number = 1;
         _apple2.Number = 2;
         _apple3.Number = 3;
         _apple4.Number = 4;
         _apple5.Number = 5;
         _apple6.Number = 6;
         _apple7.Number = 7;
         _apple8.Number = 8;
         break;
      }
      case 1:
      {
         [self spawnNewApple:_apple1 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:1 appleColor:@"Red"];
         _apple1.Number = 2;
         _apple2.Number = 3;
         _apple3.Number = 4;
         _apple4.Number = 5;
         _apple5.Number = 6;
         _apple6.Number = 7;
         _apple7.Number = 8;
         _apple8.Number = 1;
         break;
      }
      case 2:
      {
         [self spawnNewApple:_apple1 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:2 appleColor:@"Red"];
         _apple1.Number = 3;
         _apple2.Number = 4;
         _apple3.Number = 5;
         _apple4.Number = 6;
         _apple5.Number = 7;
         _apple6.Number = 8;
         _apple7.Number = 1;
         _apple8.Number = 2;
         break;
      }
      case 3:
      {
         [self spawnNewApple:_apple1 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:3 appleColor:@"Red"];
         _apple1.Number = 4;
         _apple2.Number = 5;
         _apple3.Number = 6;
         _apple4.Number = 7;
         _apple5.Number = 8;
         _apple6.Number = 1;
         _apple7.Number = 2;
         _apple8.Number = 3;
         break;
      }
      case 4:
      {
         [self spawnNewApple:_apple1 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:4 appleColor:@"Red"];
         _apple1.Number = 5;
         _apple2.Number = 6;
         _apple3.Number = 7;
         _apple4.Number = 8;
         _apple5.Number = 1;
         _apple6.Number = 2;
         _apple7.Number = 3;
         _apple8.Number = 4;
         break;
      }
      case 5:
      {
         [self spawnNewApple:_apple1 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:5 appleColor:@"Red"];
         _apple1.Number = 6;
         _apple2.Number = 7;
         _apple3.Number = 8;
         _apple4.Number = 1;
         _apple5.Number = 2;
         _apple6.Number = 3;
         _apple7.Number = 4;
         _apple8.Number = 5;
         break;
      }
      case 6:
      {
         [self spawnNewApple:_apple1 appleNumber:7 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:6 appleColor:@"Red"];
         _apple1.Number = 7;
         _apple2.Number = 8;
         _apple3.Number = 1;
         _apple4.Number = 2;
         _apple5.Number = 3;
         _apple6.Number = 4;
         _apple7.Number = 5;
         _apple8.Number = 6;
         break;
      }
      case 7:
      {
         [self spawnNewApple:_apple1 appleNumber:8 appleColor:@"Red"];
         [self spawnNewApple:_apple2 appleNumber:1 appleColor:@"Red"];
         [self spawnNewApple:_apple3 appleNumber:2 appleColor:@"Red"];
         [self spawnNewApple:_apple4 appleNumber:3 appleColor:@"Red"];
         [self spawnNewApple:_apple5 appleNumber:4 appleColor:@"Red"];
         [self spawnNewApple:_apple6 appleNumber:5 appleColor:@"Red"];
         [self spawnNewApple:_apple7 appleNumber:6 appleColor:@"Red"];
         [self spawnNewApple:_apple8 appleNumber:7 appleColor:@"Red"];
         _apple1.Number = 8;
         _apple2.Number = 1;
         _apple3.Number = 2;
         _apple4.Number = 3;
         _apple5.Number = 4;
         _apple6.Number = 5;
         _apple7.Number = 6;
         _apple8.Number = 7;
         break;
      }
      default:
         break;
   }
//    [self spawnNewApple];
   _apple1.physicsBody.collisionType = @"apple1";
   _apple2.physicsBody.collisionType = @"apple2";
   _apple3.physicsBody.collisionType = @"apple3";
   _apple4.physicsBody.collisionType = @"apple4";
   _apple5.physicsBody.collisionType = @"apple5";
   _apple6.physicsBody.collisionType = @"apple6";
   _apple7.physicsBody.collisionType = @"apple7";
   _apple8.physicsBody.collisionType = @"apple8";
   
   _spider1.physicsBody.collisionType =@"spider1";

    for (CCNode *ground in _grounds) {
        // set collision txpe
        ground.physicsBody.collisionType = @"level";
       ground.zOrder = DrawingOrderGround;
    }
    // set collision type
    _hero.physicsBody.collisionType = @"hero";
   _hero.zOrder = DrawingOrdeHero;

//   _apple.physicsBody.collisionType = @"apple";
//   _apple.zOrder = DrawingOrderApple;
   
    _scrollSpeed = scrollSpeedRate;
   _yAccelSpeed = yAccelSpeedRate;
    
    // GestureRecognizer Code
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenWasSwipedUp)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenWasSwipedDown)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];

   UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenWasSwipedRight)];
   swipeRight.numberOfTouchesRequired = 1;
   swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
   
   [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];

   UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenWasSwipedLeft)];
   swipeLeft.numberOfTouchesRequired = 1;
   swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
   
   [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
   
   tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)];
    tapped.numberOfTapsRequired = 1;
    tapped.numberOfTouchesRequired = 1;
    tapped.cancelsTouchesInView = NO;
    
    [[[CCDirector sharedDirector] view] addGestureRecognizer:tapped];
    
   panned = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned)];
   [panned setMinimumNumberOfTouches:1];
   [panned setMaximumNumberOfTouches:1];
//   panned.cancelsTouchesInView = NO;
   
   [[[CCDirector sharedDirector] view] addGestureRecognizer:panned];
   
    _newHeroPosition = _hero.position.x;
    
    _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] ;

   // remove ads
   _areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
   
   if(!_areAdsRemoved)
   {
   [self cycleInterstitial]; // Prepare our interstitial for after the game so that we can be certain its ready to present
      
   }

   // The AV Audio Player needs a URL to the file that will be played to be specified.
   // So, we're going to set the audio file's path and then convert it to a URL.
   // game over sound
   NSString *audioFilePath1 = [[NSBundle mainBundle] pathForResource:@"game_over" ofType:@"wav"];
   NSURL *pathAsURL1 = [[NSURL alloc] initFileURLWithPath:audioFilePath1];
   NSError *error1;
   gameOverSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAsURL1 error:&error1];
   gameOverSound.volume = 0.5;

   // Check out what's wrong in case that the player doesn't init.
   if (error1) {
      NSLog(@"%@", [error1 localizedDescription]);
   }
   else{
      // In this example we'll pre-load the audio into the buffer. You may avoid it if you want
      // as it's not always possible to pre-load the audio.
      [gameOverSound prepareToPlay];
   }
   
   [gameOverSound setDelegate:self];
   
   // click sound
   NSString *audioFilePath2 = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
   NSURL *pathAsURL2 = [[NSURL alloc] initFileURLWithPath:audioFilePath2];
   NSError *error2;
   clickSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathAsURL2 error:&error2];
   clickSound.volume = 0.5;
   
   // Check out what's wrong in case that the player doesn't init.
   if (error2) {
      NSLog(@"%@", [error2 localizedDescription]);
   }
   else{
      // In this example we'll pre-load the audio into the buffer. You may avoid it if you want
      // as it's not always possible to pre-load the audio.
      [clickSound prepareToPlay];
   }
   
   [clickSound setDelegate:self];
//   [self authenticateLocalPlayer];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   [spinner setCenter:CGPointMake([CCDirector sharedDirector].view.frame.size.width/2.0, [CCDirector sharedDirector].view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
   [[[CCDirector sharedDirector]view]addSubview:spinner];
   
   _gameOver = TRUE;
   _banner.visible = TRUE;

   if(!_areAdsRemoved){
      _removeAdsButton.visible = TRUE;
      _removeAdsButton.enabled = TRUE;
   }
   else{
      _removeAdsButton.visible = FALSE;
      _removeAdsButton.enabled = FALSE;
   }
   
   _drawNode = [[CCDrawNode alloc] init];
   _drawNode.contentSize = CGSizeMake(40.0f, 4.0f);
   [self addChild:_drawNode];
   _drawNode.position = ccp(0.5,0.5);

}

-(void)screenWasSwipedUp
{
}

-(void)screenWasSwipedDown
{
}

-(void)panned
{
   
}

-(void)screenTapped
{
//   [self spawnNewApple:_apple1];
    if (_gameOver && _scrollSpeed != 0) {
          _gameOver = FALSE;
      [_banner runAction:[CCActionFadeOut actionWithDuration:1.0]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   UITouch *touch = [touches anyObject];
   
   // Get the specific point that was touched
   CGPoint point = [touch locationInView:[CCDirector sharedDirector].view];
   NSLog(@"X location: %f", point.x);
   NSLog(@"Y Location: %f",point.y);
   
}


-(void)screenWasSwipedRight
{
   if (_gameOver && _scrollSpeed != 0) {
      _gameOver = FALSE;
      [_banner runAction:[CCActionFadeOut actionWithDuration:1.0]];
   }
   else {
      if(_hero.position.x < 430)
      {
         if(_hero.position.x == 30 ||
            _hero.position.x == 110 ||
            _hero.position.x == 190 ||
            _hero.position.x == 270 ||
            _hero.position.x == 350)
            //       _hero.position.y == 410)
         {
            _swiped = 1.0f;
            _newHeroPosition = _hero.position.x;
         }
      }
   }
}

-(void)screenWasSwipedLeft
{
   if (_gameOver && _scrollSpeed != 0) {
      _gameOver = FALSE;
      [_banner runAction:[CCActionFadeOut actionWithDuration:1.0]];
   }
   else {
      if(_hero.position.x == 30 ||
         _hero.position.x == 110 ||
         _hero.position.x == 190 ||
         _hero.position.x == 270 ||
         _hero.position.x == 350)
         //       _hero.position.y == 410)
      {
         _swiped = -1.0f;
         _newHeroPosition = _hero.position.x;
      }
   }
}


- (void)update:(CCTime)delta
{
   if(!_gameOver){
      _apple1.Time += delta;
      _apple2.Time += delta;
      _apple3.Time += delta;
      _apple4.Time += delta;
      _apple5.Time += delta;
      _apple6.Time += delta;
      _apple7.Time += delta;
      _apple8.Time += delta;
      _spider1.Time += delta;
      
      CGPoint point = [panned locationInView:[CCDirector sharedDirector].view];
//      NSLog(@"%f %f",point.x, point.y);
//      if (_hero.position.x - _newHeroPosition >= 80.0)
//      {
//         _hero.position = ccp(_hero.position.x, _hero.position.y);
//      }
//      else if(_hero.position.x - _newHeroPosition <= -80.0)
//      {
//         _hero.position = ccp(_hero.position.x, _hero.position.y);
//      }
//      else
//      {
//         _hero.position = ccp(_hero.position.x + _swiped * yAccelSpeed, _hero.position.y);
//      }
      if(point.x != 0)
      {
      _hero.position = ccp(point.x, 0.12);
      }
      else
      {
      _hero.position = ccp(_hero.position.x, 0.12);
      }
      if(_apple1.Time > 1 && !_apple1.Dropped)
      {
         [self positionApple:_apple1];
      }
      if(_apple2.Time > 2 && !_apple2.Dropped)
      {
         [self positionApple:_apple2];
      }
      if(_apple3.Time > 3 && !_apple3.Dropped)
      {
         [self positionApple:_apple3];
      }
      if(_apple4.Time > 4 && !_apple4.Dropped)
      {
         [self positionApple:_apple4];
      }
      if(_apple5.Time > 5 && !_apple5.Dropped)
      {
         [self positionApple:_apple5];
      }
      if(_apple6.Time > 6 && !_apple6.Dropped)
      {
         [self positionApple:_apple6];
      }
      if(_apple7.Time > 7 && !_apple7.Dropped)
      {
         [self positionApple:_apple7];
      }
      if(_apple8.Time > 8 && !_apple8.Dropped)
      {
         [self positionApple:_apple8];
      }
      
      if(_points > 0 && _points % 8 == 0)
      {
         _spider1.Dropped = FALSE;
         [self spawnNewSpider:_spider1];
      }

      if(_spider1.Time > 1 && !_spider1.Dropped)
      {
         _spider1.position = ccp(_spider1.position.x, _spider1.position.y - _yAccelSpeed);
      }

      //        CCLOG(@"%f",_hero.position.y);
//      _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
      // loop the ground
//      for (CCNode *ground in _grounds) {
//         // get the world position of the ground
//         CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
//         // get the screen position of the ground
//         CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
//         // if the left corner is one complete width off the screen, move it to the right
//         if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
//            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
//         }
//         
//      }

      // Spawning new apples when old ones leave the screen
//      NSMutableArray *offScreenApples = nil;
//      for (CCSprite *apple in _apples) {
//         CGPoint appleWorldPosition = [_physicsNode convertToWorldSpace:apple.position];
//         CGPoint appleScreenPosition = [self convertToNodeSpace:appleWorldPosition];
//         NSLog(@"%s,%f","apple screen position y", appleScreenPosition.y);
//         NSLog(@"%s,%f","apple height", apple.contentSize.height);
//         appleScreenPosition.y = appleScreenPosition.y + delta/4;
//         apple.position = ccp(apple.position.x, appleScreenPosition.y);
//         apple.position = ccp(apple.position.x, apple.position.y + delta/4);
//         [apple setPosition:ccp(apple.position.x, apple.position.y + delta/4)];
         
//         if (appleScreenPosition.y > apple.contentSize.height) {
//            if (!offScreenApples) {
//               offScreenApples = [NSMutableArray array];
//            }
//            [offScreenApples addObject:apple];
//         }
//      }
//      for (CCNode *appleToRemove in offScreenApples) {
//         [appleToRemove removeFromParent];
//         [_apples removeObject:appleToRemove];
//         // for each removed apple, add a new one
//         [self spawnNewApple];
//      }
   }
   else if (_gameOver && _scrollSpeed == 0)
   {
         _elapsedTime += delta;
         if(_localCounter <= _points && _elapsedTime > 2)
         {
            _physicsNode.visible = FALSE;
            _scoreLabel.visible = FALSE;
            _scoreLabelBox.visible = FALSE;
            _gameOverBox.visible = TRUE;
            [_gameOverBox runAction:[CCActionFadeIn  actionWithDuration:0.5]];

            _localCounter++;
            _scoreValue.string = [NSString stringWithFormat:@"%ld", (long)_localCounter-1];
            
         }
   }
}

- (void)heroRemoved:(CCNode *)hero {
    // remove the hero
    [hero removeFromParent];
}
- (void)positionApple:(Apple *)_apple
{
   if([_apple.Color  isEqual: @"Red"])
   {
      _apple.position = ccp(_apple.position.x, _apple.position.y - _yAccelSpeed);
   }
   else if([_apple.Color  isEqual: @"Yellow"])
   {
      _apple.position = ccp(_apple.position.x, _apple.position.y - (_yAccelSpeed+2));
   }
   else if([_apple.Color  isEqual: @"Green"])
   {
      _apple.position = ccp(_apple.position.x, _apple.position.y - (_yAccelSpeed+4));
   }
}

- (void)spawnNewApple:(Apple *)_apple appleNumber:(NSInteger)_counter appleColor:(NSString*)_color{
//    CCNode *previousApple = [_apples lastObject];
//    CGFloat previousAppleXPosition = previousApple.position.x;
//    if (!previousApple) {
//        // this is the first apple
//        previousAppleXPosition = firstApplePosition;
//    }
//    _apple = (Apple *)[CCBReader load:@"Apple"];
//    apple.position = ccp(previousAppleXPosition + distanceBetweenApples,0);
//   CCSprite *apple = [CCSprite spriteWithImageNamed:@"dot.png"];
   // iphone width 320, ipad 384
   // iphone 4S height 480, iphone 5s height 568, ipad height 512
   // x range 20 - 300
   // y range 200 - 350
   int min = -45;
   int max = 45;
   int random = (arc4random()%(max-min))+min;
   [_apple runAction:[CCActionRotateTo actionWithDuration:0 angle:random]];

   float width = [CCDirector sharedDirector].view.frame.size.width;
   float height = [CCDirector sharedDirector].view.frame.size.height;
   switch (_counter-1) {
      case 0:
         _apple.position = ccp(width/5.0,height/1.17);
         break;
      case 1:
         _apple.position = ccp(width/1.75,height/1.37);
          // 1 goes to 4
         break;
      case 2:
         _apple.position = ccp(width/20.0,height/1.56);
         break;
      case 3:
         _apple.position = ccp(width/1.45,height/1.75);
         break;
      case 4:
          _apple.position = ccp(width/3.125,height/1.43);
         break;
      case 5:
         _apple.position = ccp(width/1.23,height/1.23);
         break;
      case 6:
          _apple.position = ccp(width/2.22,height/1.17);
         break;
      case 7:
         _apple.position = ccp(width/1.05,height/1.52);
         break;
      default:
         break;
   }
   // set color
   _apple.Color = _color;

   if([_apple.Color isEqual:@"Green"])
   {
      _apple.effect = [CCEffectHue effectWithHue: 120.0];
   }
   else if([_apple.Color isEqual:@"Yellow"])
   {
      _apple.effect = [CCEffectHue effectWithHue: 55.0];
//      _apple.effect = [CCEffectStack effects: [CCEffectHue effectWithHue: 55.0],[CCEffectSaturation effectWithSaturation:1], NULL];

   }
   else if([_apple.Color isEqual:@"Red"])
   {
      _apple.effect = [CCEffectHue effectWithHue: 0.0];
   }

   _apple.visible = YES;
//    [apple setupRandomPosition];
//    [_physicsNode addChild:_apple];
    [_apples addObject:_apple];
//   _apple.physicsBody.collisionType = @"apple";

   // fixing drawing order. drawing grounds in front of pipes.
   _apple.zOrder = DrawingOrderApple;
}

- (void)spawnNewSpider:(Spider *)_spider{
   float width = [CCDirector sharedDirector].view.frame.size.width;
   float height = [CCDirector sharedDirector].view.frame.size.height;
   _spider.position = ccp(width/2.0,height/2.0);
   _spider.visible = YES;
   // fixing drawing order. drawing grounds in front of pipes.
   _spider.zOrder = DrawingOrderSpider;
}

- (void)selectApple:(Apple *)_apple
{
   if(_points % 3 == 0)
   {
      [self spawnNewApple:_apple appleNumber:_apple.Number appleColor:@"Yellow"];
   }
   else if (_points % 4 == 0)
   {
      [self spawnNewApple:_apple appleNumber:_apple.Number appleColor:@"Green"];
   }
   else
   {
      [self spawnNewApple:_apple appleNumber:_apple.Number appleColor:@"Red"];
   }

}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple1:(Apple *)apple1 {
//   [gameOverSound play];
//   _hero.effect = [CCEffectPixellate effectWithBlockSize: 4];
//    [self gameOver];
//   [apple removeFromParent];
   _apple1.Time = 0;
   _apple1.Dropped = TRUE;
   _apple2.Dropped = FALSE;
   apple1.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple1];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple2:(Apple *)apple2 {
   _apple2.Time = 0;
   _apple2.Dropped = TRUE;
   _apple3.Dropped = FALSE;
   apple2.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple2];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple3:(Apple *)apple3 {
   _apple3.Time = 0;
   _apple3.Dropped = TRUE;
   _apple4.Dropped = FALSE;
   apple3.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple3];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple4:(Apple *)apple4 {
   _apple4.Time = 0;
   _apple4.Dropped = TRUE;
   _apple5.Dropped = FALSE;
   apple4.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple4];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple5:(Apple *)apple5 {
   _apple5.Time = 0;
   _apple5.Dropped = TRUE;
   _apple6.Dropped = FALSE;
   apple5.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple5];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple6:(Apple *)apple6 {
   _apple6.Time = 0;
   _apple6.Dropped = TRUE;
   _apple7.Dropped = FALSE;
   apple6.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple6];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple7:(Apple *)apple7 {
   _apple7.Time = 0;
   _apple7.Dropped = TRUE;
   _apple8.Dropped = FALSE;
   apple7.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple7];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple8:(Apple *)apple8 {
   _apple8.Time = 0;
   _apple8.Dropped = TRUE;
   _apple1.Dropped = FALSE;
   apple8.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self selectApple:_apple8];
   return TRUE;
}

- (void)appleCollisionEffect:(Apple *)_apple
{
   if([_apple.Color  isEqual: @"Red"])
   {
      _apple.effect = [CCEffectStack effects: [CCEffectPixellate effectWithBlockSize: 4],[CCEffectHue effectWithHue: 0.0], NULL];
   }
   else if([_apple.Color  isEqual: @"Yellow"])
   {
      _apple.effect = [CCEffectStack effects: [CCEffectPixellate effectWithBlockSize: 4],[CCEffectHue effectWithHue: 55.0], NULL];
   }
   else if([_apple.Color  isEqual: @"Green"])
   {
      _apple.effect = [CCEffectStack effects: [CCEffectPixellate effectWithBlockSize: 4],[CCEffectHue effectWithHue: 120.0], NULL];
   }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero spider1:(Apple *)spider1 {
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair spider1:(Spider *)spider1 level:(CCNode *)level {
   _spider1.Time = 0;
   _spider1.Dropped = TRUE;
   _spider1.visible = NO;
   _spider1.position = ccp(0.0,0.0);
//   [self selectApple:_apple1];
   return TRUE;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple1:(Apple *)apple1 level:(CCNode *)level {
      [gameOverSound play];
//      _apple1.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self appleCollisionEffect:_apple1];
//   _apple1.effect = [CCEffectStack effects: [CCEffectPixellate effectWithBlockSize: 4],[CCEffectHue effectWithHue: 120.0], NULL];

       [self gameOver];
//      _apple1Time = 0;
//   _apple1Dropped = TRUE;
//   _apple4Dropped = FALSE;
//   apple1.visible = NO;
//   [self spawnNewApple:apple1 appleNumber:1];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple2:(Apple *)apple2 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple2];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple3:(Apple *)apple3 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple3];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple4:(Apple *)apple4 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple5:(Apple *)apple5 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple5];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple6:(Apple *)apple6 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple6];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple7:(Apple *)apple7 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple7];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple8:(Apple *)apple8 level:(CCNode *)level {
   [gameOverSound play];
   [self appleCollisionEffect:_apple8];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    _points++;
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
    return TRUE;
}

- (void)restart
{
   [clickSound play];
   [spinner  stopAnimating];
   if(!_areAdsRemoved)
   {
      [self presentInterlude];
   }
   else
   {
      [self replaceSceneWithTransition];
   }
}

-(void)pause
{
   if([CCDirector sharedDirector].isPaused)
   {
      [[CCDirector sharedDirector] resume];
   }
   else{
   [[CCDirector sharedDirector] pause];
   }
}

-(void)onExit
{
    [self stopAllActions];
    [self unscheduleAllSelectors];
    [self removeAllChildrenWithCleanup:YES];
   interstitial.delegate = nil;
   interstitial = nil;
   clickSound.delegate = nil;
   clickSound = nil;
   gameOverSound.delegate = nil;
   gameOverSound = nil;
    [super onExit];
}



- (void)gameOver {
    if (!_gameOver) {
        _scrollSpeed = 0.f;
        _gameOver = TRUE;
        [_hero stopAllActions];
       
//        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.5f position:ccp(0, 163)];
//        CCActionInterval *reverseMovement = [moveBy reverse];
//        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
//        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
//       [_gameOverBox runAction:bounce];
       
        // save high score
        //To save the score (in this case, 10000 ) to standard defaults:
        
        if(_points > _highScore)
        {
        
            [[NSUserDefaults standardUserDefaults] setInteger: _points forKey: @"highScore"];
           if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
           {
           [self reportScore];
           }
        
        }
        _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] ;
        _highScoreValue.string = [NSString stringWithFormat:@"%ld", (long)_highScore];
       
       // Take Screen Shot
       UIGraphicsBeginImageContextWithOptions([CCDirector sharedDirector].view.bounds.size, NO, [UIScreen mainScreen].scale);
       
//       [[CCDirector sharedDirector].view drawViewHierarchyInRect:[CCDirector sharedDirector].view.bounds afterScreenUpdates:NO];
       /* iOS 7 */
       if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
          [[CCDirector sharedDirector].view drawViewHierarchyInRect:[CCDirector sharedDirector].view.bounds afterScreenUpdates:NO];
       else /* iOS 6 */
          [[CCDirector sharedDirector].view.layer renderInContext:UIGraphicsGetCurrentContext()];

       _image = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       
//        [self runAction:bounce];
    }
}

-(void)resetHighScore{
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: @"highScore"];
    _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"] ;
    _highScoreValue.string = [NSString stringWithFormat:@"%ld", (long)_highScore];
}

-(void)shareImage{
   [clickSound play];
   [spinner  stopAnimating];
   NSString *message = [NSString stringWithFormat:@"Hey!!! I scored %ld", (long)_points];
   message = [message stringByAppendingString:@" points in Catch The Apple."];
   message = [message stringByAppendingString:@" Check it out https://itunes.apple.com/app/id914300555"];
   
   UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:message,_image, nil] applicationActivities:nil];
   activityVC.excludedActivityTypes = @[ UIActivityTypeAssignToContact];
   [[CCDirector sharedDirector] presentViewController:activityVC animated:YES completion:nil];

}

-(void)replaceSceneWithTransition
{
   CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
   [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionFadeWithDuration:1.0]];
}

-(void)replaceScene
{
   CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
   [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark GameCenter
-(void)reportScore{
   if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
   {
   GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"2"];
   score.value = _points;
   
   [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
      if (error != nil) {
         NSLog(@"%@", [error localizedDescription]);
      }
   }];
   }
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
   GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
   
   gcViewController.gameCenterDelegate = self;
   
   if (shouldShowLeaderboard) {
      gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
      gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
   }
   else{
      gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
   }
   
   [[CCDirector sharedDirector] presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
   [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)showLeaderboard{
   if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
   {
   [clickSound play];
   [spinner  stopAnimating];
   [self showLeaderboardAndAchievements:YES];
   }
}

#pragma mark -
#pragma mark Interstitial Management

- (void)cycleInterstitial
{
   if(!_areAdsRemoved)
   {
   // Clean up the old interstitial...
   interstitial.delegate = nil;
   interstitial = nil;
   // GAD
   interstitial = [[GADInterstitial alloc] init];
   interstitial.adUnitID = @"ca-app-pub-3129568560891761/4333608339";
   [interstitial loadRequest:[GADRequest request]];
   interstitial.delegate = self;
   }
}

- (void)presentInterlude
{
   // If the interstitial managed to load, then we'll present it now.
   if (interstitial.isReady) {
//      [interstitial presentFromRootViewController:[CCDirector sharedDirector]];
   }
   [self replaceSceneWithTransition];
}

#pragma mark ADInterstitialViewDelegate methods

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
   [self cycleInterstitial];
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
   [self cycleInterstitial];
}

#pragma mark remove ads

- (void)tapsRemoveAds{
   NSLog(@"User requests to remove ads");
   [spinner startAnimating];
   _scrollSpeed = 0.f;
   if([SKPaymentQueue canMakePayments]){
      NSLog(@"User can make payments");
      
      SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
      productsRequest.delegate = self;
      [productsRequest start];
      
   }
   else{
      NSLog(@"User cannot make payments due to parental controls");
      //this is called the user cannot make payments, most likely due to parental controls
   }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
   SKProduct *validProduct = nil;
   int count = [response.products count];
   if(count > 0){
      validProduct = [response.products objectAtIndex:0];
      NSLog(@"Products Available!");
      [self purchase:validProduct];
   }
   else if(!validProduct){
      NSLog(@"No products available");
      //this is called if your product id is not valid, this shouldn't be called unless that happens.
   }
}

- (void)purchase:(SKProduct *)product{
   SKPayment *payment = [SKPayment paymentWithProduct:product];
   [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
   [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) restore{
   //this is called when the user restores purchases, you should hook this up to a button
   [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
   NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
   for (SKPaymentTransaction *transaction in queue.transactions)
   {
      if(SKPaymentTransactionStateRestored){
         NSLog(@"Transaction state -> Restored");
         //called when the user successfully restores a purchase
         [self doRemoveAds];
         [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
         break;
      }
      
   }
   
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
   for(SKPaymentTransaction *transaction in transactions){
      switch (transaction.transactionState){
         case SKPaymentTransactionStatePurchasing:
         {
            NSLog(@"Transaction state -> Purchasing");
            //called when the user is in the process of purchasing, do not add any of your own code here.
            break;
         }
         case SKPaymentTransactionStatePurchased:
         {
            //this is called when the user has successfully purchased the package (Cha-Ching!)
            [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSLog(@"Transaction state -> Purchased");
            [spinner stopAnimating];
            break;
         }
         case SKPaymentTransactionStateRestored:
         {
            NSLog(@"Transaction state -> Restored");
            //add the same code as you did from SKPaymentTransactionStatePurchased here
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [spinner stopAnimating];
            break;
         }
         case SKPaymentTransactionStateFailed:
         {
            NSLog(@"Transaction state -> Failed");
            //called when the transaction does not finnish
            if(transaction.error.code != SKErrorPaymentCancelled){
               NSLog(@"Transaction state -> Cancelled");
               //the user cancelled the payment ;(
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [spinner stopAnimating];
            break;
         }
      }
   }
}

- (void)doRemoveAds{
   _areAdsRemoved = YES;
   _removeAdsButton.visible = FALSE;
   [[NSUserDefaults standardUserDefaults] setBool:_areAdsRemoved forKey:@"areAdsRemoved"];
}

@end
