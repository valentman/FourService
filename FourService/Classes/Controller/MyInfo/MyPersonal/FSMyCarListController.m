//
//  FSMyCarListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyCarListController.h"
#import "CZJMyCarListCell.h"
#import "CZJCarBrandChooseController.h"
#import "FSBaseDataManager.h"

@interface FSMyCarListController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (strong, nonatomic) UITableView *myTableView;

- (IBAction)addMyCarAction:(id)sender;
@end

@implementation FSMyCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
}

- (void)initDatas
{
}

- (void)initViews
{
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"我的车辆";
    
    //消息中心表格视图
    CGRect tableRect = CGRectMake(0, 64 + 46 + 10, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64 - 56);
    self.myTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"CZJMyCarListCell"];
    
    for (id cells in nibArys)
    {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
}

- (void)getCarListFromServer
{
    if (self.carListAry.count <= 0)
    {
        [self.myTableView reloadData];
        self.myTableView.hidden = YES;
        [PUtils showNoDataAlertViewOnTarget:self.view withPromptString:@"您还没有爱车，去添加吧/(ToT)/~~"];
    }
    else
    {
        [PUtils removeNoDataAlertViewFromTarget:self.view];
        self.myTableView.hidden = NO;
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        [self.myTableView reloadData];
    }
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
    return self.carListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCarListForm* carListForm = self.carListAry[indexPath.row];
    
    CZJMyCarListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyCarListCell" forIndexPath:indexPath];
    [cell.brandImg sd_setImageWithURL:[NSURL URLWithString:carListForm.logo] placeholderImage:DefaultPlaceHolderRectangle];
    cell.carNameLabel.text = carListForm.car_type_name;
    cell.carModelLabel.text = carListForm.car_model_name;
    cell.carNumberPlate.text = carListForm.car_num;
    cell.setDefaultBtn.selected = carListForm.is_default;
    if (indexPath.section == (self.carListAry.count - 1))
        cell.separatorInset = HiddenCellSeparator;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136;
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

- (IBAction)addMyCarAction:(id)sender
{
    CZJCarBrandChooseController *svc = [[CZJCarBrandChooseController alloc] initWithType:CZJCarListTypeGeneral];
    svc.viewFrom = @"carList";
    [self.navigationController pushViewController:svc animated:YES];
}

@end
