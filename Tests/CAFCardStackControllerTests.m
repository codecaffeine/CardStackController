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
	STAssertNotNil(cardStackController.cardViewControllers, 
				   @"%@: cardViewControllers property shouldn't be nil, but it is", 
				   NSStringFromClass([self class]));

}

- (void)testAddCardViewControllerAddsToArray
{
	CAFCardStackController *cardStackController = [[CAFCardStackController alloc] init];
	CAFRandomColorViewController *randomColorViewController = [[CAFRandomColorViewController alloc] init];
	[cardStackController addCardViewController:randomColorViewController];
	STAssertTrue([cardStackController.cardViewControllers count] == 1, 
				 @"%@: should have one object, but has %d", 
				 NSStringFromClass([self class]), 
				 [cardStackController.cardViewControllers count]);
}

@end
