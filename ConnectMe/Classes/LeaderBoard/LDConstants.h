//
//  LDConstants.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>


#define APP42_APP_KEY         @"178168768c9d458f84d6da29a9215c1e87daf298c41c3c2bdf63198ef22d7eaf"//<Your App Key>
#define APP42_SECRET_KEY      @"180dd662dab71b482a99babbf7e57fba99595b82e3113fae28ab020c0cb1215f"//<Your Secret Key>

#define GAME_NAME             @"iOSLeaderBoard"//<Your Game Name>

#define DB_NAME               @"ScoreDB"
#define COLLECTION_NAME       @"ScoreCollection"

#define MAX_NUMBER_OF_RECORDS_DISPLAYED_IN_LB   20
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
