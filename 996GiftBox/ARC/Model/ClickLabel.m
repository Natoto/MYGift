//
//  ClickLabel.m
//  996GameBox
//
//  Created by Keven on 13-12-7.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "ClickLabel.h"
#import <CoreText/CoreText.h>
@implementation ClickLabel
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
             action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.delegate = delegate;
        self.action = action;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        [self setupClickLabelWithText:text fontSize:fontSize textColor:color underLine:isLine];
    }
    return self;
}
/**
 *  初始化一个显示颜色，超链接的标签
 *
 *  @param frame     文本的大小，尺寸
 *  @param dataArray 文本参数 （text，color，font）暂时 key 分别为 text  color ,fontSize <==> [{@"ddd",@"text",@"redColor",@"color",@"12",@"fontSize"}]
 *
 *  @return 返回一个文本
 */
- (id)initWithFrame:(CGRect)frame
      textDataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        [self setupClickLabelWithTextDataArray:dataArray];
    }
    return self;
}
/**
 *  从新渲染文本，显示颜色，超链接的标签
 *
 *  @param dataArray 文本参数 （text，color，font）暂时 key 分别为 text  color ,fontSize <==> [{@"ddd",@"text",@"redColor",@"color",@"12",@"fontSize"}]
 */
- (void)setupClickLabelWithTextDataArray:(NSArray *)dataArray
{
    
    NSMutableAttributedString * refaultString = [[NSMutableAttributedString alloc] initWithString:@""];
    [refaultString beginEditing];
    for (int i = 0; i < [dataArray count]; i++) {
        @autoreleasepool {
            //文本内容
            NSString * text = [[dataArray objectAtIndex:i] objectForKey:@"text"];
            NSUInteger textLenght = [text length];
            
            NSAttributedString * attributeString = [[NSAttributedString alloc] initWithString:text];
            [refaultString appendAttributedString:attributeString];
            //文本颜色
            UIColor * color = [[dataArray objectAtIndex:i] objectForKey:@"color"];
            //文本字体大小
            CGFloat fontSize = [[[dataArray objectAtIndex:i] objectForKey:@"fontSize"] floatValue];
            
            CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[[UIFont systemFontOfSize:fontSize] fontName], fontSize, NULL);
            NSDictionary *  setDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)fontRef,(id)kCTFontAttributeName,
                       color.CGColor,(id)kCTForegroundColorAttributeName,nil];
            [refaultString addAttributes:setDict range:NSMakeRange([refaultString length] - textLenght, textLenght)];
        }
      
    }
    [refaultString endEditing];
    self.attributedString = refaultString;
    [self setNeedsDisplay];
    
}
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
                      underLine:(BOOL)isLine
{
    //颜色 ,大小，字体，下划线，
    CTFontRef font = CTFontCreateWithName((CFStringRef)[[UIFont systemFontOfSize:fontSize] fontName], fontSize, NULL);
    NSDictionary * setDict = nil;
    if (isLine) {
      setDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)font,(id)kCTFontAttributeName,
                                  color.CGColor,(id)kCTForegroundColorAttributeName,
                                  [NSNumber numberWithInt:kCTUnderlineStyleSingle],(id)kCTUnderlineStyleAttributeName,
                                  color.CGColor,(id)kCTUnderlineColorAttributeName,nil];
    }else{
        setDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)font,(id)kCTFontAttributeName,
                   color.CGColor,(id)kCTForegroundColorAttributeName,nil];
    }
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:setDict];
    [self setNeedsDisplay];
}
/**
 *  文本渲染
 *
 *  @param rect 渲染的区域
 */
- (void)drawTextInRect:(CGRect)rect
{
    CGContextRef  _context = UIGraphicsGetCurrentContext();  //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextSetTextMatrix(_context, CGAffineTransformIdentity);
    /*设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    x，y轴方向移动
     */
    CGContextTranslateCTM(_context , 0 ,self.bounds.size.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(_context, 1.0 ,-1.0);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    //坐标在左下角
    CGPathAddRect(path, NULL, CGRectMake(0, -5, self.bounds.size.width , self.bounds.size.height));
    CTFrameRef ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame,_context);
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(frameSetter);
}
/**
 *  点击手势的响应事件
 *
 *  @param gesture 手势对象
 */
- (void)handleTapGesture:(UIGestureRecognizer *)gesture
{
    KT_DLOG_SELECTOR;
    self.backgroundColor = KT_UIColorWithRGB(0xbe, 0xdf, 0xff);
    if ([self.delegate respondsToSelector:self.action]) {
        [self.delegate performSelector:self.action withObject:nil];
    }
    [self performSelector:@selector(unselectClickLabel:) withObject:nil afterDelay:0.5];
}
/**
 *  文件点击响应的颜色变化
 *
 *  @param sender 手势对象
 */
-(void)unselectClickLabel:(id)sender
{
   self.backgroundColor = KT_UICOLOR_CLEAR;
}
/**
 *  防止手势，点击的干扰
 *
 *  @param point 位置坐标
 *  @param event 事件
 *
 *  @return 处理响应事件的视图
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  return  CGRectContainsPoint(self.bounds, point) ? self :[self superview];
}
@end
