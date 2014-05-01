//
//  HelloWorldScene.m
//  ConnectMe
//
//  Created by Nitin Gupta on 23/04/14.
//  Copyright Shephertz 2014. All rights reserved.
// 

#import "NGGameScene.h"
#import "NGSprite.h"
#import "NGGameConstants.h"
#import "NGGameOverScene.h"
#import "NGGameData.h"

@implementation NGGameScene

static inline NSString* calcIndex(int x,int y){
    return [NSString stringWithFormat:@"%d",COLOUMS * y + x];
}

+ (instancetype)scene {
    return [[self alloc] init];
}
 

- (id)init {
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) {
        return(nil);
    }
    // Enable touch handling on scene node
    self.userInteractionEnabled = NO;
    
    _timeElapsed = 0;
    _totalTimeLeft = GAME_TIME;
    
    [self draw];
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    _aSpriteArray = [[NSMutableArray alloc]initWithCapacity:ROWS*COLOUMS];
    _stackArray = [[NSMutableArray alloc]init];

    for (int y = 0; y<ROWS; y++) {
        for (int x = 0; x<COLOUMS; x++) {
            
            NGSprite * dotNode = [NGSprite node];
            
            [dotNode spawnAtX:x Y:y];
            [_aSpriteArray addObject:dotNode];
            
            [self addChild:dotNode z:1];
            
            [dotNode setVisible:NO];
        }
    }
    
    self.visible = false;

    [self startPlaying];
    [self startAnimtionDisplay];

	return self;
}


- (void)dealloc {
    if (_stackArray) {
        [_stackArray removeAllObjects];
        _stackArray = nil;
    }
    if (_aSpriteArray) {
        [_aSpriteArray removeAllObjects];
        _aSpriteArray = nil;
    }
}

#pragma mark - Touch Handler
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    [self touchBegine:touchLoc];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    [self touchMove:touchLoc];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self touchEnd];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self touchEnd];
}

-(NGSprite *)getCurrentSelectSprite:(CGPoint)pos {
    if (_aSpriteArray) {
        
        for (NGSprite * node in _aSpriteArray) {
            
            if (node && [node positionInContent:pos]) {
                return node;
            }
        }
    }
    
    return NULL;
}

-(BOOL) touchBegine:(CGPoint)local{
    
    if (_toolsDisappear) {
        
        [self toolDisappearSelected:local];
        
        return false;
    }
    
    _movePos = local;
    _hasObject = NO;
    _removeAllSameColor = NO;
    
    if (_stackArray.count !=0) {
        for (NGSprite * node in _stackArray) {
            [node unselected];
        }
        [_stackArray removeAllObjects];
    }
    
    NGSprite * ds = [self getCurrentSelectSprite:local];
    
    if (ds && [ds selectedType]) {
        
        [_stackArray addObject:ds];
        _currentDrawColor = ds.m_color;
        _drawLine = YES;
        return YES;
    }
    return NO;
}

-(void) touchMove:(CGPoint)local {
    
    _movePos = local;
    
    NGSprite * ds = [self getCurrentSelectSprite:local];
    
    if (ds && ccc4FEqual(_currentDrawColor.ccColor4f, ds.m_color.ccColor4f)) {
        
        if (ds == [_stackArray lastObject]) {
            return;
        }
        if (_stackArray.count >=2 &&
            ds == [_stackArray objectAtIndex:(_stackArray.count-2)]) {
            
            NGSprite * tds = [_stackArray lastObject];
            [tds unselected];
            if (_hasObject) {
                _removeAllSameColor = NO;
                _hasObject = NO;
            }
            [_stackArray removeLastObject];
            [ds selectedType];
            return;
        }
        
        if (!_hasObject && [_stackArray containsObject:ds]) {
            
            NGSprite * tds = [_stackArray lastObject];
            
            NSInteger absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y);
            [ds unselected];
            if (absValue == 1 && [ds selectedType]) {
                
                _hasObject = YES;
                _removeAllSameColor = YES;
                
                [_stackArray addObject:ds];
            }
        }
        
        if (_hasObject && [_stackArray containsObject:ds]) {
            return;
        }
        
        _hasObject = NO;
        NGSprite * tds = [_stackArray lastObject];
        
        NSInteger absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y);
        
        if ((absValue == 1 || absValue == 2) && [ds selectedType]) {
            [_stackArray addObject:ds];
        }
    }
}

-(void)touchEnd {
    _drawLine = NO;
    
    NSInteger disappearCount = 0;
    
    if (_stackArray.count>=2) {
        if (_removeAllSameColor) {
            
            [self disappearAllSameColorDotsWithSelected];
            
        }else{
            for (int i=0; i<_stackArray.count; i++) {
                NGSprite * node = [_stackArray objectAtIndex:i];
                if (node) {
                    if (i == _stackArray.count-1) {
                        [node disappear:YES];
                    }
                    [node disappear:NO];
                    disappearCount ++;
                }
            }
        }
    }else{
        for (NGSprite * node in _stackArray) {
            [node unselected];
        }
    }
    [_stackArray removeAllObjects];
    
    [[NGGameData sharedGameData] updateScoreByValue:disappearCount];
}

-(NSInteger) disappearAllSameColorDotsWithSelected{
    NSInteger count = 0;
    BOOL dis = YES;
    for (int i=0; i<_aSpriteArray.count; i++) {
        NGSprite * node = [_aSpriteArray objectAtIndex:i];
        if (node && ccc4FEqual(_currentDrawColor.ccColor4f, node.m_color.ccColor4f)) {
            if (dis) {
                [node disappear:YES];
                dis = NO;
            }
            [node disappear:NO];
            count ++;
        }
    }
    return count;
}

-(void)draw{
    [super draw];
    
    if (_drawLine) {
        
        glLineWidth(10);
        
        ccColor4B c4b = ccc4BFromccc4F(_currentDrawColor.ccColor4f);
        ccDrawColor4B(c4b.r, c4b.g, c4b.b, c4b.a);
        
        if ([_stackArray count]>=2) {
            NGSprite * ds = [_stackArray objectAtIndex:0];
            CGPoint pos = [ds getDrawNodePosition];
            for (int c=1; c<_stackArray.count; c++) {
                ds  = [_stackArray objectAtIndex:c];
                CGPoint pos1 = [ds getDrawNodePosition];
                ccDrawLine(pos, pos1);
                pos = pos1;
            }
        }
        NGSprite * ds = [_stackArray lastObject];
        CGPoint pos = [ds getDrawNodePosition];
        ccDrawSolidRect(pos,_movePos,_currentDrawColor);
        ccDrawLine(pos, _movePos);
    }
}

-(void)disappearEnd{
    
    NSMutableArray * dropArray = [NSMutableArray array];
    
    for (int i = 0; i< _aSpriteArray.count; i++) {
        NGSprite * ds = (NGSprite*)[_aSpriteArray objectAtIndex:i];
        
        [self calcDropDown:ds ResultArray:dropArray];
    }
    
    for (int i = 0; i<dropArray.count; i++) {
        
        NGSprite * ds = (NGSprite*)[dropArray objectAtIndex:i];
        
        [ds resetDropdown];
    }
    
    for (int i = 0; i< _aSpriteArray.count; i++) {
        
        NGSprite * ds = (NGSprite*)[_aSpriteArray objectAtIndex:i];
        
        if (ds.m_disappear) {
            [ds respawn];
        }
    }
}

-(void) calcDropDown:(NGSprite*) ds ResultArray:(NSMutableArray *) resultArray{
    
    if (!ds) {
        return;
    }
    
    while (true) {
        NSInteger x = ds.m_x;
        NSInteger y = ds.m_y;
        
        NSInteger index = y*ROWS + x;
        NSInteger nIndex = (y-1) * ROWS +x;
        
        if (nIndex<0) {
            break;
        }
        
        NGSprite * nDS = (NGSprite *)[_aSpriteArray objectAtIndex:nIndex];
        if (nDS && nDS.m_disappear) {
            NSInteger nX = nDS.m_x;
            NSInteger nY = nDS.m_y;
            
            [nDS resetPropertyA:x Y:y];
            [ds resetPropertyA:nX Y:nY];
            
            [_aSpriteArray exchangeObjectAtIndex:index withObjectAtIndex:nIndex];
            
            if (![resultArray containsObject:ds] && !ds.m_disappear) {
                [resultArray addObject:ds];
            }
        }
        if(nDS && !nDS.m_disappear){
            break;
        }
    }
}

-(void) toolDisappearSelected:(CGPoint) local{
    
    NGSprite * ds = [self getCurrentSelectSprite:local];
    
    int count = 0;
    
    if (ds) {
        
        [self cancelAllDrawNodeBeSelected];
        
        if (_toolsDisappearType) {
            
            _currentDrawColor = ds.m_color;
            count = [self disappearAllSameColorDotsWithSelected];
        }else{
            [ds disappear:YES];
            count = 1;
        }
        _toolsDisappear = NO;
        
        
        
        if (self.parent) {
            [[NGGameData sharedGameData] updateScoreByValue:count];
        }
    }
    
}


-(BOOL)allDrawNodeBeSelected:(BOOL)disappearType{
    
    if (_toolsDisappear) {
        return NO;
    }
    
    _toolsDisappearType = disappearType;
    _toolsDisappear = YES;
    
    for (int i=0; i< _aSpriteArray.count; i++) {
        
        NGSprite *ds = (NGSprite *)[_aSpriteArray objectAtIndex:i];
        if (ds) {
            [ds KeepSelected];
        }
    }
    
    return YES;
}


-(void) cancelAllDrawNodeBeSelected{
    
    for (int i=0; i< _aSpriteArray.count; i++) {
        
        NGSprite *ds = (NGSprite *)[_aSpriteArray objectAtIndex:i];
        if (ds) {
            [ds unKeepSelected];
        }
    }
}


#pragma mark - datahandle

-(void)startAnimtionDisplay{
    self.visible = true;
    if (_aSpriteArray) {
        
        for (NGSprite * node in _aSpriteArray) {
            
            if (node) {
                [node spawnDropdown];
            }
            [node setVisible:YES];
        }
    }
}


-(void)startPlaying{
    
    _toolsDisappear = false;
    self.userInteractionEnabled = YES;
}

- (void) update:(CCTime)delta {
    _timeElapsed += delta;
    if (_timeElapsed >= 1) {
        _timeElapsed = 0;
        [self updateGameTimer];
    }
}

- (void) updateGameTimer {
    _totalTimeLeft --;
    if (_totalTimeLeft <= 0) {
        [self gameOver];
    } else {
        [self updateHUDForTimeLeftTimer];
    }
}

- (void) updateHUDForTimeLeftTimer {
    NSLog(@"Time Left = %d",_totalTimeLeft);
}

- (void) gameOver {
    [[CCDirector sharedDirector] replaceScene:[NGGameOverScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5]];
}


@end
