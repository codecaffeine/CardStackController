//
//  CAFCardStackControllerTests.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "CAFCardStackControllerTests.h"
#import "CAFCardStackController.h"
#import "CAFRandomColorViewController.h"

@implementation CAFCardStackControllerTests

- (void)testCardStackControllerInitializesEmptyArray
{
	CAFCardStackController *cardStackController = [[CAFCardStackController alloc] init];
	STAssertNotNil(cardStackController.cardViewControllers, @"is nil");
	STAssertTrue([cardStackController.cardViewControllers count] == 0, 
				 @"%@: cardViewControllers array should have no objects but has %d", 
				 NSStringFromClass([self class]), 
				 [cardStackController.cardViewControllers count]);

}

- (void)testAddCardViewControllerAddsToArray
{
	CAFCardStackController *cardStackController = [[CAFCardStackController alloc] init];
	CAFRandomColorViewController *randomColorViewController = [[CAFRandomColorViewController alloc] init];
	[cardStackController addCardViewController:randomColorViewController];
	STAssertTrue([cardStackController.cardViewControllers count] == 1, 
				 @"contains %d objects", 
				 [cardStackController.cardViewControllers count]);
	UIViewController *viewController = [cardStackController.cardViewControllers objectAtIndex:0];
	STAssertEqualObjects(randomColorViewController, 
						 viewController, 
						 @"%@ differs from %@", 
						 randomColorViewController, 
						 viewController);
}

@end
