//
//  NGGameOverScene.m
//  ConnectMe
//
//  Created by Nitin Gupta on 30/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "NGGameOverScene.h"
#import "NGGameScene.h"
#import "NGGooglePlusScene.h"
#import "NGGameData.h"

@implementation NGGameOverScene

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
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.15f green:0.15f blue:0.3f alpha:1.0f]];
    [self addChild:background];
    
    CCButton *replayButton = [CCButton buttonWithTitle:@"Replay"
                                         spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_normal.png"]
                              highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_pressed.png"]
                                 disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_disabled.png"]];
    
    [replayButton setTarget:self selector:@selector(replayButtonAction:)];
    [self addChild:replayButton];
    [replayButton setPosition:CGPointMake(self.contentSize.width/2, self.contentSize.height/2 + replayButton.contentSize.height/2)];
    [replayButton setEnabled:YES];
    
    NSString *_scoreStr = [NSString stringWithFormat:@"%d",[[NGGameData sharedGameData] score]];
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:_scoreStr fontName:@"" fontSize:20.0f];
    [scoreLabel setPosition:CGPointMake(self.contentSize.width/2,replayButton.position.y - replayButton.contentSize.height)];
    [self addChild:scoreLabel];
    
    CCButton *submitScore = [CCButton buttonWithTitle:@"Submit Score"
                                          spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_normal.png"]
                               highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_pressed.png"]
                                  disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_disabled.png"]];
    
    [submitScore setTarget:self selector:@selector(submitScoreAction:)];
    [self addChild:submitScore];
    [submitScore setPosition:CGPointMake(self.contentSize.width/2,scoreLabel.position.y - replayButton.contentSize.height)];
    [submitScore setEnabled:YES];

    return self;
}

- (void) replayButtonAction:(id) sender {
    [[CCDirector sharedDirector] replaceScene:[NGGameScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5]];
}

- (void) submitScoreAction:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[NGGooglePlusScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5]];
}


@end
