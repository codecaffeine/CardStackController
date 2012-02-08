//
//  CAFRandomColorViewController.m
//  Code/Caffeine Utilities
//
//  Created by Matthew Thomas on 12/22/11.
//  Copyright (c) 2011 Code/Caffeine. All rights reserved.
//

#import "CAFRandomColorViewController.h"

#define ARC4RANDOM_MAX      0x100000000


@interface CAFRandomColorViewController ()
- (void)doneButtonPressed:(id)sender;
@end


@implementation CAFRandomColorViewController
@synthesize doneButtonCallback;

- (void)loadView
{
	CGFloat red = ((float)arc4random() / ARC4RANDOM_MAX) * 1.0f;
	CGFloat green = ((float)arc4random() / ARC4RANDOM_MAX) * 1.0f;
	CGFloat blue = ((float)arc4random() / ARC4RANDOM_MAX) * 1.0f;
	UIColor *color = [[UIColor alloc] initWithRed:red 
											green:green 
											 blue:blue 
											alpha:1.0f];
	self.title = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
	UIView *aView = [[UIView alloc] init];
	self.view = aView;
	self.view.backgroundColor = color;
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																				target:self 
																				action:@selector(doneButtonPressed:)];
	self.navigationItem.leftBarButtonItem = doneButton;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)doneButtonPressed:(id)sender
{
	if (self.doneButtonCallback) {
		self.doneButtonCallback();
	}
}


@end
