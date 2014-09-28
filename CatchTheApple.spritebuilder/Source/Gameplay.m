//
//  Gameplay.m
//  1stShot
//
//  Created by Faisal on 4/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

static const CGFloat scrollSpeedRate = 250.f;
static const CGFloat yAccelSpeed = 10.f;
static const CGFloat firstApplePosition = 0.f;
static const CGFloat distanceBetweenApples = 50.f;

#define kRemoveAdsProductIdentifier @"com.bakwasgames.movethedot.removeads"
#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


// fixing the drawing order. forcing the ground to be drawn above the pipes.
typedef NS_ENUM(NSInteger, DrawingOrder) {
   DrawingOrderApple,
   DrawingOrderGround,
   DrawingOrdeHero
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
    CGFloat _elapsedTime;
   CGFloat _apple1Time,_apple2Time,_apple3Time,_apple4Time;
   CGFloat _apple5Time,_apple6Time,_apple7Time,_apple8Time;
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
   GADBannerView *_bannerView;
   GADInterstitial *interstitial;
   CCButton *_removeAdsButton;
   UIActivityIndicatorView *spinner;
   NSString *osVersion;
   CCSprite *_apple1, *_apple2, *_apple3, *_apple4;
   CCSprite *_apple5, *_apple6, *_apple7, *_apple8;
   BOOL _apple1Dropped, _apple2Dropped, _apple3Dropped, _apple4Dropped;
   BOOL _apple5Dropped, _apple6Dropped, _apple7Dropped, _apple8Dropped;
   UITapGestureRecognizer *tapped;
   UIPanGestureRecognizer  *panned;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
    _grounds = @[_ground1];
   
    _apples = [NSMutableArray array];
   int min = 0;
   int max = 7;
   int random = (arc4random()%(max-min))+min;
   
   [self spawnNewApple:_apple1 appleNumber:random + 1];
   if(random + 2 > 8)
   {
      
   }
   [self spawnNewApple:_apple2 appleNumber:random + 2];
   [self spawnNewApple:_apple3 appleNumber:random + 3];
   [self spawnNewApple:_apple4 appleNumber:random + 4];
   [self spawnNewApple:_apple5 appleNumber:random + 5];
   [self spawnNewApple:_apple6 appleNumber:random + 6];
   [self spawnNewApple:_apple7 appleNumber:random + 7];
   [self spawnNewApple:_apple8 appleNumber:random + 8];
//    [self spawnNewApple];
   _apple1.physicsBody.collisionType = @"apple1";
   _apple2.physicsBody.collisionType = @"apple2";
   _apple3.physicsBody.collisionType = @"apple3";
   _apple4.physicsBody.collisionType = @"apple4";
   _apple5.physicsBody.collisionType = @"apple5";
   _apple6.physicsBody.collisionType = @"apple6";
   _apple7.physicsBody.collisionType = @"apple7";
   _apple8.physicsBody.collisionType = @"apple8";

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
      
   // Initialize the banner at the bottom of the screen.
   CGPoint origin = CGPointMake(0.0,
                                [CCDirector sharedDirector].view.frame.size.height -
                                CGSizeFromGADAdSize(kGADAdSizeBanner).height);
   _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
   
   // Specify the ad unit ID.
   _bannerView.adUnitID = @"ca-app-pub-3129568560891761/2856875137";
   
   // Let the runtime know which UIViewController to restore after taking
   // the user wherever the ad goes and add it to the view hierarchy.
   _bannerView.rootViewController = [CCDirector sharedDirector];
   [[[CCDirector sharedDirector]view]addSubview:_bannerView];
   // Initiate a generic request to load it with an ad.
   [_bannerView loadRequest:[GADRequest request]];
   _bannerView.delegate = self;
   _bannerView.hidden = NO;
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
      _bannerView.hidden = TRUE;
   }
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
      _apple1Time += delta;
      _apple2Time += delta;
      _apple3Time += delta;
      _apple4Time += delta;
      _apple5Time += delta;
      _apple6Time += delta;
      _apple7Time += delta;
      _apple8Time += delta;
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
      _hero.position = ccp(point.x, 0.25);
      }
      else
      {
      _hero.position = ccp(_hero.position.x, 0.25);
      }
      if(_apple1Time > 1 && !_apple1Dropped)
      {
         _apple1.position = ccp(_apple1.position.x, _apple1.position.y - 0.01f);
      }
      if(_apple2Time > 2 && !_apple2Dropped)
      {
      _apple2.position = ccp(_apple2.position.x, _apple2.position.y - 0.01f);
      }
      if(_apple3Time > 3 && !_apple3Dropped)
      {
         _apple3.position = ccp(_apple3.position.x, _apple3.position.y - 0.01f);
      }
      if(_apple4Time > 4 && !_apple4Dropped)
      {
         _apple4.position = ccp(_apple4.position.x, _apple4.position.y - 0.01f);
      }
      if(_apple5Time > 5 && !_apple5Dropped)
      {
         _apple5.position = ccp(_apple5.position.x, _apple5.position.y - 0.01f);
      }
      if(_apple6Time > 6 && !_apple6Dropped)
      {
         _apple6.position = ccp(_apple6.position.x, _apple6.position.y - 0.01f);
      }
      if(_apple7Time > 7 && !_apple7Dropped)
      {
         _apple7.position = ccp(_apple7.position.x, _apple7.position.y - 0.01f);
      }
      if(_apple8Time > 8 && !_apple8Dropped)
      {
         _apple8.position = ccp(_apple8.position.x, _apple8.position.y - 0.01f);
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

- (void)spawnNewApple:(CCNode *)_apple appleNumber:(NSInteger)_counter{
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

   switch (_counter-1) {
      case 0:
         _apple.position = ccp(0.20,0.85);
         break;
      case 1:
         _apple.position = ccp(0.32,0.70);
         break;
      case 2:
         _apple.position = ccp(0.05,0.64);
         break;
      case 3:
         _apple.position = ccp(0.45,0.85);
         break;
      case 4:
         _apple.position = ccp(0.57,0.73);
         break;
      case 5:
         _apple.position = ccp(0.69,0.57);
         break;
      case 6:
         _apple.position = ccp(0.81,0.81);
         break;
      case 7:
         _apple.position = ccp(0.95,0.66);
         break;
      default:
         break;
   }
   _apple.visible = YES;
//    [apple setupRandomPosition];
//    [_physicsNode addChild:_apple];
    [_apples addObject:_apple];
//   _apple.physicsBody.collisionType = @"apple";

   // fixing drawing order. drawing grounds in front of pipes.
   _apple.zOrder = DrawingOrderApple;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple1:(CCNode *)apple1 {
//   [gameOverSound play];
//   _hero.effect = [CCEffectPixellate effectWithBlockSize: 4];
//    [self gameOver];
//   [apple removeFromParent];
   _apple1Time = 0;
   _apple1Dropped = TRUE;
   _apple4Dropped = FALSE;
   apple1.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple1 appleNumber:1];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple2:(CCNode *)apple2 {
   _apple2Time = 0;
   _apple2Dropped = TRUE;
   _apple5Dropped = FALSE;
   apple2.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple2 appleNumber:2];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple3:(CCNode *)apple3 {
   _apple3Time = 0;
   _apple3Dropped = TRUE;
   _apple6Dropped = FALSE;
   apple3.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple3 appleNumber:3];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple4:(CCNode *)apple4 {
   _apple4Time = 0;
   _apple4Dropped = TRUE;
   _apple7Dropped = FALSE;
   apple4.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple4 appleNumber:4];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple5:(CCNode *)apple5 {
   _apple5Time = 0;
   _apple5Dropped = TRUE;
   _apple8Dropped = FALSE;
   apple5.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple5 appleNumber:5];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple6:(CCNode *)apple6 {
   _apple6Time = 0;
   _apple6Dropped = TRUE;
   _apple1Dropped = FALSE;
   apple6.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple6 appleNumber:6];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple7:(CCNode *)apple7 {
   _apple7Time = 0;
   _apple7Dropped = TRUE;
   _apple2Dropped = FALSE;
   apple7.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple7 appleNumber:7];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero apple8:(CCNode *)apple8 {
   _apple8Time = 0;
   _apple8Dropped = TRUE;
   _apple3Dropped = FALSE;
   apple8.visible = NO;
   _points++;
   _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_points];
   [self spawnNewApple:apple8 appleNumber:8];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple1:(CCNode *)apple1 level:(CCNode *)level {
      [gameOverSound play];
      _apple1.effect = [CCEffectPixellate effectWithBlockSize: 4];
       [self gameOver];
//      _apple1Time = 0;
//   _apple1Dropped = TRUE;
//   _apple4Dropped = FALSE;
//   apple1.visible = NO;
//   [self spawnNewApple:apple1 appleNumber:1];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple2:(CCNode *)apple2 level:(CCNode *)level {
   [gameOverSound play];
   _apple2.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple3:(CCNode *)apple3 level:(CCNode *)level {
   [gameOverSound play];
   _apple3.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple4:(CCNode *)apple4 level:(CCNode *)level {
   [gameOverSound play];
   _apple4.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple5:(CCNode *)apple5 level:(CCNode *)level {
   [gameOverSound play];
   _apple5.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple6:(CCNode *)apple6 level:(CCNode *)level {
   [gameOverSound play];
   _apple6.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple7:(CCNode *)apple7 level:(CCNode *)level {
   [gameOverSound play];
   _apple7.effect = [CCEffectPixellate effectWithBlockSize: 4];
   [self gameOver];
   return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair apple8:(CCNode *)apple8 level:(CCNode *)level {
   [gameOverSound play];
   _apple8.effect = [CCEffectPixellate effectWithBlockSize: 4];
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
   [_bannerView removeFromSuperview];
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

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
   NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
   NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
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
      [interstitial presentFromRootViewController:[CCDirector sharedDirector]];
   }
   _bannerView.hidden = YES;
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
   _bannerView.hidden = YES;
   _removeAdsButton.visible = FALSE;
   [[NSUserDefaults standardUserDefaults] setBool:_areAdsRemoved forKey:@"areAdsRemoved"];
}

@end
