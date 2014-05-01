//
//  NGGameConstants.h
//  ConnectMe
//
//  Created by Nitin Gupta on 23/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kClientId = @"618732988321-quuc1o5tb70h4urqqmtgtts6dhg3k9ce.apps.googleusercontent.com";

#define COLOUMS 6
#define ROWS 6

#define DROPDOWN_TIME 0.5
#define JUMP_TIME 0.3

#define RESET_DROPDOWN_TIME 0.2
#define RESET_JUMP_TIME 0.3
#define RESET_JUMP_TIMES 3

#define GAME_TIME 60

#define Score_Multiplier 50

typedef enum {
    kRed,
    kGreen,
    KBlue,
    kPurple,
    kOrange,
    kColorTypeLenght
} ColorType;

#define caleActiontag 100

