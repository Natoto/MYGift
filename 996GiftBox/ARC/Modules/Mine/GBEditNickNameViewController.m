//
//  GBEditNickNameViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBEditNickNameViewController.h"

@interface GBEditNickNameViewController ()

@property (nonatomic, KT_WEAK) UITextField *textField;
@property (nonatomic, KT_WEAK) UIButton *clearButton;
@property (nonatomic, KT_WEAK) UITableView *tableView;

@end

@implementation GBEditNickNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"编辑昵称"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.tableHeaderView = headerView;
    tableViewTMP.tableFooterView = footerView;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
    
    return;
    
    
    self.view.frame = CGRectMake(0.f, KT_UI_NAVIGATION_BAR_HEIGHT, KT_UI_SCREEN_WIDTH, [Utils screenHeight] - KT_UI_SCREEN_WIDTH - KT_UI_NAVIGATION_BAR_HEIGHT - KT_UI_STATUS_BAR_HEIGHT);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, 45)];
    bgView.backgroundColor = KT_HEXCOLOR(0xffffff);
    [self addSubview:bgView];
    
    CGFloat x = 15;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 35, 45)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(16);
    titleLabel.textColor = KT_HEXCOLOR(0x333333);
    titleLabel.text = @"昵称";
    [bgView addSubview:titleLabel];
    
    x += (titleLabel.bounds.size.width + 5);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, 12, 220, 20)];
    textField.borderStyle = UITextBorderStyleLine;
    textField.text = @"Emo";
    [textField becomeFirstResponder];
    [bgView addSubview:textField];
    self.textField = textField;
    
    x = KT_UI_SCREEN_WIDTH - 45;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(x, 0, 45, 45);
    [clearButton setImage:KT_GET_LOCAL_PICTURE(@"search_clear@2x") forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(didClearAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:clearButton];
    self.clearButton = clearButton;
    
    UILabel *tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, bgView.bounds.size.height + 17, KT_UI_SCREEN_WIDTH, 15)];
    tapLabel.backgroundColor = KT_UICOLOR_CLEAR;
    tapLabel.font = GB_DEFAULT_FONT(15);
    tapLabel.textColor = KT_HEXCOLOR(0xc7c7cd);
    tapLabel.text = @"6-16个字符，支持中英文、数字";
    [self addSubview:tapLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.textField resignFirstResponder];
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)didSaveAction:(id)sender
{
//    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(<[^<>]+>).*?(</[^<>]+>)"
//                                                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
//                                                                        error:nil];
}

- (void)didClearAction:(id)sender
{
    
}

#pragma mark - UITableViewDataSource And Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, 22)];
    bgView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UILabel *tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 17, KT_UI_SCREEN_WIDTH, 15)];
    tapLabel.backgroundColor = KT_UICOLOR_CLEAR;
    tapLabel.font = GB_DEFAULT_FONT(15);
    tapLabel.textColor = KT_HEXCOLOR(0xc7c7cd);
    tapLabel.text = @"6-16个字符，支持中英文、数字";
    [bgView addSubview:tapLabel];
    
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NNCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 35, 45)];
        titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
        titleLabel.font = GB_DEFAULT_FONT(16);
        titleLabel.textColor = KT_HEXCOLOR(0x333333);
        titleLabel.text = @"昵称";
        [cell.contentView addSubview:titleLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((titleLabel.frame.origin.x + titleLabel.bounds.size.width + 5), 12, 220, 20)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = KT_HEXCOLOR(0x999999);
        textField.font = GB_DEFAULT_FONT(16);
        textField.text = @"Emo";
        [textField becomeFirstResponder];
        [cell.contentView addSubview:textField];
        self.textField = textField;
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(KT_UI_SCREEN_WIDTH - 45, 0, 45, 45);
        [clearButton setImage:KT_GET_LOCAL_PICTURE(@"search_clear@2x") forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(didClearAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:clearButton];
        self.clearButton = clearButton;
    }
    return cell;
}

#pragma mark - NSNotification
- (void)textFieldDidChange:(NSNotification *)notification
{
    if (self.textField.text.length == 0) {
        self.clearButton.hidden = YES;
    }else{
        self.clearButton.hidden = NO;
    }
}

@end
