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
    
    FSPersonalForm* myInfoForm;
    
    
    NSArray* discountNormalAry;
    NSArray* discountUsedAry;
    NSArray* discountExpiredAry;
    NSArray* carListAry;
    NSArray* customerViewdAry;
    NSArray* customerFavoriteAry;
    NSArray* shopCommentAry;
    
}
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation FSMyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
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
    [USER_DEFAULT setBool:YES forKey:kCZJIsUserHaveLogined];
    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined]) {
//        [self getMyInfoDataFromServer];
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

- (void)initDatas
{
    personalCellAry = [NSArray array];
    NSDictionary* pDict0 = @{@"title":@"足迹",
                             @"buttonImage":@"my_icon_pay",
                             @"segueTo":@"segutToRecord"};
    NSDictionary* pDict1 = @{@"title":@"收藏",
                             @"buttonImage":@"my_icon_pay",
                             @"segueTo":@"segueToMyAttention"};
    NSDictionary* pDict2 = @{@"title":@"评价",
                             @"buttonImage":@"my_icon_pay",
                             @"segueTo":@"segueToMyEvaluation"};
    NSDictionary* pDict3 = @{@"title":@"优惠券",
                             @"buttonImage":@"my_icon_pay",
                             @"segueTo":@"segueToCoupon"};
    personalCellAry = @[pDict0,pDict1,pDict2,pDict3];
    
    orderSubCellAry  = [NSArray array];
    NSMutableDictionary* dict1 = [@{@"title":@"待付款",
                                    @"buttonImage":@"my_icon_pay",
                                    @"budge":@"0",
                                    @"item":@"nopay"} mutableCopy];
    NSMutableDictionary* dict2 = [@{@"title":@"服务中",
                                    @"buttonImage":@"my_icon_shigong",
                                    @"budge":@"0",
                                    @"item":@"nobuild"} mutableCopy];
    NSMutableDictionary* dict4 = [@{@"title":@"待评价",
                                    @"buttonImage":@"my_icon_recommend",
                                    @"budge":@"0",
                                    @"item":@"noevaluate"} mutableCopy];
    NSMutableDictionary* dict5 = [@{@"title":@"已评价",
                                    @"buttonImage":@"my_icon_tuihuo",
                                    @"budge":@"0",
                                    @"item":@""} mutableCopy];
    orderSubCellAry = @[dict1,dict2,dict4,dict5];
    
    walletSubCellAry = [NSArray array];
    
    discountNormalAry = [NSArray array];
    discountUsedAry  = [NSArray array];
    discountExpiredAry  = [NSArray array];
    carListAry  = [NSArray array];
    customerViewdAry  = [NSArray array];
    customerFavoriteAry  = [NSArray array];
    shopCommentAry  = [NSArray array];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTabBarDotLabel) name:kCZJNotifiRefreshMessageReadStatus object:nil];
}

- (void)refreshTabBarDotLabel
{
    [self.myTableView reloadData];
}


- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - Tabbar_HEIGHT) style:UITableViewStylePlain];
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
    
}

- (void)getMyInfoDataFromServer
{
    
    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
    {
        [FSBaseDataInstance getUserInfo:nil Success:^(id json) {
            NSDictionary* dict = [json valueForKey:kResoponData];
            DLog(@"%@",[dict description]);
            
            //服务器返回数据本地化，全部转化为模型数据存储在数组中
            myInfoForm = [FSPersonalForm objectWithKeyValues:dict];
            discountNormalAry = [FSDiscountNormalForm objectArrayWithKeyValuesArray:[dict valueForKey:@"discount_normal"]];
            discountUsedAry = [FSDiscountUsedForm objectArrayWithKeyValuesArray:[dict valueForKey:@"discount_used"]];
            discountExpiredAry = [FSDiscountExpiredForm objectArrayWithKeyValuesArray:[dict valueForKey:@"discount_expired"]];
            carListAry = [FSCarListForm objectArrayWithKeyValuesArray:[dict valueForKey:@"car_list"]];
            customerViewdAry = [FSCustomerViewdForm objectArrayWithKeyValuesArray:[dict valueForKey:@"Customer_view"]];
            customerFavoriteAry = [FSCustomerFavoriteForm objectArrayWithKeyValuesArray:[dict valueForKey:@"Customer_favorite"]];
            shopCommentAry = [FSShopCommentForm objectArrayWithKeyValuesArray:[dict valueForKey:@"Shop_comment"]];
            
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
    for (NSDictionary* walletDict in walletSubCellAry)
    {
        NSString* itemName = [walletDict valueForKey:@"item"];
        if (![itemName isEqualToString:@""])
        {
            NSString* count = [dict valueForKey:itemName];
            [walletDict setValue:count forKey:@"buttonTitle"];
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
            cell.delegate = self;
            cell.separatorInset = HiddenCellSeparator;
            cell.contentView.backgroundColor = CZJNAVIBARBGCOLOR;
            return cell;
        }
        else
        {
            CZJGeneralSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralSubCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setGeneralSubCell:personalCellAry andType:kCZJGeneralSubCellTypePersonal];
            cell.backgroundColor = CZJNAVIBARBGCOLOR;
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
            CZJGeneralSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralSubCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setGeneralSubCell:orderSubCellAry andType:kCZJGeneralSubCellTypeOrder];
            return cell;
        }
    }
    else if (2 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.text = @"服务与反馈";
            cell.nameLabelLeading.constant = 15;
            return cell;
        }
        else
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.text = @"设置";
            cell.nameLabelLeading.constant = 15;
            cell.separatorInset = UIEdgeInsetsMake(46, PJ_SCREEN_WIDTH, 0, 0);
            return cell;
        }
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            return 250;
        }
        else if (1 == indexPath.row)
        {
            return 66;
        }
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            return 46;
        }
        else
        {
            return 60;
        }
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
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* segueIdentifer;
    
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            segueIdentifer = @"segueToPersonalInfo";
        }
    }
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            _currentTouchOrderListType = 0;
            segueIdentifer = @"segueToMyOrderList";
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            segueIdentifer = @"segueToService";
        }
        else
        {
            segueIdentifer = @"segueToSetting";
        }
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
    else
    {
        //浏览记录
        [self performSegueWithIdentifier:@"segueToMyCarList" sender:self];
    }
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
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToMyOrderList"])
    {
//        CZJMyInfoOrderListController* orderListVC = segue.destinationViewController;
//        orderListVC.orderListTypeIndex = _currentTouchOrderListType;
    }

    if ([segue.identifier isEqualToString:@"segueToRedPacket"])
    {
//        CZJMyWalletRedpacketController* redpackeVC = segue.destinationViewController;
//        redpackeVC.redPacketNum = myInfoForm.redpacket;
    }
    if ([segue.identifier isEqualToString:@"segueToService"])
    {
//        CZJMyInfoServiceFeedbackController* serviceFeedBack = segue.destinationViewController;
//        serviceFeedBack.hotLine = myInfoForm.hotline;
    }
}

@end
