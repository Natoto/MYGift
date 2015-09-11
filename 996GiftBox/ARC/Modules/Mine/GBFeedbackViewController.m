//
//  GBFeedbackViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBFeedbackViewController.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "NSString+GBAdditions.h"
#import "GBPopUpBox.h"
#import "PXAlertView.h"

@interface GBFeedbackViewController ()

@property (nonatomic, KT_WEAK)UILabel *placeholderLabel;
@property (nonatomic, KT_WEAK)UITextView *textView;
@property (nonatomic, KT_WEAK)UITextField *textField;
@property (nonatomic, KT_STRONG) GBFeedbackRequest *request;

@end

@implementation GBFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.request cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"意见反馈"];
    
//    self.customNavigationView.frame = CGRectMake(0.0f, KT_UI_NAVIGATION_BAR_HEIGHT, KT_UI_SCREEN_WIDTH, [Utils screenHeight] - KT_UI_NAVIGATION_BAR_HEIGHT - KT_UI_STATUS_BAR_HEIGHT);
    
    CGFloat x = 10, y = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT + 10;
    
    UIView *textBgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, (self.view.bounds.size.width - 20), 110)];
    textBgView.backgroundColor = KT_UICOLOR_CLEAR;
    textBgView.layer.borderWidth = 1;
    textBgView.layer.borderColor = KT_HEXCOLOR(0xc9c8c8).CGColor;
    textBgView.layer.masksToBounds = YES;
    textBgView.layer.cornerRadius = 5.f;
    [self addSubview:textBgView];
    
    //textView
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(x+5, y+1, (textBgView.bounds.size.width - 10), 108)];
    detailTextView.backgroundColor = KT_HEXCOLOR(0xffffff);
    detailTextView.delegate = self;
    detailTextView.font = [UIFont systemFontOfSize:12];
    detailTextView.textColor = KT_HEXCOLOR(0x999999);
    [self addSubview:detailTextView];
    self.textView = detailTextView;
    [detailTextView becomeFirstResponder];
    
    //textView placeholder
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+10, y+5, detailTextView.bounds.size.width - 20, 30)];
    placeholderLabel.font = GB_DEFAULT_FONT(12);
    placeholderLabel.textColor = KT_HEXCOLOR(0x999999);
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.text = @"我们的每一步成长，都少不了有您的一份支持，谢谢您的反馈";
    [self addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;

    y += (detailTextView.bounds.size.height + 19);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.view.bounds.size.width - 2*x, 40)];
    bgView.backgroundColor = KT_HEXCOLOR(0xffffff);
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = KT_HEXCOLOR(0xc9c8c8).CGColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.f;
    [self addSubview:bgView];
    
    //email or qq
//    UILabel *acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 140, 40)];
//    acountLabel.backgroundColor = KT_UICOLOR_CLEAR;
//    acountLabel.font = GB_DEFAULT_FONT(12);
//    acountLabel.textColor = KT_HEXCOLOR(0x999999);
//    acountLabel.text = @"电子邮箱或QQ号（选填）";
//    [bgView addSubview:acountLabel];
    
//    x += (acountLabel.bounds.size.width);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(bgView.frame.origin.x, 7, bgView.frame.size.width - 5, 29)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = KT_HEXCOLOR(0x999999);
    textField.font = GB_DEFAULT_FONT(12);
    textField.placeholder = @"电子邮箱或QQ号（选填）";
    [bgView addSubview:textField];
    self.textField = textField;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCustomNavigationBarButton
{
    KT_DLog(@"设置上导航Button");
    [self.customNavigationBar setNavBarButtonWithTitle:@"取消"
                                            buttonType:KTNavigationBarButtonTypeOfLeft
                                                target:self
                                                action:@selector(didCancelAction:)];
    
    [self.customNavigationBar setNavBarButtonWithTitle:@"发送"
                                            buttonType:KTNavigationBarButtonTypeOfRight
                                                target:self
                                                action:@selector(didSendAction:)];
}

- (void)didCancelAction:(id)sender
{
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)didSendAction:(id)sender
{
    if ([Utils isNilOrEmpty:[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
        
        [PXAlertView showAlertWithTitle:@"提示"
                                message:@"反馈内容不能为空"
                            cancelTitle:nil
                             otherTitle:@"确定"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 
                             }];
        return;
    }
    
//    if (![self.textView.text isEmail] || ) {
//        
//    }
    
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    
    GBPopUpBox *popView = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress withAutoHidden:NO];
    [popView show];
    
    [self.request cancel];
    self.request = [[GBFeedbackRequest alloc] init];
    self.request.message = self.textView.text;
    self.request.contact = self.textField.text;
    self.request.responseDataType = KResponseDataTypeJSON;
    
    __weak typeof(self) vc = self;
    [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
        [popView hiddenWithAnimated:NO];
        if (response.isError) { //出错
            [PXAlertView showAlertWithTitle:@"提示"
                                    message:response.errorMessage
                                cancelTitle:nil
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     [vc.textView becomeFirstResponder];
                                 }];
        }else{
            [PXAlertView showAlertWithTitle:@"提示"
                                    message:@"已收录，感谢你的反馈。"
                                cancelTitle:nil
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     [vc didCancelAction:nil];
                                 }];
        }
    }];
    [self.request sendAsynchronous];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"我们的每一步成长，都少不了有您的一份支持，谢谢您的反馈";
    }else{
        self.placeholderLabel.text = @"";
    }
}

- (void)pringtSubView:(UIView *)preView{
    for (UIView *subView in [preView subviews]) {
        [self pringtSubView:subView];
    }
}

@end
