//
//  CAFCardStackController.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "CAFCardStackController.h"
#import <QuartzCore/QuartzCore.h>


const CGFloat CAFCardStackControllerDefaultAnimationDuration = 0.3;
const CGFloat CAFCardStackControllerDefaultMinimizedScale = 0.45;

@interface CAFCardStackController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIViewController *focusedViewController;
- (void)didReceivePanGesture:(UIPanGestureRecognizer *)panGesture;
- (void)didReceiveTapGesture:(UITapGestureRecognizer *)tapGesture;
- (void)addGestureRecognizersToView:(UIView *)view;
- (UIViewController *)childViewControllerForView:(UIView *)view;
- (IBAction)addButtonPressed:(id)sender;
- (void)updateTitle;
@end


@implementation CAFCardStackController {
	NSMutableDictionary *_viewControllerIDMap;
	NSMutableDictionary *_viewIDMap;
}
@synthesize titleBarButtonItem		= _titleBarButtonItem;
@synthesize addButtonCallback		= _addButtonCallback;
@synthesize toolbar					= _toolbar;
@synthesize focusedViewController	= _focusedViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		_viewControllerIDMap = [[NSMutableDictionary alloc] init];
		_viewIDMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateTitle];
}


- (void)viewDidUnload
{
	[self setTitleBarButtonItem:nil];
	[self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
								duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	for (NSString *key in _viewIDMap) {
		UIView *view = [_viewIDMap objectForKey:key ];
		view.layer.shadowOpacity = 0.0f;
	}

}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	for (NSString *key in _viewIDMap) {
		UIView *view = [_viewIDMap objectForKey:key ];
		view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
		view.layer.shadowOpacity = 0.75f;
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Properties
- (NSArray *)cardViewControllers
{
	return self.childViewControllers;
}


#pragma mark - Instance Methods
- (void)addCardViewController:(UIViewController *)viewController
{
	if (viewController 
		&& ![self.childViewControllers containsObject:viewController]) {
		CFUUIDRef uniqueID = CFUUIDCreate(kCFAllocatorDefault);
		CFStringRef uniqueStringRef = CFUUIDCreateString(kCFAllocatorDefault, 
														 uniqueID);
		CFRelease(uniqueID);
		NSString *uniqueString = (__bridge NSString *)uniqueStringRef;		
		[_viewControllerIDMap setObject:viewController forKey:uniqueString];
		CFRelease(uniqueStringRef);

		[self addChildViewController:viewController];
		
		UIView *addedView = viewController.view;
		[_viewIDMap setObject:addedView forKey:uniqueString];
		
		addedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
		addedView.frame = self.view.bounds;
		addedView.alpha = 0.0f;
		addedView.transform  = CGAffineTransformMakeScale(CAFCardStackControllerDefaultMinimizedScale, 
														  CAFCardStackControllerDefaultMinimizedScale);
		
		addedView.layer.shadowOpacity = 0.75f;
		addedView.layer.shadowRadius = 25.0f;
		addedView.layer.shadowOffset = CGSizeZero;
		addedView.layer.shadowColor = [UIColor blackColor].CGColor;
		addedView.layer.shadowPath = [UIBezierPath bezierPathWithRect:addedView.bounds].CGPath;
		
		[self.view insertSubview:addedView belowSubview:self.toolbar];
		[self addGestureRecognizersToView:addedView];
		
		[UIView animateWithDuration:CAFCardStackControllerDefaultAnimationDuration 
						 animations:^{
							 addedView.alpha = 1.0f;
						 } 
						 completion:^(BOOL finished) {
							 [viewController didMoveToParentViewController:self];
							 [self updateTitle];
						 }];
	}
}


- (void)focusCardViewController:(UIViewController *)viewController
{
	if ([self.childViewControllers containsObject:viewController]) {
		self.focusedViewController = viewController;
		
		UIView *view = viewController.view;
		NSArray *gestureRecognizers = view.gestureRecognizers;
		for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
			[view removeGestureRecognizer:gestureRecognizer];
		}
		
		[UIView animateWithDuration:CAFCardStackControllerDefaultAnimationDuration 
						 animations:^{
							 view.transform  = CGAffineTransformIdentity;
							 view.frame = self.view.bounds;
						 }];
	}
}


- (void)showAllCardViewControllers
{
	UIView *currentView = self.focusedViewController.view;
	[UIView animateWithDuration:CAFCardStackControllerDefaultAnimationDuration 
					 animations:^{
						 currentView.transform  = CGAffineTransformMakeScale(CAFCardStackControllerDefaultMinimizedScale, 
																		   CAFCardStackControllerDefaultMinimizedScale);

					 } 
					 completion:^(BOOL finished) {
						 [self.view insertSubview:currentView belowSubview:self.toolbar];
						 [self addGestureRecognizersToView:currentView];
						 self.focusedViewController = nil;
					 }];
}


- (void)removeCardViewController:(UIViewController *)viewController
{
	UIView *currentView = viewController.view;
	[currentView removeFromSuperview];
	
	[viewController willMoveToParentViewController:nil];
	[viewController removeFromParentViewController];
	[self updateTitle];
}


#pragma mark - Private Methods
- (void)didReceivePanGesture:(UIPanGestureRecognizer *)panGesture
{
	UIView *currentView = panGesture.view;
	CGPoint translation = [panGesture translationInView:currentView.superview];
	
	if (panGesture.state == UIGestureRecognizerStateBegan) {
		[self.view insertSubview:currentView belowSubview:self.toolbar];
	} else if (panGesture.state == UIGestureRecognizerStateChanged) {
		[currentView setCenter:CGPointMake(currentView.center.x + translation.x, currentView.center.y + translation.y)];
		[panGesture setTranslation:CGPointZero inView:currentView.superview];
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGPoint velocity = [panGesture velocityInView:currentView.superview];
		NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
		
		CGPoint finalTranslation = CGPointMake(velocity.x * CAFCardStackControllerDefaultAnimationDuration, 
											   velocity.y * CAFCardStackControllerDefaultAnimationDuration);
		NSLog(@"finalTranslation: %@", NSStringFromCGPoint(finalTranslation));
		
		[UIView animateWithDuration:0.74f 
							  delay:0.0f 
							options:UIViewAnimationOptionCurveEaseOut 
						 animations:^{
							 CGRect newFrame = panGesture.view.frame;
							 newFrame.origin.x += finalTranslation.x;
							 newFrame.origin.y += finalTranslation.y;
							 currentView.frame = newFrame;
						 } 
						 completion:^(BOOL finished) {
							 BOOL intersection = CGRectIntersectsRect(currentView.superview.frame, currentView.frame);
							 if (!intersection) {
								 UIViewController *viewController = [self childViewControllerForView:currentView];
								 if (viewController) {
									 [self removeCardViewController:viewController];
								 }
							 }
						 }];
	}
}


- (void)didReceiveTapGesture:(UITapGestureRecognizer *)tapGesture
{
	if (tapGesture.state == UIGestureRecognizerStateEnded) {
		UIView *currentView = tapGesture.view;
		[self.view insertSubview:currentView aboveSubview:self.toolbar];
		UIViewController *viewController = [self childViewControllerForView:currentView];
		if (viewController) {
			[self focusCardViewController:viewController];
		}
	}
}


- (void)addGestureRecognizersToView:(UIView *)view
{
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self 
																						   action:@selector(didReceivePanGesture:)];
	[view addGestureRecognizer:panGestureRecognizer];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
																						   action:@selector(didReceiveTapGesture:)];
	[view addGestureRecognizer:tapGestureRecognizer];
}


- (UIViewController *)childViewControllerForView:(UIView *)view
{
	UIViewController *childViewController = nil;
	NSArray *viewIDs = [_viewIDMap allKeysForObject:view];
	if ([viewIDs count] == 1) {
		NSString *viewID = [viewIDs lastObject];
		childViewController = [_viewControllerIDMap objectForKey:viewID];
	}
	return childViewController;
}


- (IBAction)addButtonPressed:(id)sender
{
	if (self.addButtonCallback) {
		self.addButtonCallback();
	}
}


- (void)updateTitle
{
	self.title = [NSString stringWithFormat:@"View Controllers: %d", [self.childViewControllers count]];
	self.titleBarButtonItem.title = self.title;
}

@end
