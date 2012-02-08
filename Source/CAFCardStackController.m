//
//  CAFCardStackController.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "CAFCardStackController.h"


const CGFloat CAFCardStackControllerDefaultAnimationDuration = 0.3;
const CGFloat CAFCardStackControllerDefaultMinimizedScale = 0.45;

@interface CAFCardStackController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIViewController *focusedViewController;
- (void)didReceivePanGesture:(UIPanGestureRecognizer *)panGesture;
- (void)didReceiveTapGesture:(UITapGestureRecognizer *)tapGesture;
- (IBAction)addButtonPressed:(id)sender;
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
    self.titleBarButtonItem.title = self.title;
}


- (void)viewDidUnload
{
	[self setTitleBarButtonItem:nil];
	[self setToolbar:nil];
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
		
		addedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		addedView.frame = self.view.bounds;
		addedView.alpha = 0.0f;
		addedView.transform  = CGAffineTransformMakeScale(CAFCardStackControllerDefaultMinimizedScale, 
														  CAFCardStackControllerDefaultMinimizedScale);
		[self.view insertSubview:addedView belowSubview:self.toolbar];
		[UIView animateWithDuration:CAFCardStackControllerDefaultAnimationDuration 
						 animations:^{
							 addedView.alpha = 1.0f;
						 } 
						 completion:^(BOOL finished) {
							 [viewController didMoveToParentViewController:self];
						 }];
		
		UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self 
																							   action:@selector(didReceivePanGesture:)];
		[addedView addGestureRecognizer:panGestureRecognizer];
		
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
																							   action:@selector(didReceiveTapGesture:)];
		[addedView addGestureRecognizer:tapGestureRecognizer];
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
						 self.focusedViewController = nil;
					 }];
}


- (void)removeCardViewController:(UIViewController *)viewController
{
	
}


#pragma mark - Private Methods
- (void)didReceivePanGesture:(UIPanGestureRecognizer *)panGesture
{
	CGPoint translate = [panGesture translationInView:self.view];
	
	UIView *currentView = panGesture.view;
	if (panGesture.state == UIGestureRecognizerStateBegan) {
		[self.view insertSubview:currentView belowSubview:self.toolbar];
	} else if (panGesture.state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [panGesture translationInView:currentView.superview];
		[currentView setCenter:CGPointMake(currentView.center.x + translation.x, currentView.center.y + translation.y)];
		[panGesture setTranslation:CGPointZero inView:currentView.superview];
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGRect newFrame = panGesture.view.frame;
		newFrame.origin.x += translate.x;
		newFrame.origin.y += translate.y;
		currentView.frame = newFrame;
	}
}


- (void)didReceiveTapGesture:(UITapGestureRecognizer *)tapGesture
{
	if (tapGesture.state == UIGestureRecognizerStateEnded) {
		UIView *currentView = tapGesture.view;
		[self.view insertSubview:currentView aboveSubview:self.toolbar];
		NSArray *viewIDs = [_viewIDMap allKeysForObject:currentView];
		if ([viewIDs count] == 1) {
			NSString *viewID = [viewIDs lastObject];
			UIViewController *currentViewController = [_viewControllerIDMap objectForKey:viewID];
			[self focusCardViewController:currentViewController];
		}
	}
}


- (IBAction)addButtonPressed:(id)sender
{
	if (self.addButtonCallback) {
		self.addButtonCallback();
	}
}

@end
