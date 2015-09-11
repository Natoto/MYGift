//
//  GBRankingSearchView.m
//  996GameBox
//
//  Created by Teiron-37 on 13-11-28.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "GBSearchBar.h"
#import "BaiduMobStat.h"

@interface GBSearchBar()
@property (nonatomic,copy)NSString * searchString;
@property (nonatomic, KT_WEAK)UIImageView *backgroundImageView;
@property (nonatomic, KT_WEAK) UIButton *searchClearButton;
@property (nonatomic, KT_WEAK) UIButton *cancelButton;
@end

@implementation GBSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = nil;
        self.backgroundColor = KT_UICOLOR_CLEAR;
        [self setupSearchView];
    }
    return self;
}

- (void)setupSearchView
{
    //搜索框
    UIImage * searchFrameImage = [KT_GET_LOCAL_PICTURE(@"search_field@2x") stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    backgroundImageView.backgroundColor = KT_UICOLOR_CLEAR;
    [self addSubview:backgroundImageView];
    backgroundImageView.image = searchFrameImage;
    
    self.backgroundImageView = backgroundImageView;
    
    
    //放大镜
    UIButton * magnifierButton = [UIButton buttonWithType:UIButtonTypeCustom];
    magnifierButton.frame = CGRectMake(15.5, 12, 25, 25);
    [magnifierButton setImage:KT_GET_LOCAL_PICTURE(@"search_magnifier@2x") forState:UIControlStateNormal];
    magnifierButton.userInteractionEnabled = NO;
    [self addSubview:magnifierButton];
    
    self.magnifierButton = magnifierButton;
    
    //清除搜索按钮
    UIButton * searchClearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchClearButton.frame = CGRectMake(233.5, 12, 40, 40);
    searchClearButton.imageEdgeInsets = UIEdgeInsetsMake(6.5, 6.5, 6.5, 6.5);
    [searchClearButton setImage:KT_GET_LOCAL_PICTURE(@"search_clear@2x") forState:UIControlStateNormal];
    searchClearButton.hidden = YES;
    [searchClearButton addTarget:self action:@selector(clearSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchClearButton];
    
    self.searchClearButton = searchClearButton;
    
    //取消按钮
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(self.frame.size.width, 10, 40, 30);
    [cancelButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"search_button@2x") forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"search_button_highlight@2x") forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [cancelButton addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    self.cancelButton = cancelButton;
    
    
    
    //输入UI
    UITextField * inputTextFieldTmp = [[UITextField alloc] initWithFrame:CGRectMake(42, 12, 236, 26)];
    inputTextFieldTmp.backgroundColor = KT_UICOLOR_CLEAR;
    inputTextFieldTmp.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; //上下对齐
    inputTextFieldTmp.delegate = self;
    inputTextFieldTmp.returnKeyType = UIReturnKeySearch;
    inputTextFieldTmp.placeholder =  @"请输入游戏关键字";
    inputTextFieldTmp.textColor = KT_UIColorWithRGBA(153.0 / 255.0, 153.0 / 255.0, 153.0 / 255.0, 1);
    inputTextFieldTmp.textAlignment =  NSTextAlignmentLeft;
    inputTextFieldTmp.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:inputTextFieldTmp];
    
    self.inputTextField = inputTextFieldTmp;
}

- (void)searchWithStr:(NSString *)str
{
    self.inputTextField.text = str;
    [self textFieldShouldReturn:self.inputTextField];
}

//取消搜索
- (void)cancelSearch:(id)sender
{
    //关闭键盘
    [self.inputTextField resignFirstResponder];
    //清空数据
    [self clearSearch:nil];
    //回调
    if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
        [self.delegate cancelSearch];
    }
}

//点搜索Action
- (void)clickSearchButton:(id)sender
{
    if (self.inputTextField.isFirstResponder) {
        [self cancelSearch:sender];
    }
    else {
        [self.inputTextField becomeFirstResponder];
        [self textFieldShouldReturn:self.inputTextField];
    }
}

- (void)handleSearch
{
    if (![Utils isNilOrEmpty:self.searchString]) {
        if ([self.delegate respondsToSelector:@selector(searchGameWithGameHotString:)]) {
            [self.delegate searchGameWithGameHotString:self.searchString];
        }
    }
    
}

//清除搜索
- (void)clearSearch:(id)sender
{
    self.searchString = nil;
    self.inputTextField.text = @"";
    self.searchClearButton.hidden = YES;
}

- (void)isFirstResponser:(BOOL)flag
{
    flag?[self.inputTextField becomeFirstResponder]:[self.inputTextField resignFirstResponder];
}

- (void)layoutWithSearching:(BOOL)search
{
    if (search) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundImageView.frame = CGRectMake(10, 10, 255, 30);
                             self.inputTextField.frame = CGRectMake(42, 12, 191, 26);
                             self.cancelButton.frame = CGRectMake(270, 10, 40, 30);
                             self.searchClearButton.frame = CGRectMake(233.5, 12, 26, 26);
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundImageView.frame = CGRectMake(10, 10, 300, 30);
                             self.inputTextField.frame = CGRectMake(42, 12, 236, 26);
                             self.cancelButton.frame = CGRectMake(self.frame.size.width, 10, 40, 30);
                             self.searchClearButton.frame = CGRectMake(278.5, 12, 26, 26);
                             
                         } completion:^(BOOL finished) {
                            
                         }];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    KT_DLOG_SELECTOR;
    [self layoutWithSearching:YES];
    
    self.searchString = nil;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    KT_DLOG_SELECTOR;
    [self layoutWithSearching:NO];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    KT_DLOG_SELECTOR;
    self.searchString = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    KT_DLOG_SELECTOR;
    if (![Utils isNilOrEmpty:textField.text]) {
        self.searchString = textField.text;
        [self handleSearch];
        [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_SEARCH_BUTTON eventLabel:textField.text];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    KT_DLOG_SELECTOR;
    if (textField.text.length > 1 || string.length > 0) {
        self.searchClearButton.hidden = NO;
    }
    else{
        self.searchClearButton.hidden = YES;
    }
    return YES;
}

@end
