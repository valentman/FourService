//
//  FSStoreListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStoreListController.h"
#import "FSBaseDataManager.h"
#import "FSServiceStepController.h"
#import "FSServiceStoreCell.h"
#import "MXPullDownMenu.h"


@interface FSStoreListController ()
<UITableViewDelegate,
UITableViewDataSource,
MXPullDownMenuDelegate
>
{
    __block CZJHomeGetDataFromServerType _getdataType;
    MJRefreshAutoNormalFooter* refreshFooter;
    __block NSInteger page;
    BOOL _isAnimate;
}
@property (strong, nonatomic) __block NSMutableArray* storeList;
@property (strong, nonatomic) UITableView* myTableView;
@property (strong, nonatomic) MXPullDownMenu* pullDownMenu;
@end

@implementation FSStoreListController

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
    self.naviBarView.mainTitleLabel.text = @"选择门店";
    self.naviBarView.mainTitleLabel.textColor = WHITECOLOR;
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    [self.naviBarView.btnMore setBackgroundImage:nil forState:UIControlStateNormal];
    [self.naviBarView.btnMore setImage:IMAGENAMED(@"shop_btn_map") forState:UIControlStateNormal];
    self.naviBarView.btnMore.hidden = NO;
    
    //下拉菜单
//    NSArray* sortTypes = @[@"默认排序", @"距离最近", @"评分最高", @"销量最高"];
//    NSArray* storeTypes = @[@"全部",@"一站式", @"快修快保", @"装饰美容" , @"维修厂"];
//    NSArray *siftTypes = @[@"筛选"];
//    NSArray *provincCitys = @[@"成都", @"绵阳"];
////    if ([FSBaseDataInstance storeForm].provinceForms &&
////        [FSBaseDataInstance storeForm].provinceForms.count > 0) {
//        NSArray* menuArray = @[provincCitys, sortTypes, storeTypes, siftTypes];
//        self.pullDownMenu  = [[MXPullDownMenu alloc] initWithArray:menuArray AndType:CZJMXPullDownMenuTypeStore WithFrame:self.pullDownMenu.frame];
//        self.pullDownMenu.delegate = self;
//    
//    self.pullDownMenu.frame = CGRectMake(0, 64, PJ_SCREEN_WIDTH, 44);
//    [self.view addSubview:self.pullDownMenu];
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.clipsToBounds = NO;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CZJTableViewBGColor;
        
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        UINib *nib=[UINib nibWithNibName:@"FSServiceStoreCell" bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:@"FSServiceStoreCell"];

        __weak typeof(self) weak = self;
        refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(){
            _getdataType = CZJHomeGetDataFromServerTypeTwo;
            page++;
            [weak getStoreDataFromServer];;
        }];
        weak.myTableView.footer = refreshFooter;
        weak.myTableView.footer.hidden = YES;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    NSString* discountPriceStr = [NSString stringWithFormat:@"￥%@",@"28"];
    cell.discountPriceLabel.text = discountPriceStr;
    CGSize discountLabelSize = [PUtils calculateTitleSizeWithString:discountPriceStr WithFont:cell.discountPriceLabel.font];
    cell.discoutPriceLabelWidth.constant = discountLabelSize.width;
    cell.discountPriceLabel.keyWord = @"￥";
    
    //原价
    NSString* originPriceStr = [NSString stringWithFormat:@"￥%@",@"68"];
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
    
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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
    FSStoreInfoForm* storeInfo = _storeList[indexPath.row];
    [self performSegueWithIdentifier:@"segueToStep" sender:storeInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToStep"])
    {
        FSServiceStepController* serviceStepVC = segue.destinationViewController;
        serviceStepVC.storeInfoForm = sender;
    }
    else
    {
        
    }
}

- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
            [self performSegueWithIdentifier:@"segueToMap" sender:nil];
            break;
            
        case CZJButtonTypeNaviBarBack:
            [self.navigationController popViewControllerAnimated:true];
            break;
            
        case CZJButtonTypeHomeShopping:
            
            break;
            
        default:
            break;
    }
}

@end
