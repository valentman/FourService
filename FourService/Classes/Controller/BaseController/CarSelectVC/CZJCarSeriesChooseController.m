//
//  CZJCarSeriesChooseController.m
//  CZJShop
//
//  Created by Joe.Pen on 12/11/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "CZJCarSeriesChooseController.h"
#import "FSBaseDataManager.h"
#import "CZJCarModelChooseController.h"

static NSString *const CarSesCellIdentifierID = @"CarSesCellIdentifierID";

@interface CZJCarSeriesChooseController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray *serialAry;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *curCarBrandLogo;
@property (nonatomic, strong) UILabel* curCarBrandName;
@end

@implementation CZJCarSeriesChooseController
@synthesize curCarBrandLogo = _curCarBrandLogo;
@synthesize curCarBrandName = _curCarBrandName;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
    [self getDataFromServer];
}

- (void)initData
{
    serialAry = [[FSBaseDataInstance carForm] carSeries];
}

- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    [self addCZJNaviBarViewWithNotHiddenNavi:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"选择车系";
    
    //顶部汽车品牌图标和名称
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBar_HEIGHT + NavigationBar_HEIGHT, PJ_SCREEN_WIDTH, 64)];
    [self.topView setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.topView];
    //品牌logo
    _curCarBrandLogo = [[UIImageView alloc]initWithFrame:CGRectMake(14,StatusBar_HEIGHT + NavigationBar_HEIGHT + 5, 54 , 54)];
    [_curCarBrandLogo sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, self.carBrand.icon)]
                        placeholderImage:DefaultPlaceHolderSquare
                               completed:nil];
    [self.view addSubview:_curCarBrandLogo];
    //品牌名
    _curCarBrandName = [[UILabel alloc]initWithFrame:CGRectMake(80,StatusBar_HEIGHT + NavigationBar_HEIGHT + 20, 200 , 24)];
    _curCarBrandName.textColor = [UIColor grayColor];
    _curCarBrandName.font = [UIFont systemFontOfSize:16];
    _curCarBrandName.textAlignment = NSTextAlignmentLeft;
    _curCarBrandName.text = self.carBrand.car_brand_name;
    [self.view addSubview:_curCarBrandName];
    
    //列表
    NSInteger width = PJ_SCREEN_WIDTH - (CZJCarListTypeFilter == _carlistType ? kMGLeftSpace  : 0);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 64, width, PJ_SCREEN_HEIGHT - 128)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

- (void)getDataFromServer
{
    [MBProgressHUD showHUDAddedTo: self.view animated:YES];
    [FSBaseDataInstance loadCarSeriesWithBrandId:self.carBrand.car_brand_id BrandName:self.carBrand.car_brand_name Success:^(){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self initData];
        [self.tableView reloadData];
    } fail:^(){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [serialAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CarSesCellIdentifierID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CarSesCellIdentifierID];
        UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, PJ_SCREEN_WIDTH - 75, 18)];
        nameLabel.font = SYSTEMFONT(14);
        [nameLabel setTag:1999];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:nameLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CarSeriesForm* obj = [serialAry objectAtIndex:indexPath.row];
    ((UILabel*)VIEWWITHTAG(cell, 1999)).text = obj.car_model_name;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarSeriesForm* obj = [serialAry objectAtIndex:indexPath.row];
    _currentSelect = obj;
    
    [FSBaseDataInstance setCarSerialForm:obj];
    
    CZJCarModelChooseController *svc = [[CZJCarModelChooseController alloc] initWithType:_carlistType];
    svc.carSeries = _currentSelect;
    svc.carBrand = _carBrand;
    [self.navigationController pushViewController:svc animated:YES];

}

@end
