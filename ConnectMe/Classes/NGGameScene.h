//
//  HelloWorldScene.h
//  ConnectMe
//
//  Created by Nitin Gupta on 23/04/14.
//  Copyright Shephertz 2014. All rights reserved.
// 

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "NGGameConstants.h"

/**
 *  The main scene
 */
@interface NGGameScene : CCScene {
    
    NSMutableArray * _aSpriteArray;
    
    CCColor *_currentDrawColor;
    
    NSMutableArray * _stackArray;
    
    BOOL _drawLine;
    
    BOOL _hasObject;
    
    BOOL _removeAllSameColor;
    
    BOOL _toolsDisappear;
    
    BOOL _toolsDisappearType;
        
    CGPoint _movePos;
        
    float _timeElapsed;
    
    int _totalTimeLeft;
}

+ (instancetype)scene;

-(void) startAnimtionDisplay;

-(void) startPlaying;

-(BOOL) touchBegine:(CGPoint) local;

-(void) touchMove:(CGPoint) local;

-(void) touchEnd;

-(void) disappearEnd;

-(BOOL) allDrawNodeBeSelected:(BOOL) disappearType;

@end