//
//  NGGooglePlusScene.m
//  ConnectMe
//
//  Created by Nitin Gupta on 30/04/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "NGGooglePlusScene.h"
#import "NGGameConstants.h"
#import "NGGameData.h"
#import "HomeScene.h"
#import "App42Helper.h"

@implementation NGGooglePlusScene

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
    [self draw];
    
    CCButton *googlePlusButton = [CCButton buttonWithTitle:@""
                                spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_normal.png"]
                                highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_pressed.png"]
                                disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Play_Button_disabled.png"]];
    
    [googlePlusButton setTarget:self selector:@selector(googlePlusButtonAction:)];
    [self addChild:googlePlusButton];
    [googlePlusButton setPosition:CGPointMake(self.contentSize.width/2, self.contentSize.height/2)];
    
    CCLabelTTF *gPlusLabel = [CCLabelTTF labelWithString:@"Google+" fontName:@"" fontSize:20.0f];
    [gPlusLabel setPosition:CGPointMake(self.contentSize.width/2, self.contentSize.height/2)];
    [self addChild:gPlusLabel];

    return self;
}

- (void) googlePlusButtonAction:(id)sender {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGoogleUserID = YES;
    signIn.delegate = self;

    if (![[GPPSignIn sharedInstance] hasAuthInKeychain]) {
        [[GPPSignIn sharedInstance] authenticate];
    } else {
        [[GPPSignIn sharedInstance] trySilentAuthentication];
    }

    [self reportAuthStatus];
    
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        NSLog(@"Status: Authenticated");
        NSLog(@"userID = %@,userEmail = %@,googlePlusUser = %@",[GPPSignIn sharedInstance].userID,[GPPSignIn sharedInstance].userEmail,[GPPSignIn sharedInstance].googlePlusUser);
        [[NGGameData sharedGameData] setUserName:[[GPPSignIn sharedInstance] userID]];
        [self loginDoneSubmitScore];
    } else {
        // To authenticate, use Google+ sign-in button.
        NSLog(@"Status: Not authenticated");
    }
    
}

#pragma mark - GPPSignInDelegate Delegates
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    NSLog(@"%s,Error = %@",__FUNCTION__,[error description]);
    [self reportAuthStatus];
}

- (void)didDisconnectWithError:(NSError *)error {
    NSLog(@"%s,Error = %@",__FUNCTION__,[error description]);
}

- (void) loginDoneSubmitScore {
    [self showLoadingIndicator];
    NSString *anID = [[NGGameData sharedGameData] userName];
    if ([anID length]) {
        [[App42Helper sharedApp42Helper] setUserID:anID];
        __block BOOL _success = false;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[App42Helper sharedApp42Helper] setScore:[[NGGameData sharedGameData] score]];
            _success = [[App42Helper sharedApp42Helper] saveScore];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [self removeLaodingIndicator];
                if (_success) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Score submitted successfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                    [alert setTag:200];
                    [alert setDelegate:self];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Oooops!!" message:@"Score submission failed" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                }
            });
        });
    }
}


- (void) showLoadingIndicator {
    
}

- (void) removeLaodingIndicator {
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200 && buttonIndex == 0) {
        [[CCDirector sharedDirector] replaceScene:[HomeScene scene] withTransition:[CCTransition transitionFadeWithDuration:0.2]];
    }
}



@end
