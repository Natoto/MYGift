//
//  ClickLabel.h
//  996GameBox
//
//  Created by Keven on 13-12-7.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#ifndef __KT_CLICK_LABEL_H__
#define __KT_CLICK_LABEL_H__
#import <UIKit/UIKit.h>
@interface ClickLabel : UILabel
KT_PROPERTY_COPY NSMutableAttributedString * attributedString;
KT_PROPERTY_ASSIGN id delegate;
KT_PROPERTY_ASSIGN SEL action;
/**
 *  初始化一个显示颜色，超链接的标签
 *
 *  @param frame    文本的大小，尺寸
 *  @param text     内容
 *  @param fontSize 字体大小
 *  @param color    字体颜色
 *  @param isLine   是否支持下划线
 *  @param delegate 代理
 *  @param action   代理事件
 *
 *  @return 返回一个文本
 */
- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
           fontSize:(CGFloat)fontSize
          textColor:(UIColor *)color
          underLine:(BOOL)isLine
             target:(id)delegate
             action:(SEL)action;
/**
 *  初始化一个显示颜色，超链接的标签
 *
 *  @param frame     文本的大小，尺寸
 *  @param dataArray 文本参数 （text，color，font）暂时 key 分别为 text  color ,fontSize <==> [{@"ddd",@"text",@"redColor",@"color",@"12",@"fontSize"}]
 *
 *  @return 返回一个文本
 */
- (id)initWithFrame:(CGRect)frame
      textDataArray:(NSArray *)dataArray;
/**
 *  从新渲染文本，显示颜色，超链接的标签
 *
 *  @param dataArray 文本参数 （text，color，font）暂时 key 分别为 text  color ,fontSize <==> [{@"ddd",@"text",@"redColor",@"color",@"12",@"fontSize"}]
 */
- (void)setupClickLabelWithTextDataArray:(NSArray *)dataArray;
/**
 *  从新渲染文本，显示颜色，超链接的标签
 *
 *  @param text     文本内容
 *  @param fontSize 文本字体大小
 *  @param color    文本显示颜色
 *  @param isLine   是否支持下划线
 */
- (void)setupClickLabelWithText:(NSString *)text
                       fontSize:(CGFloat)fontSize
                      textColor:(UIColor *)color
                      underLine:(BOOL)isLine;
@end
#endif