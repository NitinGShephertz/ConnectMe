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
    [self draw];
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    m_SpriteArray = [[NSMutableArray alloc]initWithCapacity:ROWS*COLOUMS];
    m_stackArray = [[NSMutableArray alloc]init];

    for (int y = 0; y<ROWS; y++) {
        for (int x = 0; x<COLOUMS; x++) {
            
            NGSprite * dotNode = [NGSprite node];
            
            [dotNode spawnAtX:x Y:y Width:DOT_WIDTH Height:DOT_HEIGHT];
            [m_SpriteArray addObject:dotNode];
            
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
    if (m_stackArray) {
        [m_stackArray removeAllObjects];
        m_stackArray = nil;
    }
    if (m_SpriteArray) {
        [m_SpriteArray removeAllObjects];
        m_SpriteArray = nil;
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
    if (m_SpriteArray) {
        
        for (NGSprite * node in m_SpriteArray) {
            
            if (node && [node positionInContent:pos]) {
                return node;
            }
        }
    }
    
    return NULL;
}

-(BOOL) touchBegine:(CGPoint)local{
    
    if (m_toolsDisappear) {
        
        [self toolDisappearSelected:local];
        
        return false;
    }
    
    m_movePos = local;
    m_objectHasContina = NO;
    m_removeAllSameColor = NO;
    
    if (m_stackArray.count !=0) {
        for (NGSprite * node in m_stackArray) {
            [node unselected];
        }
        [m_stackArray removeAllObjects];
    }
    
    NGSprite * ds = [self getCurrentSelectSprite:local];
    
    if (ds && [ds selectedType]) {
        
        [m_stackArray addObject:ds];
        m_currentDrawColor = ds.m_color;
        m_drawLine = YES;
        return YES;
    }
    return NO;
}

-(void) touchMove:(CGPoint)local {
    
    m_movePos = local;
    
    NGSprite * ds = [self getCurrentSelectSprite:local];
    
    if (ds && ccc4FEqual(m_currentDrawColor.ccColor4f, ds.m_color.ccColor4f)) {
        
        if (ds == [m_stackArray lastObject]) {
            return;
        }
        if (m_stackArray.count >=2 &&
            ds == [m_stackArray objectAtIndex:(m_stackArray.count-2)]) {
            
            NGSprite * tds = [m_stackArray lastObject];
            [tds unselected];
            if (m_objectHasContina) {
                m_removeAllSameColor = NO;
                m_objectHasContina = NO;
            }
            [m_stackArray removeLastObject];
            [ds selectedType];
            return;
        }
        
        if (!m_objectHasContina && [m_stackArray containsObject:ds]) {
            
            NGSprite * tds = [m_stackArray lastObject];
            
            NSInteger absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y);
            [ds unselected];
            if (absValue == 1 && [ds selectedType]) {
                
                m_objectHasContina = YES;
                m_removeAllSameColor = YES;
                
                [m_stackArray addObject:ds];
            }
        }
        
        if (m_objectHasContina && [m_stackArray containsObject:ds]) {
            return;
        }
        
        m_objectHasContina = NO;
        NGSprite * tds = [m_stackArray lastObject];
        
        NSInteger absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y);
        
        if ((absValue == 1 || absValue == 2) && [ds selectedType]) {
            [m_stackArray addObject:ds];
        }
    }
}

-(void)touchEnd {
    m_drawLine = NO;
    
    NSInteger disappearCount = 0;
    
    if (m_stackArray.count>=2) {
        if (m_removeAllSameColor) {
            
            [self disappearAllSameColorDotsWithSelected];
            
        }else{
            for (int i=0; i<m_stackArray.count; i++) {
                NGSprite * node = [m_stackArray objectAtIndex:i];
                if (node) {
                    if (i == m_stackArray.count-1) {
                        [node disappear:YES];
                    }
                    [node disappear:NO];
                    disappearCount ++;
                }
            }
        }
    }else{
        for (NGSprite * node in m_stackArray) {
            [node unselected];
        }
    }
    [m_stackArray removeAllObjects];
    
    m_score += disappearCount;
}

-(NSInteger) disappearAllSameColorDotsWithSelected{
    NSInteger count = 0;
    BOOL dis = YES;
    for (int i=0; i<m_SpriteArray.count; i++) {
        NGSprite * node = [m_SpriteArray objectAtIndex:i];
        if (node && ccc4FEqual(m_currentDrawColor.ccColor4f, node.m_color.ccColor4f)) {
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
    
    if (m_drawLine) {
        
        glLineWidth(10);
        
        ccColor4B c4b = ccc4BFromccc4F(m_currentDrawColor.ccColor4f);
        ccDrawColor4B(c4b.r, c4b.g, c4b.b, c4b.a);
        
        if ([m_stackArray count]>=2) {
            NGSprite * ds = [m_stackArray objectAtIndex:0];
            CGPoint pos = [ds getDrawNodePosition];
            for (int c=1; c<m_stackArray.count; c++) {
                ds  = [m_stackArray objectAtIndex:c];
                CGPoint pos1 = [ds getDrawNodePosition];
                ccDrawLine(pos, pos1);
                pos = pos1;
            }
        }
        NGSprite * ds = [m_stackArray lastObject];
        CGPoint pos = [ds getDrawNodePosition];
        ccDrawSolidRect(pos,m_movePos,m_currentDrawColor);
        ccDrawLine(pos, m_movePos);
    }
}

-(void)disappearEnd{
    
    NSMutableArray * dropArray = [NSMutableArray array];
    
    for (int i = 0; i< m_SpriteArray.count; i++) {
        NGSprite * ds = (NGSprite*)[m_SpriteArray objectAtIndex:i];
        
        [self calcDropDown:ds ResultArray:dropArray];
    }
    
    for (int i = 0; i<dropArray.count; i++) {
        
        NGSprite * ds = (NGSprite*)[dropArray objectAtIndex:i];
        
        [ds resetDropdown];
    }
    
    for (int i = 0; i< m_SpriteArray.count; i++) {
        
        NGSprite * ds = (NGSprite*)[m_SpriteArray objectAtIndex:i];
        
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
        
        NGSprite * nDS = (NGSprite *)[m_SpriteArray objectAtIndex:nIndex];
        if (nDS && nDS.m_disappear) {
            NSInteger nX = nDS.m_x;
            NSInteger nY = nDS.m_y;
            
            [nDS resetPropertyA:x Y:y];
            [ds resetPropertyA:nX Y:nY];
            
            [m_SpriteArray exchangeObjectAtIndex:index withObjectAtIndex:nIndex];
            
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
        
        if (m_toolsDisappearType) {
            
            m_currentDrawColor = ds.m_color;
            count = [self disappearAllSameColorDotsWithSelected];
        }else{
            [ds disappear:YES];
            count = 1;
        }
        m_toolsDisappear = NO;
        
        
        
        if (self.parent) {
            m_score += count;
            NSLog(@"m_score = %d",m_score);
        }
    }
    
}


-(BOOL)allDrawNodeBeSelected:(BOOL)disappearType{
    
    if (m_toolsDisappear) {
        return NO;
    }
    
    m_toolsDisappearType = disappearType;
    m_toolsDisappear = YES;
    
    for (int i=0; i< m_SpriteArray.count; i++) {
        
        NGSprite *ds = (NGSprite *)[m_SpriteArray objectAtIndex:i];
        if (ds) {
            [ds KeepSelected];
        }
    }
    
    return YES;
}


-(void) cancelAllDrawNodeBeSelected{
    
    for (int i=0; i< m_SpriteArray.count; i++) {
        
        NGSprite *ds = (NGSprite *)[m_SpriteArray objectAtIndex:i];
        if (ds) {
            [ds unKeepSelected];
        }
    }
}


#pragma mark - datahandle

-(void)startAnimtionDisplay{
    self.visible = true;
    if (m_SpriteArray) {
        
        for (NGSprite * node in m_SpriteArray) {
            
            if (node) {
                [node spawnDropdown];
            }
            [node setVisible:YES];
        }
    }
}


-(void)startPlaying{
    
    m_toolsDisappear = false;
    self.userInteractionEnabled = YES;
}

-(void)moveOut{
    [self setVisible:false];
}

-(void)moveIn{
    [self setVisible:true];
}


@end
