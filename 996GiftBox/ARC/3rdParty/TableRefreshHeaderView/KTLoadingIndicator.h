//
//  KTLoadingIndicator.h
//  996GameBox
//
//  Created by keven on 13-12-2.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTLoadingIndicator : UIView
{
    float radius;
    CGPoint center;
    float arrowEdgeLength;
}
- (void)stopLoading;
- (void)didScroll:(float)offset;


@end


@interface KTLoadingIndicatorOver : UIView
- (void)stopAnimating;
- (void)startAnimating;
@end