//
//  CAFRandomColorViewController.m
//  Code/Caffeine Utilities
//
//  Created by Matthew Thomas on 12/22/11.
//  Copyright (c) 2011 Code/Caffeine. All rights reserved.
//

#import "CAFRandomColorViewController.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation CAFRandomColorViewController

#pragma mark - View lifecycle
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
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
