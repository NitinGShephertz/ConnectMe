//
//  LDLeaderBoard.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 18/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDLeaderBoard.h"
#import "App42Helper.h"

@implementation LDLeaderBoard


- (id)initWithNibName:(NSString *)nibNameOrNilBase bundle:(NSBundle *)nibBundleOrNil {
    NSString *nibNameOrNil;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        nibNameOrNil = [NSString stringWithFormat:@"%@_iPhone",nibNameOrNilBase];
    } else {
        nibNameOrNil = [NSString stringWithFormat:@"%@_iPad",nibNameOrNilBase];
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {

}


-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scoreList = [[NSMutableArray alloc] initWithCapacity:0];
    messageLabel.hidden = YES;
    leaderboardTableView.dataSource = self;
    leaderboardTableView.delegate   = self;
    colorChanger = 1;
    [self showAcitvityIndicator];
    
    [self globalButtonClicked:nil];
    if (IS_IPHONE5) {
        self.view.frame = CGRectMake(0, 0, 568, 320);
        [leaderboardTableView setFrame:CGRectMake(leaderboardTableView.frame.origin.x+20, leaderboardTableView.frame.origin.y, 288, leaderboardTableView.frame.size.height)];
        globalButton.center = CGPointMake(globalButton.center.x+30, globalButton.center.y);
        
        nameTitleLabel.center = CGPointMake(nameTitleLabel.center.x+32, nameTitleLabel.center.y);
        rankTitleLabel.center = CGPointMake(rankTitleLabel.center.x+46, rankTitleLabel.center.y);
        scoreTitleLabel.center = CGPointMake(scoreTitleLabel.center.x+58, scoreTitleLabel.center.y);
        indicatorView.center = CGPointMake(indicatorView.center.x+50, indicatorView.center.y);
        
    }
    
}


-(void)getScore {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [scoreList removeAllObjects];
        [scoreList addObjectsFromArray:[[App42Helper sharedApp42Helper] getScores]];
        NSLog(@"scoreList=%@",scoreList);
        if (scoreList&&[scoreList count]) {
            messageLabel.hidden = YES;
        } else {
            messageLabel.hidden = NO;
        }
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [leaderboardTableView reloadData];
            [self removeAcitvityIndicator];
        });
    });
}

-(void)showAcitvityIndicator {
    [activityIndicatorView startAnimating];
}

-(void)removeAcitvityIndicator {
    [activityIndicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions
-(IBAction)globalButtonClicked:(id)sender {
    [globalButton setSelected:YES];
    [self showAcitvityIndicator];
    [self getScore];
}

-(IBAction)backButtonClicked:(id)sender {
    if ([self.view superview]) {
        [self.view removeFromSuperview];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s",__FUNCTION__);
    if (tableView) {
        NSLog(@"%s",__func__);
        // Return the number of sections.
        return 1;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s",__FUNCTION__);
    int numberOfRows =0;
    if (scoreList) {
        numberOfRows =[scoreList count];
    }
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__FUNCTION__);
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        CGSize viewSize = leaderboardTableView.frame.size;
        float labelWidth = viewSize.width/3;
        float x_pos = 5;
        float y_pos = 15;
        
        int fontSize = 24;
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
            x_pos = 2;
            y_pos = 3;
            fontSize = 16;
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, rowHeight)];
        
        bgView.tag=5;
        [cell addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x_pos, 2, rowHeight-4, rowHeight-4)];
        imageView.tag = 1;
        
        x_pos +=imageView.frame.size.width;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_pos, y_pos, labelWidth, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag =2;
        nameLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:fontSize];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:nameLabel];
        
        x_pos +=labelWidth/1.5;
        UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_pos, y_pos, labelWidth, 30)];
        rankLabel.backgroundColor = [UIColor clearColor];
        rankLabel.tag =3;
        rankLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:fontSize];
        rankLabel.textAlignment = NSTextAlignmentCenter;
        [rankLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:rankLabel];
        
        x_pos +=labelWidth;
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_pos, y_pos, labelWidth, 30)];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.tag =4;
        scoreLabel.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:fontSize];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        [scoreLabel setTextColor:[UIColor whiteColor]];
        [cell addSubview:scoreLabel];
        
    }
    
    Score *l_score = [scoreList objectAtIndex:indexPath.row];
    NSArray *metaArray = [l_score jsonDocArray];
    NSString *jsonString = [(JSONDocument *)[metaArray objectAtIndex:0] jsonDoc];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    [(UILabel *)[cell viewWithTag:2] setText:[jsonDict objectForKey:@"Name"]];
    [(UILabel *)[cell viewWithTag:3] setText:[NSString stringWithFormat:@"%d",indexPath.row+1]];
    [(UILabel *)[cell viewWithTag:4] setText:[NSString stringWithFormat:@"%0.0f",[[jsonDict objectForKey:@"Score"] floatValue]]];
    
    UIView *bgview = (UIView *)[cell viewWithTag:5];
    if (indexPath.row%2==0) {
        bgview.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:143.0f/255.0f blue:19.0f/255.0f alpha:1.0f];
    } else {
        bgview.backgroundColor = [UIColor colorWithRed:183.0f/255.0f green:106.0f/255.0f blue:15.0f/255.0f alpha:1.0f];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__FUNCTION__);
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        rowHeight = 36;
    } else {
        rowHeight = 54;
    }
    return rowHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s",__func__);
}

@end
