//
//  GBCommonSearchBar.h
//  996GameBox
//
//  Created by Teiron-37 on 13-11-29.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBSearchBarDelegate <NSObject>
- (void)searchGameWithGameHotString:(NSString *)hotString;
- (void)cancelSearch;
@end

@interface GBSearchBar : UIView
<UITextFieldDelegate>

@property (nonatomic, KT_WEAK) UIButton *magnifierButton;
@property (nonatomic,KT_WEAK)UITextField *inputTextField;
@property (nonatomic,KT_WEAK)id<GBSearchBarDelegate>delegate;

- (void)isFirstResponser:(BOOL)flag;
//清空搜索
- (void)clearSearch:(id)sender;
- (void)searchWithStr:(NSString *)str;

@end