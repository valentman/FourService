//
//  FSChangeTireController.m
//  FourService
//
//  Created by Joe.Pen on 05/12/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSChangeTireController.h"
#import "FSChangeTireCell.h"
#import "FSServiceStoreCell.h"
#import "FSBaseDataManager.h"
#import "FSTireSpecsController.h"

@interface FSChangeTireController ()<UITableViewDelegate,UITableViewDataSource>
{
    __block CZJHomeGetDataFromServerType _getdataType;
    MJRefreshAutoNormalFooter* refreshFooter;
    __block NSInteger page;
}
@property (strong, nonatomic) __block NSMutableArray* storeList;
//创建TableView，注册Cell
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSChangeTireController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getStoreDataFromServer];
}

- (void)initDatas
{
    _storeList = [NSMutableArray array];
    page = 1;
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 64);
    self.naviBarView.mainTitleLabel.text = @"轮胎规格";

    self.naviBarView.clipsToBounds = YES;
    [self.naviBarView.btnMore setBackgroundImage:nil forState:UIControlStateNormal];
    self.naviBarView.btnMore.frame = CGRectMake(PJ_SCREEN_WIDTH - 80, 22, 80, 40);
    self.naviBarView.btnMore.titleLabel.font = SYSTEMFONT(14);
    [self.naviBarView.btnMore setTitle:@"切换规格" forState:UIControlStateNormal];
    self.naviBarView.btnMore.hidden = NO;
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CZJTableViewBGColor;
        [self.view addSubview:self.myTableView];
        
        NSArray* nibArys = @[@"FSChangeTireCell",
                             @"FSServiceStoreCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)getStoreDataFromServer
{
    NSDictionary* params = @{@"service_type_id" : self.serviceId,
                             @"page_num" : @(page)};
    __weak typeof (self) weakSelf = self;
    [PUtils removeNoDataAlertViewFromTarget:self.view];
    [PUtils removeReloadAlertViewFromTarget:self.view];
    if (_getdataType == CZJHomeGetDataFromServerTypeOne)
    {
    }
    [YXSpritesLoadingView showWithText:nil andShimmering:NO andBlurEffect:NO];
    [FSBaseDataInstance getStoreList:params type:CZJHomeGetDataFromServerTypeOne success:^(id json) {
        [YXSpritesLoadingView dismiss];
        //返回数据
        NSArray* tmpAry = [NSArray array];
        tmpAry = [json valueForKey:kResoponData];
        NSInteger count = [tmpAry isKindOfClass:[NSNull class]] ? 0 : tmpAry.count;
        //刷新或是第一次加载情况
        if (CZJHomeGetDataFromServerTypeOne == _getdataType) {
            [_storeList removeAllObjects];
            _storeList = [[FSStoreInfoForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
        }
        //下拉加载更多情况
        else
        {
            [_storeList addObjectsFromArray:[FSStoreInfoForm objectArrayWithKeyValuesArray:tmpAry]];
        }
        
        [weakSelf.myTableView reloadData];
        if (count < 10)
        {
            [weakSelf.myTableView.footer noticeNoMoreData];
        }
        else
        {
            [weakSelf.myTableView.footer endRefreshing];
        }
        
        
        //返回数据回来还未解析到本地数组中时就不显示下拉刷新
        if (_storeList.count == 0)
        {
            weakSelf.myTableView.footer.hidden = YES;
        }
        else
        {
            weakSelf.myTableView.footer.hidden = NO;
        }
        
        if (_storeList.count == 0)
        {
            weakSelf.myTableView.hidden = YES;
            [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"无相关门店/(ToT)/~~"];
        }
        else
        {
            weakSelf.myTableView.hidden = NO;
            if (_getdataType == CZJHomeGetDataFromServerTypeOne)
            {
                [weakSelf.myTableView setContentOffset:CGPointMake(0,0) animated:NO];
            }
            [weakSelf.myTableView reloadData];
            weakSelf.myTableView.footer.hidden = weakSelf.myTableView.mj_contentH < weakSelf.myTableView.frame.size.height;
        }
        
    } fail:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _storeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        FSStoreInfoForm* storeInfoForm = _storeList[indexPath.row];
        FSServiceStoreCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStoreCell" forIndexPath:indexPath];
        
        //门店图片
        NSURL* imgUrl;
        if (((FSStoreImageForm*)storeInfoForm.shop_image_list.firstObject).image_url)
        {
            imgUrl = [NSURL URLWithString:ConnectString(kCZJServerAddr,((FSStoreImageForm*)storeInfoForm.shop_image_list.firstObject).image_url)];
        }
        [cell.storeImage sd_setImageWithURL:imgUrl placeholderImage:DefaultPlaceHolderSquare];
        
        //门店名称
        cell.storeNameLabel.text = storeInfoForm.shop_name;
        
        //折扣价
        NSString* discountPriceStr = [NSString stringWithFormat:@"￥%@",storeInfoForm.service_discount_price];
        cell.discountPriceLabel.text = discountPriceStr;
        CGSize discountLabelSize = [PUtils calculateTitleSizeWithString:discountPriceStr WithFont:cell.discountPriceLabel.font];
        cell.discoutPriceLabelWidth.constant = discountLabelSize.width;
        cell.discountPriceLabel.keyWord = @"￥";
        
        //原价
        NSString* originPriceStr = [NSString stringWithFormat:@"￥%@",storeInfoForm.service_price];
        cell.originPriceLabel.text = originPriceStr;
        CGSize originLabelSize = [PUtils calculateTitleSizeWithString:originPriceStr WithFont:cell.originPriceLabel.font];
        cell.originPriceLabelWidth.constant = originLabelSize.width;
        cell.originPriceLabel.keyWord = @"￥";
        
        //开门时间
        cell.openTimeLabel.text = storeInfoForm.service_time;
        
        //评价分数和单数
        cell.evaluateScoreLabel.text = storeInfoForm.shop_score;
        cell.totalOrderLabel.text = [NSString stringWithFormat:@"/ %@单",storeInfoForm.order_num];
        
        //地址距离
        cell.storeAddrLabel.text = storeInfoForm.shop_address;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",@"2.9" ];
        
        //门店类型
        //    cell.storeTypeLabel.text = storeInfoForm.shop;
        
        //设置支付方式
        [cell setPaymentAvaiable:nil];
        
        [cell setSeparatorViewHidden:NO];
        return cell;
    }
    else
    {
        FSChangeTireCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSChangeTireCell" forIndexPath:indexPath];
        cell.separatorInset = IndentCellSeparator(20);
        return cell;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 130;
    }
    
    return 90;
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

- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
        {
            FSTireSpecsController *specsController = [[FSTireSpecsController alloc] init];
            [self presentViewController:specsController animated:YES completion:nil];
        }
            
            break;
            
        case CZJButtonTypeNaviBarBack:
            [self.navigationController popViewControllerAnimated:true];
            break;
            
        default:
            break;
    }
}

@end
