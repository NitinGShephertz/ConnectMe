//
//  LDLeaderBoard.h
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDConstants.h"
// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface LDLeaderBoard : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *leaderboardTableView;
    IBOutlet UIButton *backButton;
    NSMutableArray *scoreList;
    IBOutlet UIView *indicatorView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UIButton *globalButton;
    int colorChanger;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *nameTitleLabel;
    IBOutlet UILabel *rankTitleLabel;
    IBOutlet UILabel *scoreTitleLabel;
    int rowHeight;
}

-(void)showAcitvityIndicator;
-(void)removeAcitvityIndicator;
-(void)getScore;
-(IBAction)globalButtonClicked:(id)sender;
-(IBAction)backButtonClicked:(id)sender;


@end
