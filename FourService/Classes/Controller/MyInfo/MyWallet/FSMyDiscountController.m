//
//  FSMyDiscountController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyDiscountController.h"
#import "CZJPageControlView.h"
#import "FSBaseDataManager.h"
#import "CZJReceiveCouponsCell.h"

@interface FSMyDiscountController ()

@end

@implementation FSMyDiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"优惠券";
    self.naviBarView.buttomSeparator.hidden = YES;
    
    //右按钮
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(PJ_SCREEN_WIDTH - 100 , 0 , 100 , 44 );
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setSelected:NO];
    [rightBtn setTag:2999];
    rightBtn.titleLabel.font = SYSTEMFONT(16);
    [self.naviBarView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    CZJMyWalletCouponUnUsedController* unUsed = [[CZJMyWalletCouponUnUsedController alloc]init];
    CZJMyWalletCouponUsedController* used = [[CZJMyWalletCouponUsedController alloc]init];
    CZJMyWalletCouponOutOfTimeController* outOfTime = [[CZJMyWalletCouponOutOfTimeController alloc]init];
    CGRect pageViewFrame = CGRectMake(0, StatusBar_HEIGHT + NavigationBar_HEIGHT, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT);
    CZJPageControlView* pageview = [[CZJPageControlView alloc]initWithFrame:pageViewFrame andPageIndex:0];
    pageview.backgroundColor = WHITECOLOR;
    [pageview setTitleArray:@[@"未使用",@"已使用",@"已过期"] andVCArray:@[unUsed, used, outOfTime]];
    
    [self.view addSubview:pageview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


@interface CZJMyWalletCouponListBaseController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    MJRefreshAutoNormalFooter* refreshFooter;
    __block CZJHomeGetDataFromServerType _getdataType;
    __block NSInteger page;
}
@property (strong, nonatomic)NSMutableArray* couponList;
@property (strong, nonatomic)UITableView* myTableView;
@end
@implementation CZJMyWalletCouponListBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyDatas];
    [self initViews];
}

- (void)initMyDatas
{
    _couponList = [NSMutableArray array];
    _params = [NSMutableDictionary dictionary];
    page = 1;
}

- (void)initViews
{
    CGRect viewRect = CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT- 114);
    _myTableView = [[UITableView alloc]initWithFrame:viewRect style:UITableViewStylePlain];
    _myTableView.backgroundColor = CZJTableViewBGColor;
    _myTableView.tableFooterView = [[UIView alloc]init];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.bounces = YES;
    [self.view addSubview:_myTableView];
    
    UINib *nib = [UINib nibWithNibName:@"CZJReceiveCouponsCell" bundle:nil];
    [_myTableView registerNib:nib forCellReuseIdentifier:@"CZJReceiveCouponsCell"];
    
    __weak typeof(self) weak = self;
    refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(){
        _getdataType = CZJHomeGetDataFromServerTypeTwo;
        page++;
        [weak getCouponListFromServer];;
    }];
    self.myTableView.footer = refreshFooter;
    self.myTableView.footer.hidden = YES;
}

- (void)getCouponListFromServer
{
    __weak typeof(self) weak = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PUtils removeNoDataAlertViewFromTarget:self.view];
    [PUtils removeReloadAlertViewFromTarget:self.view];
    [_params setValue:@(page) forKey:@"page_num"];
    [FSBaseDataInstance getDiscountList:_params Success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        //========获取数据返回，判断数据大于0不==========
        
        NSArray* tmpAry = [json valueForKey:kResoponData];
        if (CZJHomeGetDataFromServerTypeTwo == _getdataType)
        {
            [_couponList addObjectsFromArray: [FSDiscountForm objectArrayWithKeyValuesArray:tmpAry]];
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
            _couponList = [[FSDiscountForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
        }
        
        if (_couponList.count == 0)
        {
            self.myTableView.hidden = YES;
            [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"木有对应优惠券/(ToT)/~~"];
        }
        else
        {
            self.myTableView.hidden = (_couponList.count == 0);
            self.myTableView.delegate = self;
            self.myTableView.dataSource = self;
            [self.myTableView reloadData];
            self.myTableView.footer.hidden = self.myTableView.mj_contentH < self.myTableView.frame.size.height;
        }
        
    }  fail:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [PUtils showReloadAlertViewOnTarget:weak.view withReloadHandle:^{
            [weak getCouponListFromServer];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSDiscountForm* couponForm = _couponList[indexPath.row];
    CZJReceiveCouponsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJReceiveCouponsCell" forIndexPath:indexPath];
    cell.selectBtn.hidden = YES;
    cell.receivedImg.hidden = YES;
    cell.couponsViewLayoutWidth.constant = PJ_SCREEN_WIDTH - 40;
    cell.couponPriceLabel.font = SYSTEMFONT(45);
    NSString* priceStri;
    switch ([couponForm.discount_type integerValue])
    {
        case 1://代金券
            priceStri = [NSString stringWithFormat:@"￥%d",[couponForm.discount_num intValue]];
            cell.useableLimitLabel.text = [NSString stringWithFormat:@"%@",couponForm.discount_name];
            break;
            
//        case 2://满减券
//            priceStri = [NSString stringWithFormat:@"￥%d",[couponForm.value intValue]];
//            cell.useableLimitLabel.text = [NSString stringWithFormat:@"满%@可用",couponForm.validMoney];
//            break;
//            
//        case 3://项目券
//            priceStri = @" 项目券";
//            cell.couonTypeNameLabel.text = couponForm.name;
//            cell.useableLimitLabel.text = @"凭券到店消费";
//            cell.couponPriceLabel.font = SYSTEMFONT(30);
//            break;
            
        default:
            break;
    }
    
    //左上角价格
    CGSize priceSize = [PUtils calculateTitleSizeWithString:priceStri WithFont:cell.couponPriceLabel.font];
    cell.couponPriceLabelLayout.constant = priceSize.width + ([couponForm.discount_type integerValue] == 3 ? 10 : 0);
    cell.couponPriceLabel.text = priceStri;
    
    
    //门店名称
//    NSString* storeNameStr = couponForm.storeName;
//    int width = PJ_SCREEN_WIDTH - 40 - 80 - priceSize.width - 10;
//    CGSize storeNameSize = [storeNameStr boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: BOLDSYSTEMFONT(15)} context:nil].size;
//    cell.storeNameLabelLayoutheight.constant = storeNameSize.height;
//    cell.storeNameLabelLayoutWidth.constant = width;
//    cell.storeNameLabel.text = storeNameStr;
    
    //右下角有限期
    cell.receiveTimeLabel.text = couponForm.dead_time;
//    [cell setCellWithCouponType:_couponType andServiceType:![couponForm.validServiceId isEqualToString:@"0"]];
    cell.couponPriceLabel.keyWord = @"￥";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 10;
}
@end


@implementation CZJMyWalletCouponUnUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    _couponType = 0;
    _params = [@{@"discount_status":@(_couponType), @"page_num":@"1"}mutableCopy];
    [self getCouponListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

@implementation CZJMyWalletCouponUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    _couponType = 1;
    _params = [@{@"discount_status":@(_couponType), @"page_num":@"1"}mutableCopy];
    [self getCouponListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

@implementation CZJMyWalletCouponOutOfTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _couponType = 2;
    _params = [@{@"discount_status":@(_couponType), @"page_num":@"1"}mutableCopy];
    [self getCouponListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

