//
//  TRUIButton.h
//  PPHelper
//
//  Created by chenjunhong on 13-2-23.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUIButton : UIButton
{
    NSMutableDictionary *_userInfo;
    id _target;
    SEL _action;
    
    NSTimeInterval _delayTime;
}

@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action delayTime:(NSTimeInterval)delayTime;

@end
