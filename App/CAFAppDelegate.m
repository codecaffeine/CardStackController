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


@interface CAFAppDelegate ()
@property (strong, nonatomic) CAFCardStackController *cardStackController;
- (void)doneButtonPressed:(id)sender;
@end

@implementation CAFAppDelegate
@synthesize window				= _window;
@synthesize cardStackController	= _cardStackController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.cardStackController = [[CAFCardStackController alloc] init];
	__weak CAFAppDelegate *weakSelf = self;
	__weak CAFCardStackController *weakCardStackController = self.cardStackController;
	self.cardStackController.addButtonCallback = ^{
		CAFRandomColorViewController *randomColorViewController = [[CAFRandomColorViewController alloc] init];
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																					target:weakSelf 
																					action:@selector(doneButtonPressed:)];
		randomColorViewController.navigationItem.leftBarButtonItem = doneButton;
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:randomColorViewController];
		[weakCardStackController addCardViewController:navController];
	};
	
	self.window.rootViewController = self.cardStackController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)doneButtonPressed:(id)sender
{
	[self.cardStackController showAllCardViewControllers];
}


@end
