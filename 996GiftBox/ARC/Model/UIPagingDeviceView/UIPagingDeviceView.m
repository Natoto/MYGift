//
//  UIPagingDeviceView.m
//  Network
//
//  Created by KevenTsang on 13-11-23.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "UIPagingDeviceView.h"

#define  PAGING_DEVICE_SELECTED_IMAGE_NAME_RED   @"nav_point_highlighted@2x"
#define  PAGING_DEVICE_DEFAULT_IMAGE_NAME_RED    @"nav_point@2x"

#define  PAGING_DEVICE_SELECTED_IMAGE_NAME_BLUE  @"blue_point_highlighted@2x"
#define  PAGING_DEVICE_DEFAULT_IMAGE_NAME_BLUE   @"blue_point@2x"

#define  SetDefaultImageWithPointImageView_RED(_obj)  _obj.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PAGING_DEVICE_DEFAULT_IMAGE_NAME_RED ofType:@"png"]]
#define  SetSelectedImageWithPointImageView_RED(_obj)   _obj.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PAGING_DEVICE_SELECTED_IMAGE_NAME_RED ofType:@"png"]]

#define  SetDefaultImageWithPointImageView_BLUE(_obj)  _obj.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PAGING_DEVICE_DEFAULT_IMAGE_NAME_BLUE ofType:@"png"]]
#define  SetSelectedImageWithPointImageView_BLUE(_obj)   _obj.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PAGING_DEVICE_SELECTED_IMAGE_NAME_BLUE ofType:@"png"]]


@interface UIPagingDeviceView()
@property (nonatomic,assign)NSInteger       selectedIndex;
@property (nonatomic,assign)NSInteger       allPointNumber;
@property (nonatomic,assign)UIPagingDeviceViewType   type;

@property (nonatomic,assign)CGFloat         spacingX;
@property (nonatomic,assign)CGPoint         origin;
@end

@implementation UIPagingDeviceView
- (id)initWithFrame:(CGRect)frame
        pointNumber:(NSInteger)number
               type:(UIPagingDeviceViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.allPointNumber = number;
        self.type = type;
        //创建显示的点
        [self setupPointImageViewsWithNumber:number];
    }
    return self;
}


- (void)setupPointImageViewsWithNumber:(NSInteger)dropNum
{
    NSString * selectedImageName = nil;
    NSString * defaultImageName = nil;
    if (self.type == UIPagingDeviceViewTypeRed) {
        selectedImageName = PAGING_DEVICE_SELECTED_IMAGE_NAME_RED;
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_RED;
    }else{
        selectedImageName = PAGING_DEVICE_SELECTED_IMAGE_NAME_BLUE;
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_BLUE;
    }
    UIImage * selectedImage = KT_GET_LOCAL_PICTURE_SECOND(selectedImageName);
    UIImage * defaultImage = KT_GET_LOCAL_PICTURE_SECOND(defaultImageName);
    CGSize imgSize = defaultImage.size;
    CGSize viewSize = self.bounds.size;
    //计算间距尺寸
    CGFloat spacing_x =  (viewSize.width - imgSize.width * dropNum)  / (2 + (dropNum - 1) * 2);
    CGFloat spacing_y =  (viewSize.height - imgSize.height) / 2;
    CGRect pointImageViewRect = CGRectMake(spacing_x, spacing_y, imgSize.width, imgSize.height);
    for (int i = 0; i < dropNum; i++) {
        @autoreleasepool {
            pointImageViewRect.origin.x = spacing_x + (imgSize.width + 2 * spacing_x) * i;
            UIImageView * pointImageViewTmp = [[UIImageView alloc] initWithFrame:pointImageViewRect];
            pointImageViewTmp.backgroundColor = [UIColor clearColor];
            pointImageViewTmp.tag = i;
            if (i == 0) {
                pointImageViewTmp.image = selectedImage;
            }else{
                pointImageViewTmp.image = defaultImage;
            }
            [self addSubview:pointImageViewTmp];
        }
    }
    self.selectedIndex = 0;
}

//-----------------------------------------//

- (id)initWithOrigin:(CGPoint)origin
         pointNumber:(NSInteger)number
            spacingX:(CGFloat)spacingX
                type:(UIPagingDeviceViewType)type
{
    self = [super init];
    if (self) {
        self.origin = origin;
        self.spacingX = spacingX;
        self.allPointNumber = number;
        self.type = type;
            //修改self.frame 大小
        self.frame = [self changePagingDeviceViewFrame];
        //创建显示的点
        [self setupPointImageViewsSecondMethodWithNumber:number];
    }
    return self;
}

- (CGRect)changePagingDeviceViewFrame
{
    CGRect frame = CGRectZero;
    frame.origin = self.origin;

    NSString * defaultImageName = nil;
    if (self.type == UIPagingDeviceViewTypeRed) {
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_RED;
    }else{
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_BLUE;
    }
    
    UIImage * defaultImage = KT_GET_LOCAL_PICTURE_SECOND(defaultImageName);
    CGSize imgSize = defaultImage.size;
    CGFloat width = (imgSize.width * self.allPointNumber) + (2 * self.spacingX) + ((self.allPointNumber - 1) * 2 * self.spacingX);
    frame.size.width = width;
    frame.size.height = imgSize.height;
    
    frame.origin.x = self.origin.x - width / 2;
    return frame;
}

- (void)setupPointImageViewsSecondMethodWithNumber:(NSInteger)dropNum
{
    
    NSString * selectedImageName = nil;
    NSString * defaultImageName = nil;
    if (self.type == UIPagingDeviceViewTypeRed) {
        selectedImageName = PAGING_DEVICE_SELECTED_IMAGE_NAME_RED;
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_RED;
    }else{
        selectedImageName = PAGING_DEVICE_SELECTED_IMAGE_NAME_BLUE;
        defaultImageName = PAGING_DEVICE_DEFAULT_IMAGE_NAME_BLUE;
    }
    
    UIImage * selectedImage = KT_GET_LOCAL_PICTURE_SECOND(selectedImageName);
    UIImage * defaultImage = KT_GET_LOCAL_PICTURE_SECOND(defaultImageName);
    CGSize imgSize = defaultImage.size;
    //计算间距尺寸
    CGFloat spacing_x =  self.spacingX;
    CGFloat spacing_y =  0;
    CGRect pointImageViewRect = CGRectMake(spacing_x, spacing_y, imgSize.width, imgSize.height);
    for (int i = 0; i < dropNum; i++) {
        @autoreleasepool {
            pointImageViewRect.origin.x = spacing_x + (imgSize.width + 2 * spacing_x) * i;
            UIImageView * pointImageViewTmp = [[UIImageView alloc] initWithFrame:pointImageViewRect];
            pointImageViewTmp.tag = i;
            if (i == 0) {
                pointImageViewTmp.image = selectedImage;
            }else{
                pointImageViewTmp.image = defaultImage;
            }
            [self addSubview:pointImageViewTmp];
        }
    }
    self.selectedIndex = 0;
}


//-----------------------------------------//
- (void)changePageNumberHightLightedIndex:(NSInteger)index
{
    if (index > self.allPointNumber) {
        return;
    }
    self.selectedIndex = index;
    NSArray * subViews = [self subviews];
      for (int i = 0; i < self.allPointNumber; i++) {
          UIImageView * pointImageViewTmp = [subViews objectAtIndex:i];
          
          if (self.type == UIPagingDeviceViewTypeRed) {
              SetDefaultImageWithPointImageView_RED(pointImageViewTmp);
              if (index == pointImageViewTmp.tag) {
                  SetSelectedImageWithPointImageView_RED(pointImageViewTmp);
              }
              
          }else{
              
              SetDefaultImageWithPointImageView_BLUE(pointImageViewTmp);
              if (index == pointImageViewTmp.tag) {
                  SetSelectedImageWithPointImageView_BLUE(pointImageViewTmp);
              }
          
          }
    }
}
@end
