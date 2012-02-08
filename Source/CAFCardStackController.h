//
//  CAFCardStackController.h
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAFCardStackController : UIViewController
@property (readonly) NSArray *cardViewControllers;
@property (strong, nonatomic) void(^addButtonCallback)();
@property (readonly, strong, nonatomic) UIViewController *focusedViewController;
- (void)addCardViewController:(UIViewController *)viewController;
- (void)focusCardViewController:(UIViewController *)viewController;
- (void)showAllCardViewControllers;
- (void)removeCardViewController:(UIViewController *)viewController;
@end
