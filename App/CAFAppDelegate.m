//
//  CAFAppDelegate.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "CAFAppDelegate.h"
#import "CAFCardStackController.h"
#import "CAFRandomColorViewController.h"


@implementation CAFAppDelegate
@synthesize window				= _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	CAFCardStackController *_cardStackController = [[CAFCardStackController alloc] init];
	__weak CAFCardStackController *cardStackController = _cardStackController;
	cardStackController.title = @"View Controllers";
	cardStackController.addButtonCallback = ^{
		CAFRandomColorViewController *randomColorViewController = [[CAFRandomColorViewController alloc] init];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:randomColorViewController];
		[cardStackController addCardViewController:navController];
	};
	
	self.window.rootViewController= cardStackController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
