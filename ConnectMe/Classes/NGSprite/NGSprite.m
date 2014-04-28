//
//  NGSprite.m
//  ConnectMe
//
//  Created by Nitin Gupta on 24/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "NGSprite.h"
#import "NGGameScene.h"


@implementation NGSprite
@synthesize m_x = _m_x;
@synthesize m_y = _m_y;
@synthesize m_color = _m_color;
@synthesize m_disappear = _m_disappear;

-(CGPoint) calcPos:(NSInteger)x y:(NSInteger) y{
    
    CGFloat width = [self anchorPoint].x * m_w + x * m_w +OFFSET_W;
    CGFloat height = [self anchorPoint].y * m_h + y * m_h +OFFSET_H;
    return ccp(width, height);
}

-(void) calcColor{
    ColorType type = arc4random()%kColorTypeLenght;
    switch (type) {
        case kRed:
            _m_color = [CCColor redColor];
            break;
        case kGreen:
            _m_color = [CCColor greenColor];
            break;
        case KBlue:
            _m_color = [CCColor blueColor];
            break;
        case kPurple:
            _m_color = [CCColor purpleColor];
            break;
        case kOrange:
            _m_color = [CCColor orangeColor];
            break;
            
        default:
            _m_color = [CCColor purpleColor];
            break;
    }
}

-(void)spawnAtX:(NSInteger)x Y:(NSInteger)y Width:(CGFloat)w Height:(CGFloat)h{
    
    m_hasSelected = YES;
    _m_disappear = NO;
    _m_x = x;
    _m_y = y;
    
    m_w = w*2;
    m_h = h*2;
    
    [self calcColor];
    
    CGSize size = [CCDirector sharedDirector].viewSize;
    CGFloat wd = [self anchorPoint].x * m_w + x * m_w+OFFSET_W;
    
    m_drawNode = [CCDrawNode node];
    
    [m_drawNode setPosition:ccp(wd, size.height)];
    
    [m_drawNode setContentSize:CGSizeMake(DOT_RADIUES, DOT_RADIUES)];
    
    [self addChild:m_drawNode];
    
    [m_drawNode drawDot:ccp(0, 0) radius:DOT_RADIUES color:_m_color];
    
    m_selectNode = [CCDrawNode node];
    [m_drawNode addChild:m_selectNode];
    
    ccColor4F col = ccc4f(_m_color.ccColor4f.r, _m_color.ccColor4f.g, _m_color.ccColor4f.b, 255*0.75);
    CCColor *_aColor2 = [CCColor colorWithCcColor4f:col];
    [m_selectNode drawDot:ccp(0, 0) radius:DOT_RADIUES color:_aColor2];
    m_selectNode.visible = false;
}

-(void)respawn{
    
    _m_disappear = NO;
    [m_drawNode stopAllActions];
    [m_drawNode clear];
    [m_drawNode setScale:1.0];
    
    [m_selectNode clear];
    [m_selectNode setScale:1.0];
    
    [self calcColor];
    
    CGSize size = [CCDirector sharedDirector].viewSize;
    CGFloat wd = [self anchorPoint].x * m_w + _m_x * m_w +OFFSET_W;
    
    [m_drawNode setPosition:ccp(wd, size.height)];
    
    [m_drawNode drawDot:self.position radius:DOT_RADIUES color:_m_color];
    
    ccColor4F col = ccc4f(_m_color.ccColor4f.r, _m_color.ccColor4f.g, _m_color.ccColor4f.b, 255*0.75);
    CCColor *_aColor2 = [CCColor colorWithCcColor4f:col];
    [m_selectNode drawDot:ccp(0, 0) radius:DOT_RADIUES color:_aColor2];
    
    [self respawnDropdown];
}

-(void) spawnDropdown{
    m_dropCount = 0;
    
    [self stopAllActions];
    
    CGPoint pos = [self calcPos:_m_x y:_m_y];
    
    CCActionInterval * wait = [CCActionInterval actionWithDuration:_m_y*DROPDOWN_TIME/5];
    
    CCActionMoveTo * moveto = [CCActionMoveTo actionWithDuration:DROPDOWN_TIME/2 position:pos];
    
    CCActionJumpTo * jump = [CCActionJumpTo actionWithDuration:JUMP_TIME position:pos height:30 jumps:1];
    
    CCCallBlockO * callB = [CCCallBlockO actionWithBlock:^(id object) {
        m_hasSelected = NO;
        self.visible = YES;
    } object:self];
    
    CCActionSequence * seq = [CCActionSequence actions:wait,moveto,jump,callB, nil];
    
    [m_drawNode runAction:seq];
}
-(void) respawnDropdown{
    m_dropCount = 0;
    
    [self stopAllActions];
    
    CGPoint pos = [self calcPos:_m_x y:_m_y];
    
    CCActionMoveTo * moveto = [CCActionMoveTo actionWithDuration:DROPDOWN_TIME/3 position:pos];
    
    CCActionJumpTo * jump = [CCActionJumpTo actionWithDuration:JUMP_TIME/3*2 position:pos height:20 jumps:1];
    CCCallBlockO * callB = [CCCallBlockO actionWithBlock:^(id object) {
        m_hasSelected = NO;
        self.visible = YES;
    } object:self];
    
    CCActionSequence * seq = [CCActionSequence actions:moveto,jump,callB, nil];
    
    [m_drawNode runAction:seq];
}

-(void)resetPropertyA:(NSInteger)x Y:(NSInteger)y{
    if (y <_m_y) {
        m_dropCount ++;
    }
    _m_x = x;
    _m_y = y;
}

-(void)resetDropdown{
    
    m_hasSelected = YES;
    
    CGPoint pos = [self calcPos:_m_x y:_m_y];
    
    CCActionMoveTo *moveto = [CCActionMoveTo actionWithDuration:RESET_DROPDOWN_TIME position:pos];
    
    CCActionJumpTo * jump = [CCActionJumpTo actionWithDuration:RESET_JUMP_TIME/3
                                          position:pos height:15 jumps:1];
    CCCallBlockO * callB = [CCCallBlockO actionWithBlock:^(id object) {
        m_hasSelected = NO;
    } object:self];
    
    CCActionSequence * seq = [CCActionSequence actions:moveto, jump, callB, nil];
    
    [m_drawNode runAction:seq];
    m_dropCount = 0;
}

-(BOOL)positionInContent:(CGPoint)pos{
    
    CGFloat orgx = m_drawNode.position.x - DOT_WIDTH;
    CGFloat orgy = m_drawNode.position.y - DOT_HEIGHT;
    
    CGRect rect = CGRectMake(orgx, orgy, DOT_WIDTH*2, DOT_HEIGHT*2);
    
    return  CGRectContainsPoint(rect, pos);
}

-(BOOL)selectedType{
    
    m_hasSelected = YES;
    
    [m_selectNode stopAllActions];
    [m_selectNode setScale:1.0];
    [m_selectNode setVisible:true];
    
    CCActionScaleBy * scaleBy = [CCActionScaleBy actionWithDuration:0.1 scale:2.0];
    CCCallBlockO * block = [CCCallBlockO actionWithBlock:^(id object){
        [m_selectNode setVisible:false];
    } object:self];
    
    CCActionSequence * seq = [CCActionSequence actions:scaleBy, [scaleBy reverse], block, nil];
    [seq setTag:caleActiontag];
    [m_selectNode runAction:seq];
    
    return YES;
}

-(void)disappear:(bool)callf{
    
    CCActionScaleBy * scaleBy = [CCActionScaleBy actionWithDuration:0.1 scale:1.5];
    CCActionScaleBy * scaleBy2 = [CCActionScaleBy actionWithDuration:0.2 scale:0];
    CCActionSequence * seq = NULL;
    
    if (callf) {
        CCCallBlockO * callfu  = [CCCallBlockO actionWithBlock:^(id object) {
            
            if (self.parent) {
                NGGameScene * data = (NGGameScene*)self.parent;
                [data disappearEnd];
            }
        } object:self];
        seq = [CCActionSequence actions:scaleBy,scaleBy2,callfu, nil];
    }else{
        seq = [CCActionSequence actions:scaleBy,scaleBy2, nil];
    }
    
    _m_disappear = YES;
    
    [m_drawNode runAction:seq];
}

-(void) unselected{
    m_hasSelected = NO;
}

-(CGPoint)getDrawNodePosition{
    return m_drawNode.position;
}


-(void)KeepSelected{
    m_hasSelected = YES;
    
    [m_selectNode stopAllActions];
    
    [m_selectNode setVisible:true];
    
    CCActionScaleBy * scaleBy = [CCActionScaleBy actionWithDuration:0.1 scale:1.7];
    
    [m_selectNode runAction:scaleBy];
}

-(void)unKeepSelected{
    
    m_hasSelected = NO;
    [m_selectNode stopAllActions];
    
    CCActionScaleTo * scaleTo = [CCActionScaleTo actionWithDuration:0.1 scale:1.0];
    CCCallBlockO * block = [CCCallBlockO actionWithBlock:^(id object){
        [m_selectNode setVisible:false];
    } object:self];
    
    CCActionSequence * seq = [CCActionSequence actions:scaleTo, block, nil];
    [seq setTag:caleActiontag];
    [m_selectNode runAction:seq];
}

-(void) update: (CCTime) time {

}

@end
