//
//  GBActionSheet.m
//  996GameBox
//
//  Created by Teiron-37 on 13-12-5.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "GBActionSheet.h"
#import "GBAppDelegate.h"
//#import "UMSocial.h"
#define BG_ACTIONSHEET_DURATION 0.3
#define BG_MASKVIEW_DURATION 0.2

@interface GBActionSheet()
@property (nonatomic, assign)enum KGBActionSheetType actionSheetType;
@property (nonatomic, KT_STRONG)NSArray *titles;
@property (nonatomic, copy)GBActionSheetClickHandler block;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, KT_WEAK)UIView *maskView;
@property (nonatomic, KT_WEAK)UITextField *accountTextField;
@property (nonatomic, KT_WEAK)UITextField *passworldTextField;
@property (nonatomic, KT_WEAK)UITextField *confirmPassworldTextField;
@property (nonatomic, KT_WEAK)UIView *foundKeyboard;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL enableAnamation;

@end

@implementation GBActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(enum KGBActionSheetType)type
        withTitles:(NSArray *)titles
          callBack:(GBActionSheetClickHandler)block
     selectedIndex:(int)index
{
    CGFloat height = 0.0f;
    if (type == KGBActionSheetTypeSetting1 ||
        type == KGBActionSheetTypeSetting2 ||
        type == KGBActionSheetTypePersonInfo1 ||
        type == KGBActionSheetTypePersonInfo2) {
        height = [titles count]*43 + 2 + 45 + [titles count]-1;
    }
    else if (type == KGBActionSheetTypeLogin){
        //登录
        height = 196.0f;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    else if (type == KGBActionSheetTypeRegister){
        //注册
        height = 240.0f;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    else if (KGBActionSheetTypeShare){
        //分享
        height = 169;
    }
    
    CGRect frame = CGRectMake(0.0f, [Utils screenHeight], [Utils screenWidth], height);
    self = [super initWithFrame:frame];
    if (self) {
        self.actionSheetType = type;
        self.titles = titles;
        self.block = block;
        self.selectedIndex = index;
        self.enableAnamation = YES;
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setup
{
    CGFloat y = 0;
    
    self.backgroundColor = KT_HEXCOLOR(0xffffff);
    
    UIView *lineView22 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, self.bounds.size.width, 2)];
    lineView22.backgroundColor = KT_HEXCOLOR(0xff8500);
    [self addSubview:lineView22];
    y += 2;
    
    if (self.actionSheetType == KGBActionSheetTypeSetting1 ||
        self.actionSheetType == KGBActionSheetTypeSetting2 ||
        self.actionSheetType == KGBActionSheetTypePersonInfo1 ||
        self.actionSheetType == KGBActionSheetTypePersonInfo2) {
        for (int i = 0; i<[self.titles count]; ++i) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i+1;
            button.frame = CGRectMake(0.0f, y, self.bounds.size.width,  43);
            button.titleLabel.font = GB_DEFAULT_FONT(15);
            [button setTitleColor:KT_HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [button setTitle:(NSString *)[self.titles objectAtIndex:i] forState:UIControlStateNormal];
            CGSize buttonSize = KT_TEXTSIZE_SIMPLE(button.titleLabel.text, button.titleLabel.font);
            if (self.selectedIndex == i+1) {
                [button setImage:KT_GET_LOCAL_PICTURE(@"setting_radio@2x") forState:UIControlStateNormal];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.bounds.size.width - 36, 0, (16 - buttonSize.width))];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (button.bounds.size.width - 16 -  buttonSize.width))];
            }
            else {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (button.bounds.size.width - 32 -  buttonSize.width))];
            }
            
            [button addTarget:self action:@selector(handleActionSheetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
            y += button.bounds.size.height;
            
            if (i != [self.titles count] - 1) {
                UIView *kk = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
                kk.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
                [self addSubview:kk];
                y += 1;
            }
        }
        
        //取消按钮
        UIView *mm = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 5)];
        mm.backgroundColor = KT_HEXCOLOR(0xececec);
        [self addSubview:mm];
        
        y += 5;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = 0;
        cancelButton.frame = CGRectMake(0.0f, y, self.bounds.size.width, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [cancelButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        CGSize cancelButtonSize = KT_TEXTSIZE_SIMPLE(cancelButton.titleLabel.text, cancelButton.titleLabel.font);
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (cancelButton.bounds.size.width - 32 - cancelButtonSize.width))];
        [cancelButton addTarget:self action:@selector(handleActionSheetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        y += cancelButton.frame.size.height;
    }
    else if (self.actionSheetType == KGBActionSheetTypeLogin){
        //请先登录
        CGFloat x = 16;
        y = 14;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 15)];
        titleLabel.font = GB_DEFAULT_FONT(15);
        titleLabel.textColor = KT_HEXCOLOR(0x666666);
        titleLabel.text = @"请先登录";
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.tag = 2;
        registerButton.frame = CGRectMake(self.bounds.size.width - 62, 2, 62, 43);
        registerButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [registerButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self addSubview:registerButton];
        [registerButton addTarget:self action:@selector(showRegisterPage:) forControlEvents:UIControlEventTouchUpInside];
        
        y += (titleLabel.bounds.size.height + 14);
        
        //线1
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView];
        y += 1;
        
        y += 14;
        
        //账号
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 60, 15)];
        accountLabel.font = GB_DEFAULT_FONT(15);
        accountLabel.textColor = KT_HEXCOLOR(0x333333);
        accountLabel.text = @"账号";
        accountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:accountLabel];
        
        x += accountLabel.bounds.size.width;
        
        UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, (self.bounds.size.width - x - 16), 20)];
        accountTextField.borderStyle = UITextBorderStyleNone;
        accountTextField.tag = 1;
        accountTextField.delegate = self;
        accountTextField.placeholder = @"请输入账号";
        [self addSubview:accountTextField];
        self.accountTextField = accountTextField;
        [accountTextField becomeFirstResponder];
        
        y += (accountLabel.bounds.size.height + 14);
        
        //线2
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView2.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView2];
        y += 1;
        
        y += 14;
        x = 16;
        //密码
        UILabel *passworldLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 60, 15)];
        passworldLabel.font = GB_DEFAULT_FONT(15);
        passworldLabel.textColor = KT_HEXCOLOR(0x333333);
        passworldLabel.text = @"密码";
        passworldLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:passworldLabel];
        
        x += passworldLabel.bounds.size.width;
        
        UITextField *passworldTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, (self.bounds.size.width - x - 16), 20)];
        passworldTextField.borderStyle = UITextBorderStyleNone;
        passworldLabel.tag = 2;
        passworldTextField.delegate = self;
        passworldTextField.placeholder = @"请输入密码";
        [self addSubview:passworldTextField];
        self.passworldTextField = passworldTextField;
        
        y += (passworldLabel.bounds.size.height + 14);
        
        //线3
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView3.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView3];
        y += 1;
        
        y += 14;
        x = 15;
        
        UIImage *cancelImage = KT_GET_LOCAL_PICTURE(@"hp_gift_copy@2x");
        UIImage *loginImage = KT_GET_LOCAL_PICTURE(@"hp_gift_receive@2x");
        if ([cancelImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            cancelImage = [cancelImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
            loginImage = [loginImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
        }
        else{
            cancelImage = [cancelImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            loginImage = [loginImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        }
        //登录＋注册
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = 0;
        cancelButton.frame = CGRectMake(x, y, (self.bounds.size.width - 40)/2, 36);
        cancelButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [cancelButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(handleLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        x += (cancelButton.bounds.size.width + 10);
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.tag = 1;
        loginButton.frame = CGRectMake(x, y, (self.bounds.size.width - 40)/2, 36);
        loginButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [loginButton setTitleColor:KT_HEXCOLOR(0x44b5ff) forState:UIControlStateNormal];
        [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(handleLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        y += cancelButton.frame.size.height + 14;
    }
    else if (self.actionSheetType == KGBActionSheetTypeRegister){
        //请先注册
        CGFloat x = 16;
        y = 14;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 15)];
        titleLabel.font = GB_DEFAULT_FONT(15);
        titleLabel.textColor = KT_HEXCOLOR(0x666666);
        titleLabel.text = @"请先注册";
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        UIButton *showloginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showloginButton.tag = 2;
        showloginButton.frame = CGRectMake(self.bounds.size.width - 62, 2, 62, 43);
        showloginButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [showloginButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        [showloginButton setTitle:@"登录" forState:UIControlStateNormal];
        [showloginButton addTarget:self action:@selector(showLoginPage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showloginButton];
        
        
        y += (titleLabel.bounds.size.height + 14);
        
        //线1
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView1.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView1];
        y += 1;
        
        y += 14;
        
        //账号
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 88, 15)];
        accountLabel.font = GB_DEFAULT_FONT(15);
        accountLabel.textColor = KT_HEXCOLOR(0x333333);
        accountLabel.text = @"账       号";
        accountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:accountLabel];
        
        x += accountLabel.bounds.size.width;
        
        UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, (self.bounds.size.width - x - 16), 20)];
        accountTextField.borderStyle = UITextBorderStyleNone;
        accountTextField.delegate = self;
        accountTextField.tag = 11;
        accountTextField.placeholder = @"个字符，可使用字母、数字、中文、下划线或减号";
        [self addSubview:accountTextField];
        self.accountTextField = accountTextField;
        [accountTextField becomeFirstResponder];
        
        y += (accountLabel.bounds.size.height + 14);
        
        //线2
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView2.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView2];
        y += 1;
        
        y += 14;
        x = 16;
        //密码
        UILabel *passworldLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 88, 15)];
        passworldLabel.font = GB_DEFAULT_FONT(15);
        passworldLabel.textColor = KT_HEXCOLOR(0x333333);
        passworldLabel.text = @"输入密码";
        passworldLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:passworldLabel];
        
        x += passworldLabel.bounds.size.width;
        
        UITextField *passworldTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, (self.bounds.size.width - x - 16), 20)];
        passworldTextField.borderStyle = UITextBorderStyleNone;
        passworldLabel.tag = 12;
        passworldTextField.delegate = self;
        passworldTextField.placeholder = @"请输入密码";
        [self addSubview:passworldTextField];
        self.passworldTextField = passworldTextField;
        
        y += (passworldLabel.bounds.size.height + 14);
        
        //线3
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView3.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView3];
        y += 1;
        
        y += 14;
        x = 16;
        
        //确认密码
        UILabel *confirmPassworldLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 88, 15)];
        confirmPassworldLabel.font = GB_DEFAULT_FONT(15);
        confirmPassworldLabel.textColor = KT_HEXCOLOR(0x333333);
        confirmPassworldLabel.text = @"确认密码";
        confirmPassworldLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:confirmPassworldLabel];
        
        x += confirmPassworldLabel.bounds.size.width;
        
        UITextField *confirmPassworldTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, (self.bounds.size.width - x - 16), 20)];
        confirmPassworldTextField.borderStyle = UITextBorderStyleNone;
        confirmPassworldTextField.delegate = self;
        confirmPassworldLabel.tag = 13;
        confirmPassworldTextField.placeholder = @"请确认密码";
        [self addSubview:confirmPassworldTextField];
        self.confirmPassworldTextField = confirmPassworldTextField;
        
        y += (confirmPassworldLabel.bounds.size.height + 14);
        
        //线4
        UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
        lineView4.backgroundColor = KT_HEXCOLOR(0xdfdfdf);
        [self addSubview:lineView4];
        y += 1;
        
        y += 14;
        x = 15;
        
        UIImage *cancelImage = KT_GET_LOCAL_PICTURE(@"hp_gift_copy@2x");
        UIImage *loginImage = KT_GET_LOCAL_PICTURE(@"hp_gift_receive@2x");
        if ([cancelImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            cancelImage = [cancelImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
            loginImage = [loginImage resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
        }
        else{
            cancelImage = [cancelImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            loginImage = [loginImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        }
        //取消＋注册
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.tag = 0;
        cancelButton.frame = CGRectMake(x, y, (self.bounds.size.width - 40)/2, 36);
        cancelButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [cancelButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(handleLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        x += (cancelButton.bounds.size.width + 10);
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.tag = 2;
        registerButton.frame = CGRectMake(x, y, (self.bounds.size.width - 40)/2, 36);
        registerButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [registerButton setTitleColor:KT_HEXCOLOR(0x44b5ff) forState:UIControlStateNormal];
        [registerButton setBackgroundImage:loginImage forState:UIControlStateNormal];
        [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(handleLoginAndRegister:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
        
        y += cancelButton.frame.size.height + 14;
    }
    
    self.height = y;
}

- (void)handleMaskViewTapGesture:(UIPanGestureRecognizer *)gesture
{
    [self.maskView removeGestureRecognizer:gesture];

    [self close];
}

- (void)showLoginPage:(id)sender
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    self.actionSheetType = KGBActionSheetTypeLogin;
    self.enableAnamation = NO;
    [self setup];
    self.enableAnamation = YES;
}

- (void)showRegisterPage:(id)sender
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    self.actionSheetType = KGBActionSheetTypeRegister;
    self.enableAnamation = NO;
    [self setup];
    self.enableAnamation = YES;
}

//actionsheetButtonClick
- (void)didLoginAction:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    if (self.block) {
        self.block(button.tag);
    }
    [self close];
}

//actionsheetButtonClick
- (void)handleActionSheetButtonClick:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    if (self.block) {
        self.block(button.tag);
    }
    [self close];
}

- (void)handleLoginAndRegister:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:{ //取消
            [self close];
            break;
        }
        case 1:{ //登录
            self.block(button.tag);
            break;
        }
        case 2:{ //注册
            
            
            [self logoInConfirm];
            /*
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            self.block(button.tag);
            self.foundKeyboard.hidden = YES;
            self.maskView.hidden = YES;
            self.hidden = YES;
            [self.accountTextField resignFirstResponder];
            [self.passworldTextField resignFirstResponder];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                self.foundKeyboard.hidden = NO;
                [self.maskView removeFromSuperview];
                [self removeFromSuperview];
                
            });
            */
            break;
        }
            
        default:
            break;
    }
}

//显示
- (void)show
{
    GBAppDelegate *appDelegate = (GBAppDelegate *)[UIApplication sharedApplication].delegate;

    //生成蒙板
    UIView *maskViewTMP = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskViewTMP.backgroundColor = KT_HEXCOLOR(0x000000);
    maskViewTMP.alpha = 0.0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskViewTapGesture:)];
    [maskViewTMP addGestureRecognizer:tapGesture];
    
    [appDelegate.window addSubview:maskViewTMP];
    
    self.maskView = maskViewTMP;
    
    //显示蒙板
    [UIView animateWithDuration:BG_MASKVIEW_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.maskView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    //显示ActionSheet
    [appDelegate.window addSubview:self];
    
    [UIView animateWithDuration:BG_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0,-self.bounds.size.height);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}
//关闭
- (void)close
{
    [self.accountTextField resignFirstResponder];
    [self.passworldTextField resignFirstResponder];
    [self.confirmPassworldTextField resignFirstResponder];
    //关闭蒙板
    [UIView animateWithDuration:BG_MASKVIEW_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.maskView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         self.maskView = nil;
                     }];
    
    //关闭ActionSheet
    [UIView animateWithDuration:BG_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (self.handleWithColoseDidAnimation) {
                             self.handleWithColoseDidAnimation();
                         }
                         [[NSNotificationCenter defaultCenter] removeObserver:self];
                     }];
}


/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Handle Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    CGRect rect = self.frame;
    if (self.actionSheetType == KGBActionSheetTypeLogin) {
        rect.size.height = height + 200;
    }
    else if (self.actionSheetType == KGBActionSheetTypeRegister){
        rect.size.height = height + 240;
    }
    
    if (self.frame.origin.y < self.frame.size.height) {
        rect.origin.y = [Utils screenHeight] - rect.size.height;
    }
    
    KT_DLog(@"rect.fframe = %@",NSStringFromCGRect(rect));
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:self.enableAnamation?animationDuration:0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frame = rect;
                         
                     } completion:^(BOOL finished) {
                         
                     }];

}

- (void)keyboardDidShow:(NSNotification *)notification {
    //////////////////////////////////////////////////////////////////
    if (self.accountTextField.isFirstResponder || self.passworldTextField.isFirstResponder) {
        
        UIWindow *keyboardWindow = nil;
        for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
        {
            if (![[testWindow class] isEqual:[UIWindow class]])
            {
                keyboardWindow = testWindow;
                break;
            }
        }
        if (!keyboardWindow)
            return ;
        
        for (__strong UIView *possibleKeyboard in [keyboardWindow subviews])
        {
            //iOS3
            if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"])
            {
                _foundKeyboard = possibleKeyboard;
                break;
            }
            else
            {
                // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
                if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"])
                {
//                    possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
                    _foundKeyboard = possibleKeyboard;
                }
                
//                if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"])
//                {
//                    _foundKeyboard = possibleKeyboard;
//                    break;
//                }
            }
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0.f;
    if (self.accountTextField.isFirstResponder || self.passworldTextField.isFirstResponder) {
        
    }
}


#pragma mark - UITextField Delegate 
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self.passworldTextField becomeFirstResponder];
        [textField resignFirstResponder];
    }else if (textField.tag == 2){
        //密码的换行按钮
        
    }else if (textField.tag == 11){
        [self.passworldTextField becomeFirstResponder];
        [textField resignFirstResponder];
    }else if (textField.tag == 12){
        [self.confirmPassworldTextField becomeFirstResponder];
         [textField resignFirstResponder];
    }else if (textField.tag == 13){
        
    }
    return YES;
}

- (void)logoInConfirm
{
  
}
@end
