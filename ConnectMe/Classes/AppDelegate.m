//
//  AppDelegate.m
//  ConnectMe
//
//  Created by Nitin Gupta on 23/04/14.
//  Copyright Shephertz 2014. All rights reserved.
// 

#import "AppDelegate.h"
#import "NGGameScene.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		CCSetupShowDebugStats: @(NO),
	}];
	
	return YES;
}

-(CCScene *)startScene {
	// This method should return the very first scene to be run when your app starts.
	return [NGGameScene scene];
}

@end
