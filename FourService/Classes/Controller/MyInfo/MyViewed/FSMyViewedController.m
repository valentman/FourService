//
//  FSMyViewedController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyViewedController.h"
#import "FSBaseDataManager.h"

@interface FSMyViewedController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableArray* scanListAry;
    MJRefreshAutoNormalFooter* refreshFooter;
    __block CZJHomeGetDataFromServerType _getdataType;
}

@property (strong, nonatomic) UITableView *myTableView;
@property (assign, nonatomic) NSInteger page;
@end

@implementation FSMyViewedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getScanListFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)initDatas
{
    scanListAry = [NSMutableArray array];
    self.page = 1;
    _getdataType = CZJHomeGetDataFromServerTypeOne;
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
//    if (!self.fromMessage) {
//        self.naviBarView.mainTitleLabel.text = @"浏览记录";
//        //右按钮
//        UIButton *rightBtn = [[ UIButton alloc ] initWithFrame : CGRectMake(PJ_SCREEN_WIDTH - 59 , 0 , 44 , 44 )];
//        [rightBtn setTitle:@"清空" forState:UIControlStateNormal];
//        [rightBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
//        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [rightBtn setSelected:NO];
//        rightBtn.titleLabel.font = SYSTEMFONT(16);
//        [rightBtn setTag:1999];
//        [self.naviBarView addSubview: rightBtn];
//    }
//    else
//    {
        self.naviBarView.mainTitleLabel.text = @"足迹";
//    }
    
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.backgroundColor = CZJTableViewBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    UINib *nib=[UINib nibWithNibName:@"CZJGoodsAttentionCell" bundle:nil];
    [self.myTableView registerNib:nib forCellReuseIdentifier:@"CZJGoodsAttentionCell"];
    
    __weak typeof(self) weak = self;
    refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(){
        _getdataType = CZJHomeGetDataFromServerTypeTwo;
        weak.page++;
        [weak getScanListFromServer];;
    }];
    self.myTableView.footer = refreshFooter;
    self.myTableView.footer.hidden = YES;
}

- (void)getScanListFromServer
{
//    __weak typeof(self) weak = self;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary* params = @{@"page": @(self.page)};
//    if (!self.fromMessage)
//    {
//        params = @{@"page": @(self.page)};
//    }
//    else
//    {
//        params = @{@"page": @(self.page),@"storeId" :self.storeId};
//    }
//    [CZJUtils removeNoDataAlertViewFromTarget:self.view];
//    [CZJUtils removeReloadAlertViewFromTarget:self.view];
//    [CZJBaseDataInstance loadScanList:params Success:^(id json) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//        
//        //========获取数据返回，判断数据大于0不==========
//        NSArray* tmpAry = [[CZJUtils DataFromJson:json] valueForKey:@"msg"];
//        if (CZJHomeGetDataFromServerTypeTwo == _getdataType)
//        {
//            [scanListAry addObjectsFromArray: [CZJMyScanRecordForm objectArrayWithKeyValuesArray:tmpAry]];
//            if (tmpAry.count < 20)
//            {
//                [refreshFooter noticeNoMoreData];
//            }
//            else
//            {
//                [weak.myTableView.footer endRefreshing];
//            }
//        }
//        else
//        {
//            scanListAry = [[CZJMyScanRecordForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
//        }
//        
//        VIEWWITHTAG(self.navigationController.navigationBar, 1999).hidden = (scanListAry.count == 0);
//        if (scanListAry.count == 0)
//        {
//            self.myTableView.hidden = YES;
//            [CZJUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"木有浏览记录/(ToT)/~~"];
//        }
//        else
//        {
//            self.myTableView.hidden = (scanListAry.count == 0);
//            self.myTableView.delegate = self;
//            self.myTableView.dataSource = self;
//            [self.myTableView reloadData];
//            self.myTableView.footer.hidden = self.myTableView.mj_contentH < self.myTableView.frame.size.height;
//        }
//    }
//                                 fail:^{
//                                     [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//                                     [CZJUtils showReloadAlertViewOnTarget:weak.view withReloadHandle:^{
//                                         [weak getScanListFromServer];
//                                     }];
//                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)edit:(id)sender
{
    __weak typeof(self) weak = self;
    [self.navigationItem.rightBarButtonItem setEnabled:false];
    [self showFSAlertView:@"确认清除浏览记录？" andConfirmHandler:^{
//        [FSBaseDataInstance clearScanList:nil Success:^(id json) {
//            [scanListAry removeAllObjects];
//            VIEWWITHTAG(self.navigationController.navigationBar, 1999).hidden = (scanListAry.count == 0);
//            self.myTableView.hidden = (scanListAry.count == 0);
//            [self.myTableView reloadData];
//            [CZJUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"木有浏览记录/(ToT)/~~"];
//        } fail:^{
//            [CZJUtils tipWithText:@"服务器异常，清除失败" andView:weak.view];
//        }];
        [weak hideWindow];
        [weak.navigationItem.rightBarButtonItem setEnabled:true];
    } andCancleHandler:nil];
    
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scanListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCustomerViewdForm* form = scanListAry[indexPath.row];
//    CZJGoodsAttentionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGoodsAttentionCell" forIndexPath:indexPath];
//    //关注图片
//    [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:form.itemImg] placeholderImage:DefaultPlaceHolderSquare];
//    
//    //关注名称
//    CGSize nameSize = [CZJUtils calculateStringSizeWithString:form.itemName Font:SYSTEMFONT(15) Width:PJ_SCREEN_WIDTH - 115];
//    cell.goodNameLabel.text = form.itemName;
//    cell.goodNameLayoutHeight.constant = nameSize.height > 15 ? nameSize.height + 5 : 15;
//    
//    //关注价格
//    cell.priceLabel.text = form.currentPrice;
//    cell.priceButton.constant = 10;
//    
//    //好评等隐藏
//    cell.goodrateName.hidden = YES;
//    cell.evaluateLabel.hidden = YES;
//    cell.dealName.hidden = YES;
//    cell.dealCountLabel.hidden = YES;
//    cell.separatorInset = HiddenCellSeparator;
//    return cell;
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCustomerViewdForm* dict = scanListAry[indexPath.row];
//    if (!self.fromMessage)
//    {
//        [CZJUtils showGoodsServiceDetailView:self.navigationController andItemPid:dict.storeItemPid detailType:[dict.itemType intValue] == 0 ? CZJDetailTypeGoods : CZJDetailTypeService];
//    }
//    else
//    {
//        if ([self.delegate respondsToSelector:@selector(clickOneRecordToMessage:)])
//        {
//            [self.delegate clickOneRecordToMessage:dict];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


@end
