//
//  GBUpdatePasswordViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBUpdatePasswordViewController.h"
#import "GBPopUpBox.h"
#import "PXAlertView.h"
#include <TeironSDK/hash&encrypt/TRSha256.h>

@interface GBUpdatePasswordViewController ()

@property (nonatomic, KT_WEAK) UITextField *oldTextField;
@property (nonatomic, KT_WEAK) UITextField *curTextField;
@property (nonatomic, KT_WEAK) UITextField *sureTextField;
@property (nonatomic, KT_WEAK) UITableView *tableView;
@property (nonatomic, KT_WEAK) GBPopUpBox *popupBox;

@end

@implementation GBUpdatePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"修改密码"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.tableHeaderView = headerView;
    tableViewTMP.tableFooterView = footerView;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.oldTextField becomeFirstResponder];
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
    
    [self.customNavigationBar setNavBarButtonWithTitle:@"保存"
                                            buttonType:KTNavigationBarButtonTypeOfRight
                                                target:self
                                                action:@selector(didSaveAction:)];
}

- (void)didCancelAction:(id)sender
{
    [self.oldTextField resignFirstResponder];
    [self.curTextField resignFirstResponder];
    [self.sureTextField resignFirstResponder];
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)didSaveAction:(id)sender
{
    [self.oldTextField resignFirstResponder];
    [self.curTextField resignFirstResponder];
    [self.sureTextField resignFirstResponder];
    
//    if ([self.oldTextField.text isEqualToString:@""]) {
//        GBAlertView *alertView = [[GBAlertView alloc] initWithMessage:@"原始密码不正确"
//                                                  buttonTitles:[NSArray arrayWithObject:@"确定"]
//                                                      callback:^(int index){
//                                                          
//                                                      }];
//        [alertView show];
//        return;
//    }
    if ([Utils isNilOrEmpty:self.curTextField.text] ||
        [Utils isNilOrEmpty:self.sureTextField.text] ||
        [self.curTextField.text rangeOfString:@" "].location != NSNotFound ||
        [self.sureTextField.text rangeOfString:@" "].location != NSNotFound) {
        [PXAlertView showAlertWithTitle:@"提示"
                                message:@"密码不能为空或使用空白字符"
                            cancelTitle:nil
                             otherTitle:@"确定"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 
                             }];

        return;
    }
    
    if ([self.curTextField.text length] < 6 || [self.sureTextField.text length] < 6) {
        [PXAlertView showAlertWithTitle:@"提示"
                                message:@"密码不能小于6个字符"
                            cancelTitle:nil
                             otherTitle:@"确定"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 
                             }];
        return;
    }
    
    if (![self.curTextField.text isEqualToString:self.sureTextField.text]) {
        [PXAlertView showAlertWithTitle:@"提示"
                                message:@"两次输入的密码不一致"
                            cancelTitle:nil
                             otherTitle:@"确定"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 
                             }];
        return;
    }
    
    GBPopUpBox *popBox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress withAutoHidden:NO];
    [popBox show];
    self.popupBox = popBox;
    
    const char *saltData = [self.oldTextField.text cStringUsingEncoding:NSUTF8StringEncoding];
    const char *paramData = [self.curTextField.text cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char hash1[64];
    unsigned char hash2[64];
    
    sha256_memory(saltData,strlen(saltData),hash1);
    sha256_memory(paramData,strlen(paramData),hash2);

    
    [[TRUserRequest defaultTRUserRequest] requestModifyPassword:[TRUser sharedInstance].userName
                                                    oldPassword:[[NSData alloc] initWithBytes:hash1 length:sizeof(hash1)]
                                                    newPassword:[[NSData alloc] initWithBytes:hash2 length:sizeof(hash2)]
                                                       userInfo:nil
                                                       delegate:self];
}

#pragma mark - TRUserRequestDelegate
- (void)didFailRequestUserConnection:(TRUserRequest*)tRUserRequest
                           errorCode:(TRHTTPConnectionError)errorCode
                            userInfo:(NSMutableDictionary*)userInfo
{
    [self.popupBox hiddenWithAnimated:NO];
    GBPopUpBox *popBox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
    [popBox showInView:self.view offset:0];
    
}

- (void)didFailRequestUser:(TRUserRequest*)tRUserRequest
                 errorCode:(SDKUserErrorCode)errorCode
                  userInfo:(NSMutableDictionary*)userInfo
{
    [self.popupBox hiddenWithAnimated:NO];
    [PXAlertView showAlertWithTitle:@"提示"
                            message:@"密码修改失败!"
                        cancelTitle:nil
                         otherTitle:@"确定"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             
                         }];
}

- (void)didSuccessRequestModifyPassword:(TRUserRequest*)tRUserRequest
                               userInfo:(NSMutableDictionary*)userInfo
{
    [self.popupBox hiddenWithAnimated:YES];
    //DOTO 保存密码
    [self didCancelAction:nil];
}

#pragma mark - UITableDataSource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UpdatePasswordCellIdenfifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *subView  in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    switch (indexPath.row) {
        case 0:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 88, 43)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(15);
            titleLabel.textColor = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"当前密码";
            [cell.contentView addSubview:titleLabel];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 11, 200, 20)];
            textField.secureTextEntry = YES;
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = @"请输入当前密码";
            textField.font = GB_DEFAULT_FONT(15);
            [cell.contentView addSubview:textField];
            self.oldTextField = textField;
            break;
        }
        case 1:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 88, 43)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(15);
            titleLabel.textColor = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"新  密  码";
            [cell.contentView addSubview:titleLabel];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 11, 200, 20)];
            textField.delegate = self;
            textField.secureTextEntry = YES;
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = @"请输入新密码";
            textField.font = GB_DEFAULT_FONT(15);
            [cell.contentView addSubview:textField];
            self.curTextField = textField;
            break;
        }
        case 2:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 88, 43)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(15);
            titleLabel.textColor = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"确认密码";
            [cell.contentView addSubview:titleLabel];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, 11, 200, 20)];
            textField.delegate = self;
            textField.secureTextEntry = YES;
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = @"请确认新密码";
            textField.font = GB_DEFAULT_FONT(15);
            [cell.contentView addSubview:textField];
            self.sureTextField = textField;
            break;
        }
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (range.location >= 20)
    {
        return NO;
    }
    return YES;
}

@end
