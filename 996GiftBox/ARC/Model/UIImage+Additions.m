//
//  UIImage+Additions.m
//  GameGifts
//
//  Created by Teiron-37 on 14-2-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)clipToFrame:(CGRect)rect {
	CGImageRef newImageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	return [UIImage imageWithCGImage:newImageRef];
}

- (UIImage *)spliceImage:(UIImage *)image withSize:(CGSize)size {
	CGSize totalSize= CGSizeMake(self.size.width + size.width,self.size.height);
	UIGraphicsBeginImageContext(totalSize);
    
    // Draw image1
	[self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
    
	// Draw image2
	[image drawInRect:CGRectMake(self.size.width, 0.0f, size.width, size.height)];
    
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return resultingImage;
}

@end
