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

#import "YQSlideMenuController.h"



@interface FSMyInformationController ()
<
UITableViewDataSource,
UITableViewDelegate,
CZJGeneralSubCellDelegate,
CZJMyInfoHeadCellDelegate
>
{
    NSArray* personalCellAry;               //个人信息下子项数组
    NSArray* orderSubCellAry;               //订单cell下子项数组
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
    else
    {
        for (NSMutableDictionary* orderDict in orderSubCellAry)
        {
            [orderDict setValue:@"0" forKey:@"budge"];
        }
        for (NSDictionary* walletDict in walletSubCellAry)
        {
            [walletDict setValue:@"0" forKey:@"buttonTitle"];
        }
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
                             @"segueTo":@"segueToRecord",
                             @"budge":@"0",
                             @"item":@"Customer_view_num"}mutableCopy];
    NSMutableDictionary* pDict1 = [@{@"title":@"我的收藏",
                             @"segueTo":@"segueToMyAttention",
                             @"budge":@"0",
                             @"item":@"Customer_favorite_num"}mutableCopy];
    NSMutableDictionary* pDict2 = [@{@"title":@"我的评价",
                             @"segueTo":@"segueToMyEvaluation",
                             @"budge":@"0",
                             @"item":@"Customer_comment_num"}mutableCopy];
    NSMutableDictionary* pDict3 = [@{@"title":@"优惠券",
                             @"segueTo":@"segueToCoupon",
                             @"budge":@"0",
                             @"item":@"discount_normal_num"}mutableCopy];
    personalCellAry = @[pDict0,pDict1,pDict2,pDict3];
    
    orderSubCellAry  = [NSArray array];
    NSMutableDictionary* dict1 = [@{@"title":@"待付款",
                                    @"buttonImage":@"my_icon_pay",
                                    @"budge":@"0",
                                    @"item":@"order_payed_num"} mutableCopy];
    NSMutableDictionary* dict2 = [@{@"title":@"服务中",
                                    @"buttonImage":@"my_icon_shigong",
                                    @"budge":@"0",
                                    @"item":@"order_init_num"} mutableCopy];
    NSMutableDictionary* dict4 = [@{@"title":@"待评价",
                                    @"buttonImage":@"my_icon_recommend",
                                    @"budge":@"0",
                                    @"item":@"order_finish_num"} mutableCopy];
    NSMutableDictionary* dict5 = [@{@"title":@"已评价",
                                    @"buttonImage":@"my_icon_tuihuo",
                                    @"budge":@"0",
                                    @"item":@"order_commented_num"} mutableCopy];
    orderSubCellAry = @[dict1,dict2,dict4,dict5];

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
                         @"CZJMyInfoShoppingCartCell",
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
    
    UIView* buttomView = [PUtils getXibViewByName:@"FSMyinfoButtomView"];
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
            [weakSelf updateOrderData:dict];
            
            //更新表格
            [self.myTableView reloadData];
        } fail:^{
            
        }];
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
        if (![itemName isEqualToString:@""])
        {
            NSString* count = [dict valueForKey:itemName];
            [walletDict setValue:count forKey:@"budge"];
        }
    }
    for (FSCarListForm* carForm in carListAry)
    {
        if (carForm.is_default)
        {
            defaultCar = carForm;
            break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
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
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:nil];
            cell.nameLabelLeading.constant = 15;
            cell.nameLabel.text = @"我的订单";
            cell.detailLabel.hidden = NO;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:nil];
            cell.nameLabelLeading.constant = 15;
            cell.nameLabel.text = @"我的车辆";
            cell.detailLabel.hidden = NO;
            return cell;
        }
    }
    else if (2 == indexPath.section)
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
    NSString* segueIdentifer;
    
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
//            segueIdentifer = @"segueToPersonalInfo";
            FSMyPersonalInfoController* myPersonal = (FSMyPersonalInfoController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"4SMyInfo"];
//            myPersonal.myinfor = myInfoForm;
            UIViewController* pVC = self.parentViewController;
            UINavigationController* naV = pVC.navigationController;
            [naV pushViewController:myPersonal animated:YES];
        }
    }
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            _currentTouchOrderListType = 0;
            segueIdentifer = @"segueToMyOrderList";
        }
        if (1 == indexPath.row)
        {
            segueIdentifer = @"segueToMyCarList";
        }
    }
    if (indexPath.section == 2)
    {
        NSDictionary* dict = personalCellAry[indexPath.row];
        segueIdentifer = [dict valueForKey:@"segueTo"];
    }
    if (segueIdentifer)
    {
        [self performSegueWithIdentifier:segueIdentifer sender:self];
    }
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

#pragma mark- CZJGeneralSubCellDelegate
- (void)clickSubCellButton:(UIButton*)button andType:(int)subType
{
    NSInteger touchIndex = button.tag;
    if (kCZJGeneralSubCellTypePersonal == subType)
    {//个人信息
        NSDictionary* dict = personalCellAry[touchIndex - 1];
        NSString* segueIdentifier = [dict valueForKey:@"segueTo"];
        [self performSegueWithIdentifier:segueIdentifier sender:self];
    }
    if (kCZJGeneralSubCellTypeOrder == subType)
    {//订单
        _currentTouchOrderListType = touchIndex;
        [self performSegueWithIdentifier:@"segueToMyOrderList" sender:self];
    }
}


#pragma mark- CZJMyInfoHeadCellDelegate
-(void)clickMyInfoHeadCell:(id)sender
{
    if (0 == ((UIButton*)sender).tag)
    {
        //消息中心
        [self performSegueWithIdentifier:@"segueToMessageCenter" sender:self];
    }
//    else
//    {
//        //车辆信息
//        [self performSegueWithIdentifier:@"segueToMyCarList" sender:self];
//    }
}

#pragma mark- CZJViewControllerDelegate
- (void)didCancel:(id)controller
{
}

#pragma mark - Navigation
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //如果没有登录则进入登录页面
    if ([identifier isEqualToString:@"segueToSetting"] ||
        [PUtils isLoginIn:self andNaviBar:nil])
    {
        UIViewController* parentVC = self.parentViewController;
        if ([parentVC isKindOfClass:[YQSlideMenuController class]])
        {
            [parentVC performSegueWithIdentifier:identifier sender:sender];
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToPersonalInfo"])
    {
        FSMyPersonalInfoController* myPersonal = segue.destinationViewController;
        myPersonal.myinfor = myInfoForm;
    }
    if ([segue.identifier isEqualToString:@"segueToMyCarList"])
    {
        FSMyCarListController* carListVC = segue.destinationViewController;
        carListVC.carListAry = [carListAry mutableCopy];
    }
    if ([segue.identifier isEqualToString:@"segueToMyOrderList"])
    {
//        CZJMyInfoOrderListController* orderListVC = segue.destinationViewController;
//        orderListVC.orderListTypeIndex = _currentTouchOrderListType;
    }
    if ([segue.identifier isEqualToString:@"segueToService"])
    {
//        CZJMyInfoServiceFeedbackController* serviceFeedBack = segue.destinationViewController;
//        serviceFeedBack.hotLine = myInfoForm.hotline;
    }
}

@end
