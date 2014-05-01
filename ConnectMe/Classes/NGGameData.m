//
//  NGGameData.m
//  ConnectMe
//
//  Created by Nitin Gupta on 01/05/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "NGGameData.h"

static NGGameData *dataInstance = nil;

@implementation NGGameData
@synthesize score = _score;
@synthesize userName = _userName;
@synthesize userID = _userID;

+(instancetype) sharedGameData {
    if(dataInstance == nil){
		dataInstance = [[self alloc] init];
	}
	return dataInstance;

}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    _userName = nil;
    _score = 0;
}

- (void) updateScoreByValue:(int)_aValue {
    _score += abs(_aValue * Score_Multiplier);
    _score = _score < 0 ? 0 : _score;
    NSLog(@"my score = %d",_score);
}

@end
