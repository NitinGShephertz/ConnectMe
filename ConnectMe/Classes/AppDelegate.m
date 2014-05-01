//
//  AppDelegate.m
//  ConnectMe
//
//  Created by Nitin Gupta on 23/04/14.
//  Copyright Shephertz 2014. All rights reserved.
// 

#import "AppDelegate.h"
#import "NGGameConstants.h"
#import "HomeScene.h"
#import "App42Helper.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GPPSignIn sharedInstance] setClientID:kClientId];
    [[App42Helper sharedApp42Helper] initializeApp42];
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
	}];
	
	return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

-(CCScene *)startScene {
	// This method should return the very first scene to be run when your app starts.
	return [HomeScene scene];
}

@end
