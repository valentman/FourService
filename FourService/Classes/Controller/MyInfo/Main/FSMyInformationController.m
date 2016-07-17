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

@interface FSMyInformationController ()
<
UITableViewDataSource,
UITableViewDelegate,
CZJGeneralSubCellDelegate,
CZJMyInfoHeadCellDelegate,
CZJMyInfoShoppingCartCellDelegate
>
{
    NSArray* orderSubCellAry;           //订单cell下子项数组
    NSArray* walletSubCellAry;          //我的钱包下子项数组
    NSInteger _currentTouchOrderListType;
    
    FSMyInfoForm* myInfoForm;
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

- (void)initDatas
{
    orderSubCellAry  = [NSArray array];
    NSMutableDictionary* dict1 = [@{@"title":@"待付款",
                                    @"buttonImage":@"my_icon_pay",
                                    @"budge":@"0",
                                    @"item":@"nopay"} mutableCopy];
    NSMutableDictionary* dict2 = [@{@"title":@"待施工",
                                    @"buttonImage":@"my_icon_shigong",
                                    @"budge":@"0",
                                    @"item":@"nobuild"} mutableCopy];
    NSMutableDictionary* dict3 = [@{@"title":@"待收货",
                                    @"buttonImage":@"my_icon_shouhuo",
                                    @"budge":@"0",
                                    @"item":@"noreceive"} mutableCopy];
    NSMutableDictionary* dict4 = [@{@"title":@"待评价",
                                    @"buttonImage":@"my_icon_recommend",
                                    @"budge":@"0",
                                    @"item":@"noevaluate"} mutableCopy];
    NSMutableDictionary* dict5 = [@{@"title":@"退换货",
                                    @"buttonImage":@"my_icon_tuihuo",
                                    @"budge":@"0",
                                    @"item":@""} mutableCopy];
    orderSubCellAry = @[dict1,dict2,dict4];
    
    walletSubCellAry = [NSArray array];
    NSMutableDictionary* dict6 = [@{@"title":@"红包",
                                    @"buttonTitle":@"0.0",
                                    @"item":@"redpacket"} mutableCopy];
    NSMutableDictionary* dict7 = [@{@"title":@"积分卡",
                                    @"buttonTitle":@"0",
                                    @"item":@"pointCard"} mutableCopy];
    NSMutableDictionary* dict8 = [@{@"title":@"储值卡",
                                    @"buttonTitle":@"0",
                                    @"item":@"memberCard"} mutableCopy];
    NSMutableDictionary* dict9 = [@{@"title":@"套餐卡",
                                    @"buttonTitle":@"0",
                                    @"item":@"card"} mutableCopy];
    NSMutableDictionary* dict0 = [@{@"title":@"优惠券",
                                    @"buttonTitle":@"0",
                                    @"item":@"coupon"} mutableCopy];
    
    walletSubCellAry = @[dict7,dict8,dict9,dict0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTabBarDotLabel) name:kCZJNotifiRefreshMessageReadStatus object:nil];
}

- (void)refreshTabBarDotLabel
{
    [self.myTableView reloadData];
}


- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.backgroundColor = CZJTableViewBGColor;
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
            NSDictionary* dict = [[PUtils DataFromJson:json] valueForKey:@"msg"];
            DLog(@"%@",[dict description]);
            myInfoForm = [FSMyInfoForm objectWithKeyValues:dict];
            [self updateOrderData:dict];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 4;
    }
    if (3 == section)
    {
        return 2;
    }
    else
    {
        return 2;
    }
    return 0;
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
//            [cell.messageBtn setBadgeNum:([CZJMessageInstance isAllReaded]? 0 : -1)];
//            [cell.messageBtn setBadgeLabelPosition:CGPointMake(cell.messageBtn.size.width * 0.95, cell.messageBtn.size.height * 0.07)];
//            if (CZJBaseDataInstance.userInfoForm && [USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
//            {
//                [cell setUserPersonalInfo:CZJBaseDataInstance.userInfoForm];
//                cell.delegate = self;
//            }
            cell.separatorInset = HiddenCellSeparator;
            return cell;
        }
        else if (1 == indexPath.row)
        {
            CZJMyInfoShoppingCartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyInfoShoppingCartCell" forIndexPath:indexPath];
            //            NSString* shoppingCartCount = [USER_DEFAULT valueForKey:kUserDefaultShoppingCartCount];
            //            [cell.shoppingBtn setBadgeNum:[shoppingCartCount integerValue]];
            //            [cell.shoppingBtn setBadgeLabelPosition:CGPointMake(cell.shoppingBtn.frame.size.width*0.95, 5)];
            cell.delegate = self;
            return cell;
        }
        else if (2 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:nil];
            [cell.imageView setImage:IMAGENAMED(@"my_icon_list")];
            cell.nameLabel.text = @"我的订单";
            cell.detailLabel.hidden = NO;
            return cell;
        }
        else
        {
            CZJGeneralSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralSubCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setGeneralSubCell:orderSubCellAry andType:kCZJGeneralSubCellTypeOrder];
            return cell;
        }
    }
    else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell"];
            cell.imageView.image = IMAGENAMED(@"");
            [cell.imageView setImage:IMAGENAMED(@"my_icon_wallet")];
            cell.nameLabel.text = @"我的钱包";
            cell.arrowImg.hidden = YES;
            return cell;
        }
        else
        {
            CZJGeneralSubCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralSubCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setGeneralSubCell:walletSubCellAry andType:kCZJGeneralSubCellTypeWallet];
            return cell;
        }
    }
    else if (2 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:IMAGENAMED(@"serve_icon_kefu")];
            cell.nameLabel.text = @"在线客服";
            return cell;
        }
        else
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:IMAGENAMED(@"serve_icon_call")];
            cell.nameLabel.text = @"电话咨询";
            return cell;
        }
    }
    else if (3 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:IMAGENAMED(@"my_icon_serve")];
            cell.nameLabel.text = @"意见反馈";
            return cell;
        }
        else
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            [cell.imageView setImage:IMAGENAMED(@"my_icon_set")];
            cell.nameLabel.text = @"设置";
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
            return 170;
        }
        else if (1 == indexPath.row)
        {
            return 56;
        }
        else if (2 == indexPath.row)
        {
            return 46;
        }
        else
        {
            return 60;
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
        if (2 == indexPath.row)
        {
            segueIdentifer = @"segueToMyOrderList";
        }
    }
    if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            //如果没有登录则进入登录页面
//            if ([PUtils isLoginIn:self andNaviBar:nil])
//            {
//                CZJChatViewController *chatController = [[CZJChatViewController alloc] initWithConversationChatter: CZJBaseDataInstance.userInfoForm.kefuId conversationType:EMConversationTypeChat];
//                chatController.storeName = @"车之健客服";
//                chatController.storeId = @"";
//                chatController.storeImg = CZJBaseDataInstance.userInfoForm.kefuHead;
//                chatController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:chatController animated:YES];
//            }
        }
        else
        {
            if ([PUtils isLoginIn:self andNaviBar:nil])
            {
                [PUtils callHotLine:myInfoForm.hotline AndTarget:self.view];
            }
        }
    }
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
//            CZJOpinioFeedbackController* opinionVC = (CZJOpinioFeedbackController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"OpinionFeedBackSBID"];
//            opinionVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:opinionVC animated:YES];
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

#pragma mark- CZJGeneralSubCellDelegate
- (void)clickSubCellButton:(UIButton*)button andType:(int)subType
{
    _currentTouchOrderListType = button.tag;
    if (kCZJGeneralSubCellTypeOrder == subType)
    {//订单
        if (_currentTouchOrderListType < 5)
        {
            [self performSegueWithIdentifier:@"segueToMyOrderList" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"segueToMyReturnedList" sender:self];
        }
    }
    else
    {//钱包
        NSString* segueId = @"";
        switch (_currentTouchOrderListType)
        {
            case 1:
                segueId = @"segueToPoint";
                break;
                
            case 2:
            {
                segueId = @"segueToMemberCard";
            }
                break;
                
            case 3:
                segueId = @"segueToCard";
                break;
                
            case 4:
                segueId = @"segueToCoupon";
                break;
                
            default:
                break;
        }
        if (![segueId isEqualToString:@""])
        {
            [self performSegueWithIdentifier:segueId sender:self];
        }
    }
}



#pragma mark- CZJMyInfoShoppingCartCellDelegate
- (void)clickMyInfoShoppingCartCell:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case 0:
        {
            //浏览记录
            [self performSegueWithIdentifier:@"segutToRecord" sender:self];
        }
            break;
        case 1:
            //我的关注
            [self performSegueWithIdentifier:@"segueToMyAttention" sender:self];
            break;
        case 2:
            //我的评价
            [self performSegueWithIdentifier:@"segueToMyEvaluation" sender:self];
            break;
            
        default:
            break;
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
        [self performSegueWithIdentifier:@"segutToRecord" sender:self];
    }
}

#pragma mark- CZJViewControllerDelegate
- (void)didCancel:(id)controller
{
//    if ([controller isKindOfClass: [CZJLoginController class]] )
//    {
//        [self getMyInfoDataFromServer];
//        [PUtils removeLoginViewFromCurrent:self];
//    }
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
    
    if ([segue.identifier isEqualToString:@"segueToMyReturnedList"])
    {
//        CZJOrderListReturnedController* returnList = segue.destinationViewController;
//        returnList.returnListType = CZJReturnListTypeReturned;
    }
    if ([segue.identifier isEqualToString:@"segueToShare"])
    {
//        CZJMyInfoShareController* shareVC = segue.destinationViewController;
//        shareVC.myShareCode = myInfoForm.couponCode;
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
