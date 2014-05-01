//
//  NGGooglePlusScene.h
//  ConnectMe
//
//  Created by Nitin Gupta on 30/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCScene.h"
#import <GooglePlus/GooglePlus.h>

@interface NGGooglePlusScene : CCScene <GPPSignInDelegate,UIAlertViewDelegate>

+ (instancetype)scene;

@end
