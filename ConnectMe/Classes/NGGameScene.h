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
    
    NSMutableArray * m_SpriteArray;
    
    CCColor *m_currentDrawColor;
    
    NSMutableArray * m_stackArray;
    
    BOOL m_drawLine;
    
    BOOL m_objectHasContina;
    
    BOOL m_removeAllSameColor;
    
    BOOL m_toolsDisappear;
    
    BOOL m_toolsDisappearType;
        
    CGPoint m_movePos;
    
    int m_score;
}

+ (instancetype)scene;

-(void) startAnimtionDisplay;

-(void) startPlaying;

-(BOOL) touchBegine:(CGPoint) local;

-(void) touchMove:(CGPoint) local;

-(void) touchEnd;

-(void) disappearEnd;

-(BOOL) allDrawNodeBeSelected:(BOOL) disappearType;

-(void) moveOut;

-(void) moveIn;

@end