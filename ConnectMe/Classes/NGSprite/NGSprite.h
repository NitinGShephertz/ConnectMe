//
//  NGSprite.h
//  ConnectMe
//
//  Created by Nitin Gupta on 24/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#include "NGGameConstants.h"

@interface NGSprite : CCNode {
    
    int m_w;
    int m_h;
    
    BOOL m_hasSelected;
    
    CCDrawNode * m_drawNode;
    
    CCDrawNode * m_selectNode;
    
    int m_dropCount;
}
@property(nonatomic,readonly) NSInteger m_x;
@property(nonatomic,readonly) NSInteger m_y;
@property(nonatomic,readonly) CCColor *m_color;
@property(nonatomic,readonly) BOOL m_disappear;


-(void) spawnAtX:(NSInteger)x Y:(NSInteger)y Width:(CGFloat)w Height:(CGFloat) h;

-(void) respawn;

-(void) spawnDropdown;

-(void) resetPropertyA:(NSInteger)x Y:(NSInteger)y;

-(void) resetDropdown;

-(BOOL) positionInContent:(CGPoint) pos;

-(BOOL) selectedType;

-(void) disappear:(bool) callf;

-(void) unselected;

-(CGPoint) getDrawNodePosition;

-(void) KeepSelected;

-(void) unKeepSelected;

@end
