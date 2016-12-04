//
//  FSMyViewedController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyViewedController.h"
#import "FSBaseDataManager.h"
#import "CZJGoodsAttentionCell.h"

@interface FSMyViewedController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    NSArray* keyAry;
    MJRefreshAutoNormalFooter* refreshFooter;
    __block CZJHomeGetDataFromServerType _getdataType;
    
    NSMutableDictionary* sortedDict;
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
    keyAry = [NSArray array];
    self.page = 1;
    _getdataType = CZJHomeGetDataFromServerTypeOne;
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"足迹";
    
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
    __weak typeof(self) weak = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary* params = @{@"page_num": @(self.page)};
    [PUtils removeNoDataAlertViewFromTarget:self.view];
    [PUtils removeReloadAlertViewFromTarget:self.view];
    [FSBaseDataInstance getScanList:params Success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        NSMutableArray *scanListAry = [NSMutableArray array];
        //========获取数据返回，判断数据大于0不==========
        NSArray* tmpAry = [json valueForKey:kResoponData];
        if (CZJHomeGetDataFromServerTypeTwo == _getdataType)
        {
            [scanListAry addObjectsFromArray: [FSViewedForm objectArrayWithKeyValuesArray:tmpAry]];
            if (tmpAry.count < 20)
            {
                [refreshFooter noticeNoMoreData];
            }
            else
            {
                [weak.myTableView.footer endRefreshing];
            }
        }
        else
        {
            scanListAry = [[FSViewedForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
        }
        
        VIEWWITHTAG(self.navigationController.navigationBar, 1999).hidden = (scanListAry.count == 0);
        if (scanListAry.count == 0)
        {
            self.myTableView.hidden = YES;
            [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"木有浏览记录/(ToT)/~~"];
        }
        else
        {
            [weak dealWithScanList:scanListAry];
        }
    }
     fail:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         [PUtils showReloadAlertViewOnTarget:weak.view withReloadHandle:^{
             [weak getScanListFromServer];
         }];
     }];
}

- (void)dealWithScanList:(NSMutableArray *)_scanList
{
    self.myTableView.hidden = (_scanList.count == 0);
    if (_scanList.count == 0)
        return;
    [_scanList sortUsingComparator:^NSComparisonResult(FSViewedForm *obj1, FSViewedForm *obj2) {
        return [obj1.view_time compare:obj2.view_time];
    }];

    NSString *lasttime;
    sortedDict = [NSMutableDictionary dictionary];
    NSMutableArray *valueAry;
    for (FSViewedForm *viewdForm  in _scanList) {
        viewdForm.view_time_date = [PUtils dateFromNString:viewdForm.view_time];
        viewdForm.view_time_short = [viewdForm.view_time substringToIndex:10];
        
        if (![viewdForm.view_time_short isEqualToString:lasttime])
        {
            lasttime = viewdForm.view_time_short;
            valueAry = [NSMutableArray array];
            [valueAry addObject:viewdForm];
            [sortedDict setObject:valueAry forKey:lasttime];
        }
        else
        {
            [valueAry addObject:viewdForm];
        }
    }
    
    keyAry = [sortedDict allKeys];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView reloadData];
    self.myTableView.footer.hidden = self.myTableView.mj_contentH < self.myTableView.frame.size.height;
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
//            [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"木有浏览记录/(ToT)/~~"];
//        } fail:^{
//            [PUtils tipWithText:@"服务器异常，清除失败" andView:weak.view];
//        }];
        [weak hideWindow];
        [weak.navigationItem.rightBarButtonItem setEnabled:true];
    } andCancleHandler:nil];
    
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return keyAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tmpAry = sortedDict[keyAry[section]];
    return tmpAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSViewedForm* form = sortedDict[keyAry[indexPath.section]][indexPath.row];
    CZJGoodsAttentionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGoodsAttentionCell" forIndexPath:indexPath];
    NSString* urlstr = ConnectString(kCZJServerAddr, @"1");
    //关注图片
    [cell.goodImg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:DefaultPlaceHolderSquare];
    
    //关注名称
    CGSize nameSize = [PUtils calculateStringSizeWithString:form.shop_name Font:SYSTEMFONT(15) Width:PJ_SCREEN_WIDTH - 115];
    cell.goodNameLabel.text = form.shop_name;
    cell.goodNameLayoutHeight.constant = nameSize.height > 15 ? nameSize.height + 5 : 15;
    
    //关注价格
    cell.priceLabel.hidden = YES;
    
    //好评等隐藏
    cell.goodrateName.text = @"门店地址";
    cell.evaluateLabel.text = form.shop_address;
    cell.separatorInset = HiddenCellSeparator;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FSCustomerViewdForm* dict = scanListAry[indexPath.row];
//    if (!self.fromMessage)
//    {
//        [PUtils showGoodsServiceDetailView:self.navigationController andItemPid:dict.storeItemPid detailType:[dict.itemType intValue] == 0 ? CZJDetailTypeGoods : CZJDetailTypeService];
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
    return 30;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return keyAry[section];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉tableview中section的headerview粘性
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
@end
