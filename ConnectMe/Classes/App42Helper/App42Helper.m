//
//  App42Helper.m
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 03/04/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "App42Helper.h"
#import "LDConstants.h"
#import "NGGameData.h"

static App42Helper *app42Instance;

@implementation App42Helper
@synthesize delegate = _delegate;
@synthesize userID  = _userID;
@synthesize score = _score;

+(App42Helper *)sharedApp42Helper {
	if(app42Instance == nil){
		app42Instance = [[self alloc] init];
	}
	return app42Instance;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        _userID    = nil;
        _score = 0;
	}
	return self;
}

- (void)dealloc {
    if (_userID) {
        _userID=nil;
    }
}

- (void)initializeApp42 {
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    [App42API setDbName:DB_NAME];
}

#pragma mark --App42CloudAPI Handler Methods

-(BOOL)saveScore {
    BOOL _success = false;
    @try {
        NSString *name = [[NGGameData sharedGameData] userName];
        ScoreBoardService *scoreboardService = [App42API buildScoreBoardService];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_userID,@"UserID",[NSNumber numberWithInt:_score],@"Score",name,@"Name", nil];
        [scoreboardService addCustomScore:dict collectionName:COLLECTION_NAME];

        Game *game=[scoreboardService saveUserScore:GAME_NAME gameUserName:_userID gameScore:_score];
        if(game.isResponseSuccess) {
            NSLog(@"saveScore Success");
            _success = true;
        }
    }
    @catch (App42Exception *exception) {
        NSLog(@"%@",[exception description]);
    }
    return _success;
}

-(NSMutableArray*)getScores {
    ScoreBoardService *scoreboardService = [App42API buildScoreBoardService];
    [scoreboardService setQuery:COLLECTION_NAME metaInfoQuery:Nil];

    Game *game=[scoreboardService getTopNRankers:GAME_NAME max:MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB];
    NSMutableArray *scoreList = game.scoreList;
    return scoreList;
}


@end
