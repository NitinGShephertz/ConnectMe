//
//  HomeScene.m
//  ConnectMe
//
//  Created by Nitin Gupta on 30/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "HomeScene.h"
#import "NGGameScene.h"
#import "LDLeaderBoard.h"

@implementation HomeScene

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
    
    CCButton *playButton = [CCButton buttonWithTitle:@"Play"
                                               spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_normal.png"]
                                    highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_pressed.png"]
                                       disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_disabled.png"]];
    
    [playButton setTarget:self selector:@selector(playButtonAction:)];
    [self addChild:playButton];
    [playButton setPosition:CGPointMake(self.contentSize.width/2, self.contentSize.height/2 + playButton.contentSize.height/2)];
    [playButton setEnabled:YES];

    CCButton *leaderBoardButton = [CCButton buttonWithTitle:@"LeaderBoard"
                                         spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_normal.png"]
                              highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_pressed.png"]
                                 disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_disabled.png"]];
    
    [leaderBoardButton setTarget:self selector:@selector(leaderBoardAction:)];
    [self addChild:leaderBoardButton];
    [leaderBoardButton setPosition:CGPointMake(self.contentSize.width/2, self.contentSize.height/2 - playButton.contentSize.height)];
    [leaderBoardButton setEnabled:YES];

    return self;
}

- (void) playButtonAction:(id) sender {
    [[CCDirector sharedDirector] replaceScene:[NGGameScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.5]];
}

- (void) leaderBoardAction:(id)sender {
    LDLeaderBoard *board = [[LDLeaderBoard alloc] initWithNibName:@"LDLeaderBoard" bundle:nil];
    [[CCDirector sharedDirector] addChildViewController:board];
    [[[CCDirector sharedDirector] view] addSubview:board.view];
}

@end
