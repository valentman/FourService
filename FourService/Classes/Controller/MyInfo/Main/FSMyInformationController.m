//
//  FSMyInformationController.m
//  FourService
//
//  Created by Joe.Pen on 7/14/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyInformationController.h"
#import "CZJMyInfoHeadCell.h"
#import "CZJMyInfoShoppingCartCell.h"
#import "CZJGeneralCell.h"
#import "CZJGeneralSubCell.h"
#import "FSBaseDataManager.h"

#import "FSMyDiscountController.h"
#import "FSMyViewedController.h"
#import "FSMyCarListController.h"
#import "FSMyPersonalInfoController.h"
#import "FSMyOrderListController.h"
#import "FSMyEvalutionController.h"
#import "FSMyAttentionController.h"
#import "FSMyinfoButtomView.h"

#import "YQSlideMenuController.h"

NSString* const kMessageCenter = @"messageCenterSBID";
NSString* const kMyPersonalInfoVc = @"personalSBID";
NSString* const kMyOrderListVc = @"orderListSBID";
NSString* const kMyCarListVc = @"carListSBID";
NSString* const kMyViewedVc = @"viewedSBID";
NSString* const kMyFavoriteVc = @"favoriteSBID";
NSString* const kMyEvaluateListVc = @"evaluateSBID";
NSString* const kMyCouponListVc = @"couponSBID";
NSString* const kMySettingVc = @"settingSBID";



@interface FSMyInformationController ()
<
UITableViewDataSource,
UITableViewDelegate,
CZJMyInfoHeadCellDelegate
>
{
    NSArray* personalCellAry;               //个人信息下子项数组
    NSArray* walletSubCellAry;              //我的钱包下子项数组
    NSInteger _currentTouchOrderListType;
    
    UserBaseForm* myInfoForm;
    NSArray* carListAry;
    FSCarListForm* defaultCar;
    
}
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation FSMyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
}

- (void)dealWithInitNavigationBar
{
    /**
     *  注意：一旦你设置了navigationBar的- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics接口，那么上面的setBarTintColor接口就不能改变statusBar的背景色
     */
    //导航栏背景透明化
    id navigationBarAppearance = self.navigationController.navigationBar;
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"nav_bargound"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"nav_bargound"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self dealWithInitNavigationBar];
    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined]) {
        [self getMyInfoDataFromServer];
    }
    [self.myTableView reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    DLog();
}

- (void)viewDidAppear:(BOOL)animated
{
    //要将NaviBar设为隐藏是因为navibar会吃掉点击事件，导致右上角浏览记录按钮获取不到点击事件
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.tabBarController.tabBar setTintColor:RGB(235, 20, 20)];
    _currentTouchOrderListType = 0;
    DLog();
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)viewDidLayoutSubviews
{
    self.view.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH - 100, PJ_SCREEN_HEIGHT);
    [self initViews];
}

- (void)initDatas
{
    carListAry  = [NSArray array];
    personalCellAry = [NSArray array];
    NSMutableDictionary* pDict0 = [@{@"title":@"足迹",
                                     @"segueTo":kMyViewedVc}mutableCopy];
    NSMutableDictionary* pDict1 = [@{@"title":@"我的收藏",
                                     @"segueTo":kMyFavoriteVc}mutableCopy];
    NSMutableDictionary* pDict2 = [@{@"title":@"我的评价",
                                     @"segueTo":kMyEvaluateListVc}mutableCopy];
    NSMutableDictionary* pDict3 = [@{@"title":@"优惠券",
                                     @"segueTo":kMyCouponListVc}mutableCopy];
    NSMutableDictionary* pDict4 = [@{@"title":@"我的订单",
                                     @"segueTo":kMyOrderListVc}mutableCopy];
    NSMutableDictionary* pDict5 = [@{@"title":@"我的车辆",
                                     @"segueTo":kMyCarListVc}mutableCopy];
    personalCellAry = @[pDict4,pDict5,pDict0,pDict1,pDict2,pDict3];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTabBarDotLabel) name:kCZJNotifiRefreshMessageReadStatus object:nil];
}

- (void)refreshTabBarDotLabel
{
    [self.myTableView reloadData];
}


- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, PJ_SCREEN_HEIGHT - Tabbar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.backgroundColor = CZJNAVIBARBGCOLOR;
    [self.view addSubview:self.myTableView];
    NSArray* nibArys = @[@"CZJMyInfoHeadCell",
                         @"CZJGeneralCell"
                         ];
    
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    FSMyinfoButtomView* buttomView = [PUtils getXibViewByName:@"FSMyinfoButtomView"];
    buttomView.frame = CGRectMake(0, PJ_SCREEN_HEIGHT - 50, self.view.size.width, 50);
    [self.view addSubview:buttomView];
}

- (void)getMyInfoDataFromServer
{
    __weak typeof (self) weakSelf = self;
    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
    {
        [FSBaseDataInstance getUserInfo:nil Success:^(id json) {
            NSDictionary* dict = [json valueForKey:kResoponData];
            
            //服务器返回数据本地化，全部转化为模型数据存储在数组中
            myInfoForm = [UserBaseForm objectWithKeyValues:dict];
            carListAry = [FSCarListForm objectArrayWithKeyValuesArray:[dict valueForKey:@"car_list"]];
            
            //更新表格
            [weakSelf.myTableView reloadData];
        } fail:^{
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return personalCellAry.count;
            break;
        default:
            break;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJMyInfoHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyInfoHeadCell" forIndexPath:indexPath];
            cell.unLoginView.hidden = [USER_DEFAULT boolForKey:kCZJIsUserHaveLogined];
            cell.haveLoginView.hidden = ![USER_DEFAULT boolForKey:kCZJIsUserHaveLogined];
            if (FSBaseDataInstance.userInfoForm && [USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
            {
                [cell setUserPersonalInfo:myInfoForm andDefaultCar:defaultCar];
                cell.delegate = self;
            }
            cell.separatorInset = HiddenCellSeparator;
            cell.contentView.backgroundColor = CZJNAVIBARBGCOLOR;
            return cell;
        }
    }
    else if (1 == indexPath.section)
    {
        NSDictionary* dict = personalCellAry[indexPath.row];
        CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
        [cell.imageView setImage:nil];
        cell.nameLabelLeading.constant = 15;
        cell.nameLabel.text = [dict valueForKey:@"title"];
        cell.detailLabel.hidden = NO;
        return cell;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        return 200;
    }
    else
    {
        return 46;
    }
    return 0;
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
    NSString* sbIdentifer;
    if (0 == indexPath.section)
    {
        sbIdentifer = kMyPersonalInfoVc;
    }
    if (1 == indexPath.section)
    {
        sbIdentifer = [personalCellAry[indexPath.row]valueForKey:@"segueTo"];
    }
    
    UIViewController* nextVC = [PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:sbIdentifer];
    if ([sbIdentifer isEqualToString:kMyPersonalInfoVc])
    {
        ((FSMyPersonalInfoController*)nextVC).myinfor = myInfoForm;
    }
    if ([sbIdentifer isEqualToString:kMyCarListVc])
    {
        ((FSMyCarListController*)nextVC).carListAry = [carListAry mutableCopy];
    }
    [((YQSlideMenuController*)self.parentViewController) showViewController:nextVC sender:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉tableview中section的headerview粘性
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark- CZJMyInfoHeadCellDelegate
-(void)clickMyInfoHeadCell:(id)sender
{
    if (0 == ((UIButton*)sender).tag)
    {
        //消息中心
        UIViewController* nextVC = [PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:kMessageCenter];
        [((YQSlideMenuController*)self.parentViewController) showViewController:nextVC sender:nil];
    }
}
@end
