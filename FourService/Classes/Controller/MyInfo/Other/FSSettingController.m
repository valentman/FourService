//
//  FSSettingController.m
//  FourService
//
//  Created by Joe.Pen on 7/14/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSSettingController.h"
#import "CZJGeneralCell.h"
#import "FSBaseDataManager.h"

@interface FSSettingController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* settingAry;
    UIProgressView* processView;
}
//创建TableView，注册Cell
@property (strong, nonatomic)UITableView* myTableView;

@property (strong, nonatomic) UIButton *exitBtn;
- (void)exitLoginAction:(id)sender;
@end

@implementation FSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"设置";
}

- (void)initDatas
{
    
}

- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    settingAry = @[@"推送消息",
                   //                   @"引导页",
                   @"清除本地缓存",
                   //                   @"检测新版本",
                   @"关于"
                   ];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, 150) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = NO;
    self.myTableView.backgroundColor = WHITECOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"CZJGeneralCell"];
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    
    [self.myTableView reloadData];
    
    
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.exitBtn setBackgroundColor:CZJREDCOLOR];
    self.exitBtn.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH-100, 50);
    self.exitBtn.center = self.view.center;
    [self.exitBtn addTarget:self action:@selector(exitLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitBtn];
//    self.exitBtn.hidden = ![USER_DEFAULT boolForKey:kCZJIsUserHaveLogined];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
    cell.nameLabel.textColor = [UIColor blackColor];
    cell.nameLabel.font = SYSTEMFONT(16);
    cell.nameLabel.text = settingAry[indexPath.row];
    NSString* versionStr = settingAry[indexPath.row];
    CGSize size = [PUtils calculateTitleSizeWithString:versionStr AndFontSize:16];
    cell.nameLabelWidth.constant = size.width + 10;
    if (0 == indexPath.row)
    {
        cell.arrowImg.hidden = YES;
//        cell.chooseButton.hidden = NO;
//        [cell.chooseButton addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    if (2 == indexPath.row)
    //    {
    //        cell.arrowImg.hidden = YES;
    //        cell.myDetailLabel.hidden = NO;
    //        cell.myDetailLabel.text = [NSString stringWithFormat:@"V%@",[self getCurrentVersion]];
    //    }
    if (1 == indexPath.row)
    {
        cell.arrowImg.hidden = YES;
        cell.detailLabel.hidden = NO;
        __block float size;
        BACK(^{
            size = [PUtils folderSizeAtPath:CachesDirectory];
            MAIN((^{
                cell.detailLabel.text = [NSString stringWithFormat:@"%.2fM",size];
            }));
        });
        
    }
    if (2 == indexPath.row)
    {
        cell.separatorInset = HiddenCellSeparator;
    }
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.row)
    {
        [self performSegueWithIdentifier:@"segueToAboutUs" sender:self];
    }
    if (1 == indexPath.row)
    {
        __weak typeof(self) weak = self;
        [self showFSAlertView:@"确定清除本地缓存" andConfirmHandler:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [PUtils clearCache:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [weak.myTableView reloadData];
            }];
            [weak hideWindow];
        } andCancleHandler:nil];
    }
}


- (void)exitLoginAction:(id)sender
{
    
    __weak typeof(self) weak = self;
    [self showFSAlertView:@"确定退出" andConfirmHandler:^{
        //清除所有数据
        //省份信息
        [FileManager removeItemAtPath:[DocumentsDirectory stringByAppendingPathComponent:kCZJPlistFileProvinceCitys] error:nil];
        //搜索历史
        [FileManager removeItemAtPath:[DocumentsDirectory stringByAppendingPathComponent:kCZJPlistFileSearchHistory] error:nil];
        //默认收货地址
        [FileManager removeItemAtPath:[DocumentsDirectory stringByAppendingPathComponent:kCZJPlistFileDefaultDeliveryAddr] error:nil];
        
        //车主信息
        [FileManager removeItemAtPath:[DocumentsDirectory stringByAppendingPathComponent:kCZJPlistFileUserBaseForm] error:nil];
        
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultTimeDay];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultTimeMin];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultRandomCode];
        
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedCarModelType];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedCarModelID];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedBrandID];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPrice];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultEndPrice];
        [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultStockFlag];
        [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultPromotionFlag];
        [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultRecommendFlag];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultServicePlace];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultDetailStoreItemPid];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultDetailItemCode];
        
        [USER_DEFAULT setObject:@"" forKey:kUSerDefaultSexual];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageUrl];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageImagePath];
        [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageForm];
        [USER_DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:kCZJIsUserHaveLogined];
        [USER_DEFAULT setObject:@"0" forKey:kUserDefaultShoppingCartCount];
        [USER_DEFAULT setObject:@"" forKey:kCZJDefaultCityID];
        [USER_DEFAULT setObject:@"" forKey:kCZJDefaultyCityName];
        [USER_DEFAULT synchronize];
        
        FSBaseDataInstance.userInfoForm = nil;
//        CZJLoginModelInstance.usrBaseForm = nil;
        [FSBaseDataInstance refreshChezhuID];
        
        
        [weak.navigationController popViewControllerAnimated:YES];
        [PUtils tipWithText:@"退出成功" andView:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiLoginOut object:nil];
        [weak hideWindow];
    } andCancleHandler:nil];
    
}


@end
