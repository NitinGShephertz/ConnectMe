//
//  NGGameData.h
//  ConnectMe
//
//  Created by Nitin Gupta on 01/05/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGGameConstants.h"

@interface NGGameData : NSObject {
    
}

@property (nonatomic, readonly) int score;
@property (nonatomic, readwrite, strong) NSString *userName;
@property (nonatomic, readwrite, strong) NSString *userID;


+(instancetype) sharedGameData;

- (void) updateScoreByValue:(int)_aValue;

@end
