//
//  CAFCardStackController.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "CAFCardStackController.h"
#import "UIView+ImageExtensions.h"


@implementation CAFCardStackController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - Properties
- (NSArray *)cardViewControllers
{
	return self.childViewControllers;
}


#pragma mark - Instance Methods
- (void)addCardViewController:(UIViewController *)viewController
{
	UIView *addedView = viewController.view;
	addedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	addedView.frame = CGRectMake(0.0, 0.0, 768.0, 1004.0);
	
	UIImage *viewImage = [addedView caf_imageRepresentation];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:viewImage];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.frame = CGRectMake(0.0, 0.0, 384.0, 502.0);
	[self.view addSubview:imageView];
	
//	[self addChildViewController:viewController];
//	
//	UIView *addedView = viewController.view;
//	[self.view addSubview:addedView];
//	addedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//	addedView.frame = self.view.bounds;
//		
//	[viewController didMoveToParentViewController:self];
}


- (void)focusCardViewController:(UIViewController *)viewController
{
	
}


- (void)showAllCardViewControllers
{
	
}


- (void)removeCardViewController:(UIViewController *)viewController
{
	
}

@end
