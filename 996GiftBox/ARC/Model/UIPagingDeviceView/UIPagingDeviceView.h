//
//  UIPagingDeviceView.h
//  Network
//
//  Created by KevenTsang on 13-11-23.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UIPagingDeviceViewType) {
    UIPagingDeviceViewTypeRed,
    UIPagingDeviceViewTypeBlue
};

@interface UIPagingDeviceView : UIView
@property (readonly,nonatomic,assign)NSInteger       selectedIndex;
@property (readonly,nonatomic,assign)NSInteger       allPointNumber;

/*
    这种是从外面传frame和点的个数 来布局
 */
//pageNumber>1
- (id)initWithFrame:(CGRect)frame
        pointNumber:(NSInteger)number
               type:(UIPagingDeviceViewType)type;
/*
    这种是外面传间距和点的个数来布局
*/
- (id)initWithOrigin:(CGPoint)origin
         pointNumber:(NSInteger)number
            spacingX:(CGFloat)spacingX
                type:(UIPagingDeviceViewType)type;



- (void)changePageNumberHightLightedIndex:(NSInteger)index;
@end
