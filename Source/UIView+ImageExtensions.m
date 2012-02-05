//
//  UIView+ImageExtensions.m
//  Card Stack Controller Demo
//
//  Created by Matthew Thomas on 2/5/12.
//  Copyright (c) 2012 Code/Caffeine. All rights reserved.
//

#import "UIView+ImageExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ImageExtensions)

- (UIImage *)caf_imageRepresentation
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
