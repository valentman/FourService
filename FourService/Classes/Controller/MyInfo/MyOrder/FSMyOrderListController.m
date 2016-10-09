//
//  FSMyOrderListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyOrderListController.h"
#import "FSBaseDataManager.h"
#import "FSOrderEvaluateController.h"


@interface FSMyOrderListController ()
<
UITableViewDelegate,
UITableViewDataSource,
CZJOrderListCellDelegate
>
{
    float totalToPay;
    NSMutableArray* orderNoArys;
    
    MJRefreshAutoNormalFooter* refreshFooter;
    __block CZJHomeGetDataFromServerType _getdataType;
}
@property (strong, nonatomic)NSMutableArray* orderList;
@property (strong, nonatomic)UITableView* myTableView;
@property (assign, nonatomic) NSInteger page;
@end

@implementation FSMyOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initMyDatas];
    [self getOrderListFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getOrderListFromServer) name:kCZJNotifiRefreshOrderlist object:nil];
}

- (void)initMyDatas
{
    orderNoArys = [NSMutableArray array];
    _orderList = [NSMutableArray array];
    _params = [NSMutableDictionary dictionary];
    self.page = 1;
}


- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    NSString* title;
    switch (self.orderType) {
        case FSOrderListTypeAll:
            title = @"全部订单";
            break;
            
        case FSOrderListTypeNoPay:
            title = @"待支付";
            break;
            
        case FSOrderListTypeInService:
            title = @"服务中";
            break;
            
        case FSOrderListTypeNoComment:
            title = @"待评论";
            break;
            
        default:
            break;
    }
    self.naviBarView.mainTitleLabel.text = title;
    
    CGRect viewRect = CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT- 64);
    _myTableView = [[UITableView alloc]initWithFrame:viewRect style:UITableViewStylePlain];
    _myTableView.backgroundColor = CZJNAVIBARBGCOLOR;
    _myTableView.tableFooterView = [[UIView alloc]init];
    _myTableView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_myTableView];
    [self.view sendSubviewToBack:_myTableView];
    UINib *nib = [UINib nibWithNibName:@"CZJOrderListCell" bundle:nil];
    [_myTableView registerNib:nib forCellReuseIdentifier:@"CZJOrderListCell"];
    
    __weak typeof(self) weak = self;
    refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(){
        _getdataType = CZJHomeGetDataFromServerTypeTwo;
        weak.page++;
        [weak getOrderListFromServer];;
    }];
    self.myTableView.footer = refreshFooter;
    self.myTableView.footer.hidden = YES;
}

- (void)removeOrderlistControllerNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCZJNotifiRefreshOrderlist object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)getOrderListFromServer
{
    weaky(self);
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.completionBlock = ^{
    };
    [PUtils removeNoDataAlertViewFromTarget:self.view];
    [PUtils removeReloadAlertViewFromTarget:self.view];
    [_params setValue:@(self.page) forKey:@"page_num"];
    [_params setValue:@(1) forKey:@"order_status"];
    
    [FSBaseDataInstance getOrderList:_params Success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        DLog(@"orderList:%@",[json description]);
        //========获取数据返回，判断数据大于0不==========
        NSArray* tmpAry = json[kResoponData];
        if (CZJHomeGetDataFromServerTypeTwo == _getdataType)
        {
            [_orderList addObjectsFromArray: [CZJOrderListForm objectArrayWithKeyValuesArray:tmpAry]];
            if (tmpAry.count < 10)
            {
                [refreshFooter noticeNoMoreData];
            }
            else
            {
                [weakSelf.myTableView.footer endRefreshing];
            }
        }
        else
        {
            _orderList = [[CZJOrderListForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
            if (_orderList.count < 10)
            {
                [refreshFooter noticeNoMoreData];
            }
        }
        
        //========获取数据返回,刷新表格==========
        if (_orderList.count == 0)
        {
            self.myTableView.hidden = YES;
            [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:_noDataPrompt];
        }
        else
        {
            self.myTableView.hidden = NO;
            self.myTableView.delegate = self;
            self.myTableView.dataSource = self;
            [self.myTableView reloadData];
            self.myTableView.footer.hidden = self.myTableView.mj_contentH < self.myTableView.frame.size.height;
        }
    } fail:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [PUtils showReloadAlertViewOnTarget:weakSelf.view withReloadHandle:^{
            [weakSelf getOrderListFromServer];
        }];
    }];
}




#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZJOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJOrderListCell" forIndexPath:indexPath];
    [cell setCellModelWithType:_orderList[indexPath.section] andType:[[_params valueForKey:@"type"] integerValue]];
    cell.delegate = self;
    if (indexPath.section == _orderList.count - 1)
    {
        cell.separatorInset = HiddenCellSeparator;
    }
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 216;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToOrderDetail" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 10;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark- CZJOrderListCellDelegate
- (void)clickOrderListCellAction:(CZJOrderListCellButtonType)buttonType andOrderForm:(CZJOrderListForm*)orderListForm
{
    
    FSOrderEvaluateController* orderEvaluate = [[FSOrderEvaluateController alloc] init];
    [self.navigationController pushViewController:orderEvaluate animated:YES];
//    currentTouchedOrderListForm = orderListForm;
    /*switch (buttonType)
    {
        case CZJOrderListCellBtnTypeCheckCar:
            [self performSegueWithIdentifier:@"segueToCarCheck" sender:self];
            break;
            
        case CZJOrderListCellBtnTypeShowBuildingPro:
            [self performSegueWithIdentifier:@"segueToBuildingProgress" sender:self];
            break;
            
        case CZJOrderListCellBtnTypeCancel:
        {
            __weak typeof(self) weak = self;
            [self showFSAlertView:@"亲,是否确认取消订单" andConfirmHandler:^{
//                [FSBaseDataInstance generalPost    :@{@"orderNo" : currentTouchedOrderListForm.orderNo} success:^(id json) {
//                    NSDictionary* dict = [PUtils DataFromJson:json];
//                    DLog(@"%@",[dict description]);
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kCZJNotifiRefreshOrderlist object:nil];
//                }  fail:^{
//                    
//                } andServerAPI:kCZJServerAPICancelOrder];
                [weak hideWindow];
            } andCancleHandler:nil];
        }
            break;

        case CZJOrderListCellBtnTypeGoEvaluate:
        {
            FSOrderEvaluateController* orderEvaluate = [[FSOrderEvaluateController alloc] init];
            [self.navigationController pushViewController:orderEvaluate animated:YES];
        }
            break;
            
        default:
            break;
    }*/
}

- (void)clickPaySelectButton:(UIButton*)btn andOrderForm:(CZJOrderListForm*)orderListForm
{
    
}
@end
