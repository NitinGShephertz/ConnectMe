//
//  App42Helper.h
//  Cocos2DSimpleGame
//
//  Created by Shephertz Technology on 03/04/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h"

@protocol App42HelperDelegate <NSObject>
@optional
- (void) getScoreCompleted;
- (void) saveScoreCompleted;
@end

@interface App42Helper : NSObject {

}

@property (nonatomic,assign) id <App42HelperDelegate> delegate;
@property (nonatomic,retain) NSString *userID;
@property (nonatomic,assign) int      score;

+(App42Helper *)sharedApp42Helper ;

- (void)initializeApp42;

//App42CloudAPI Handler Methods
-(BOOL)saveScore;
-(NSMutableArray*)getScores;


@end
