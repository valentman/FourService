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
NSString* const kMyOpinionVc = @"opinionSBID";



@interface FSMyInformationController ()
<
UITableViewDataSource,
UITableViewDelegate,
CZJMyInfoHeadCellDelegate,
CZJGeneralSubCellDelegate
>
{
    NSArray* personalCellAry;               //个人信息下子项数组
    NSArray* otherCellAry;              //我的钱包下子项数组
    NSArray* orderSubCellAry;               //订单子项数组
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
    [self initViews];
    
    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined]) {
        [self getMyInfoDataFromServer];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyInfoDataFromServer) name:kCZJNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kCZJNotifiLoginOut object:nil];
}

- (void)reloadTableView
{
    [self.myTableView reloadData];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    //要将NaviBar设为隐藏是因为navibar会吃掉点击事件，导致右上角浏览记录按钮获取不到点击事件
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setTintColor:RGB(235, 20, 20)];
    _currentTouchOrderListType = 0;
}

- (void)viewDidLayoutSubviews
{
    self.myTableView.frame = CGRectMake(0, 0, self.view.size.width, PJ_SCREEN_HEIGHT);
}

- (void)initDatas
{
    carListAry  = [NSArray array];
    
    otherCellAry = [NSArray array];
    NSMutableDictionary* pDict0 = [@{@"title":@"足迹",
                                     @"buttonImage":@"myInfo_viewed",
                                     @"segueTo":kMyViewedVc}mutableCopy];
    NSMutableDictionary* pDict1 = [@{@"title":@"反馈咨询",
                                     @"buttonImage":@"myInfo_fankui",
                                     @"segueTo":kMyOpinionVc}mutableCopy];
    NSMutableDictionary* pDict2 = [@{@"title":@"设置",
                                     @"buttonImage":@"myInfo_setting",
                                     @"segueTo":kMySettingVc}mutableCopy];
    otherCellAry = @[pDict0, pDict1, pDict2];
    
    personalCellAry = [NSArray array];
    NSMutableDictionary* dict1 = [@{@"title":@"优惠券",
                                    @"buttonImage":@"myInfo_coupon",
                                    @"budge":@"0",
                                    @"item":@"discount_normal_num",
                                    @"segueTo":kMyCouponListVc} mutableCopy];
    NSMutableDictionary* dict2 = [@{@"title":@"收藏",
                                    @"buttonImage":@"myInfo_favorite",
                                    @"budge":@"0",
                                    @"item":@"Customer_favorite_num",
                                    @"segueTo":kMyFavoriteVc} mutableCopy];
    NSMutableDictionary* dict3 = [@{@"title":@"我的车辆",
                                    @"buttonImage":@"myInfo_car",
                                    @"budge":@"0",
                                    @"item":@"carList",
                                    @"segueTo":kMyCarListVc} mutableCopy];
    
    personalCellAry = @[dict1,dict2,dict3];
    
    orderSubCellAry = [NSArray array];
    NSMutableDictionary* pdict1 = [@{@"title":@"待支付",
                                    @"budge":@"0",
                                    @"item":@"order_payed_num",
                                    @"segueTo":kMyOrderListVc} mutableCopy];
    NSMutableDictionary* pdict2 = [@{@"title":@"服务中",
                                    @"budge":@"0",
                                    @"item":@"order_init_num",
                                    @"segueTo":kMyOrderListVc} mutableCopy];
    NSMutableDictionary* pdict3 = [@{@"title":@"待评论",
                                    @"budge":@"0",
                                    @"item":@"order_commented_num",
                                    @"segueTo":kMyOrderListVc} mutableCopy];
    
    orderSubCellAry = @[pdict1,pdict2,pdict3];
}


- (void)initViews
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, PJ_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.backgroundColor = CLEARCOLOR;
    [self.view addSubview:self.myTableView];
    NSArray* nibArys = @[@"CZJMyInfoHeadCell",
                         @"CZJGeneralCell",
                         @"CZJGeneralSubCell"
                         ];
    
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
            UserBaseForm* identiForm = FSBaseDataInstance.userInfoForm;
            myInfoForm.identifier = identiForm.identifier;
            myInfoForm.token = identiForm.token;
            FSBaseDataInstance.userInfoForm = myInfoForm;

            carListAry = [FSCarListForm objectArrayWithKeyValuesArray:[dict valueForKey:@"car_list"]];
            [weakSelf updateOrderData:dict];
            //更新表格
            [weakSelf.myTableView reloadData];
        } fail:^{}];
    }
}

- (void)updateOrderData:(NSDictionary*)dict
{
    for (NSMutableDictionary* orderDict in orderSubCellAry)
    {
        NSString* itemName = [orderDict valueForKey:@"item"];
        if (![itemName isEqualToString:@""])
        {
            NSString* count = [dict valueForKey:itemName];
            [orderDict setValue:count forKey:@"budge"];
        }
    }
    for (NSDictionary* walletDict in personalCellAry)
    {
        NSString* itemName = [walletDict valueForKey:@"item"];
        if ([itemName isEqualToString:@"carList"])
        {
            [walletDict setValue:@(carListAry.count) forKey:@"budge"];
            continue;
        }
        if (![itemName isEqualToString:@""])
        {
            NSString* count = [dict valueForKey:itemName];
            [walletDict setValue:count forKey:@"budge"];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return orderSubCellAry.count + 1;
            break;
        case 3:
            return otherCellAry.count;
        default:
            break;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CZJMyInfoHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyInfoHeadCell" forIndexPath:indexPath];
            cell.unLoginView.hidden = [USER_DEFAULT boolForKey:kCZJIsUserHaveLogined];
            cell.haveLoginView.hidden = ![USER_DEFAULT boolForKey:kCZJIsUserHaveLogined];
            
            if (FSBaseDataInstance.userInfoForm && [USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
            {
                [cell setUserPersonalInfo:myInfoForm andDefaultCar:defaultCar];
                cell.delegate = self;
            }
            cell.backgroundColor = CLEARCOLOR;
            cell.separatorInset = HiddenCellSeparator;
            return cell;
        }
            break;
        case 1:
        {
            CZJGeneralSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralSubCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.backgroundColor = CLEARCOLOR;
            [cell setGeneralSubCell:personalCellAry andType:kCZJGeneralSubCellTypeOrder];
            return cell;
        }
            
            break;
        case 2:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell"];
            cell.backgroundColor = CLEARCOLOR;
            if (0 == indexPath.row)
            {
                [cell.headImgView setImage:IMAGENAMED(@"myInfo_order")];
                cell.nameLabel.text = @"我的订单";
                cell.detailLabel.text = @"查看全部订单";
                cell.detailLabel.textColor = RGB(230, 230, 230);
                cell.detailLabel.alpha = 0.8;
                cell.detailLabel.font = SYSTEMFONT(14);
                cell.nameLabel.textColor = WHITECOLOR;
                cell.nameLabel.font = SYSTEMFONT(16);
            }
            else
            {
                cell.nameLabel.text = [orderSubCellAry[indexPath.row - 1] valueForKey:@"title"];
                cell.nameLabel.textColor = WHITECOLOR;
                if (!VIEWWITHTAG(cell, 99))
                {
                    UILabel* badgeLabel = [[UILabel alloc]init];
                    badgeLabel.layer.backgroundColor = CZJREDCOLOR.CGColor;
                    badgeLabel.layer.cornerRadius = 10;
                    badgeLabel.textColor = WHITECOLOR;
                    badgeLabel.layer.borderColor = WHITECOLOR.CGColor;
                    badgeLabel.layer.borderWidth = 1.5 ;
                    badgeLabel.textAlignment = NSTextAlignmentCenter;
                    [badgeLabel setTag:99];
                    [badgeLabel setSize:CGSizeMake(20, 20)];
                    [badgeLabel setPosition:CGPointMake(110, 23) atAnchorPoint:CGPointMiddle];
                    [cell addSubview:badgeLabel];
                    badgeLabel.font = SYSTEMFONT(14);
                }
                UILabel *badge = VIEWWITHTAG(cell, 99);
                badge.hidden = [orderSubCellAry[indexPath.row - 1][@"budge"] intValue] <= 0;
                [badge setText:orderSubCellAry[indexPath.row - 1][@"budge"]];
            }
            return cell;
        }
            break;
        case 3:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell"];
            cell.backgroundColor = CLEARCOLOR;
            cell.nameLabel.text = [otherCellAry[indexPath.row] valueForKey:@"title"];
            cell.nameLabel.textColor = WHITECOLOR;
            [cell.headImgView setImage:IMAGENAMED([otherCellAry[indexPath.row] valueForKey:@"buttonImage"])];
            cell.nameLabel.font = SYSTEMFONT(16);
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 220;
            break;
        case 1:
            return 90;
            break;
            
        default:
            return 46;
            break;
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
    NSInteger type;
    switch (indexPath.section)
    {
        case 0:
            //如果没有登录则进入登录页面
            if ([PUtils isLoginIn:self andNaviBar:nil])
            {
                sbIdentifer = kMyPersonalInfoVc;
            }
            break;
            
        case 1:
            break;
            
        case 2:
            if ([PUtils isLoginIn:self andNaviBar:nil])
            {
                sbIdentifer = kMyOrderListVc;
                type = indexPath.row;
            }
            break;
            
        case 3:
            sbIdentifer = [otherCellAry[indexPath.row]valueForKey:@"segueTo"];
            if (![sbIdentifer isEqualToString:kMySettingVc]) {
                if (![PUtils isLoginIn:self andNaviBar:nil]) {
                    return;
                }
            }
            break;
            
        default:
            break;
    }
    [self myInforShowNextViewController:sbIdentifer andType:type];
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

#pragma mark- CZJGeneralSubCellDelegate
- (void)clickSubCellButton:(UIButton*)button andType:(int)subType
{
    if ([PUtils isLoginIn:self andNaviBar:nil])
    {
        _currentTouchOrderListType = button.tag;
        NSDictionary* dict = personalCellAry[_currentTouchOrderListType - 1];
        [self myInforShowNextViewController:[dict valueForKey:@"segueTo"]];
    }
}

- (void)myInforShowNextViewController:(NSString*)sbIdentifer
{
    [self myInforShowNextViewController:sbIdentifer andType:0];
}


- (void)myInforShowNextViewController:(NSString*)sbIdentifer andType:(FSOrderListType)_orderType
{
    if (!sbIdentifer)
        return;
    UIViewController* nextVC = [PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:sbIdentifer];
    if ([sbIdentifer isEqualToString:kMyPersonalInfoVc])
    {
        ((FSMyPersonalInfoController*)nextVC).myinfor = myInfoForm;
    }
    if ([sbIdentifer isEqualToString:kMyCarListVc])
    {
        ((FSMyCarListController*)nextVC).carListAry = [carListAry mutableCopy];
    }
    if ([sbIdentifer isEqualToString:kMyOrderListVc])
    {
        ((FSMyOrderListController*)nextVC).orderType = _orderType;
    }
    [((YQSlideMenuController*)self.parentViewController) showViewController:nextVC sender:nil];
}
@end
