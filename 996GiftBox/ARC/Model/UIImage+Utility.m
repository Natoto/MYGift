//
//  UIImage+Utility.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-13.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

- (UIImage *)imageWithMaximumSize:(CGSize)size
{
	CGFloat horizontalScale = size.width / self.size.width;
	CGFloat verticalScale   = size.height / self.size.height;
    
	CGFloat smallerScale    = MIN(horizontalScale, verticalScale);
    
	smallerScale = MIN(1.0f, smallerScale);
    
	CGFloat width  = self.size.width * smallerScale;
	CGFloat height = self.size.height * smallerScale;
    
	CGSize newSize = CGSizeMake(width, height);
	return [self imageResizedToSize:newSize withCornerRadius:0];
}

- (UIImage *)imageResizedToSize:(CGSize)size
{
	return [self imageResizedToSize:size
                   withCornerRadius:0.0f
                            corners:DSCornerNone
                       transparency:YES];
}

- (UIImage *)imageResizedToSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
	return [self imageResizedToSize:size
                   withCornerRadius:radius
                            corners:DSCornerAll
                       transparency:YES];
}

- (UIImage *)imageResizedToSize:(CGSize)size withCornerRadius:(CGFloat)radius transparency:(BOOL)transparency
{
	return [self imageResizedToSize:size
                   withCornerRadius:radius
                            corners:DSCornerAll
                       transparency:transparency];
}

- (UIImage *)imageResizedToSize:(CGSize)size withCornerRadius:(CGFloat)radius corners:(DSCorner)corners transparency:(BOOL)transparency
{
	size = CGSizeMake(roundf(size.width), roundf(size.height));
    
	CGFloat
    imageXScale     = size.width / self.size.width,
    imageYScale     = size.height / self.size.height,
    imageScale      = MAX(imageXScale, imageYScale),
    imageDrawWidth  = imageScale * self.size.width,
    imageDrawHeight = imageScale * self.size.height,
    imageDrawX      = (size.width - imageDrawWidth) / 2,
    imageDrawY      = (size.height - imageDrawHeight) / 2;
    
	CGRect
    imageDrawRect = CGRectMake(imageDrawX, imageDrawY, imageDrawWidth, imageDrawHeight),
    bounds        = CGRectMake(0, 0, size.width, size.height);
    
	BOOL opaque = (CGImageGetAlphaInfo(self.CGImage) == kCGImageAlphaNone) && !radius && !transparency;
    
	UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0f);
	CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	// Round rectangle clip
    CGContextSaveGState(ctx);
    
	if (radius)
	{
		DSContextClipForRoundCorners(ctx, bounds, radius, corners);
	}
    
	[self drawInRect:imageDrawRect];
    
	CGContextRestoreGState(ctx);
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return newImage;
}

CGMutablePathRef DSRoundedRectCreate(CGRect rect, CGFloat radius, DSCorner corner)
{
	CGFloat
    x                   = rect.origin.x,
    y                   = rect.origin.y,
    x2                  = rect.size.width + x,
    y2                  = rect.size.height + y,
    topLeftRadius       = corner & DSCornerTopLeft ? radius : 0,
    bottomLeftRadius    = corner & DSCornerBottomLeft ? radius : 0,
    bottomRightRadius   = corner & DSCornerBottomRight ? radius : 0,
    topRightRadius      = corner & DSCornerTopRight ? radius : 0;
    
	CGMutablePathRef path = CGPathCreateMutable();
    
	CGPathMoveToPoint(path, NULL, topLeftRadius, y);
    
	// 1. Top Left
	CGPathAddLineToPoint(path, NULL, x2 - topLeftRadius, y);
	CGPathAddArcToPoint(path, NULL, x2, y, x2, topLeftRadius, topLeftRadius);
    
	// 2. Bottom Left
	CGPathAddLineToPoint(path, NULL, x2, y2 - bottomLeftRadius);
	CGPathAddArcToPoint(path, NULL, x2, y2, x2 - bottomLeftRadius, y2, bottomLeftRadius);
    
	// 3. Bottom Right
	CGPathAddLineToPoint(path, NULL, bottomRightRadius, y2);
	CGPathAddArcToPoint(path, NULL, x, y2, x, y2 - bottomRightRadius, bottomRightRadius);
    
	// 4. Top Right
	CGPathAddLineToPoint(path, NULL, x, topRightRadius);
	CGPathAddArcToPoint(path, NULL, x, y, topRightRadius, y, topRightRadius);
    
	CGPathCloseSubpath(path);
    
	return path;
}



void DSContextClipForRoundCorners(CGContextRef ctx, CGRect rect, CGFloat radius, DSCorner corner)
{
	CGPathRef path = DSRoundedRectCreate(rect, radius, corner);
	CGContextAddPath(ctx, path);
	CGPathRelease(path);
	CGContextClip(ctx);
}

void DSContextDrawVerticalGradient(CGContextRef ctx, CGFloat y, CGFloat height, CGColorRef color1, CGColorRef color2)
{
	CGPoint         start  = CGPointMake(0.0, y);
	CGPoint         stop   = CGPointMake(0.0, y + height);
	CGColorSpaceRef space  = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithObjects:(__bridge id)color1, (__bridge id)color2, nil];
    
	CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);
    
	CGContextDrawLinearGradient(ctx, gradient, start, stop, 0);
    
	CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}

+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
