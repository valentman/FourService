//
//  FSMyCarListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyCarListController.h"
#import "CZJMyCarListCell.h"
#import "CZJGeneralCell.h"
#import "CZJCarBrandChooseController.h"
#import "FSBaseDataManager.h"
#import "CZJAddMyCarController.h"
#import "FSAddMyCarButtomView.h"

@interface FSMyCarListController ()
<
UITableViewDataSource,
UITableViewDelegate,
CZJMyCarListCellDelegate
>
@property (strong, nonatomic) UITableView *myTableView;

- (IBAction)addMyCarAction:(id)sender;
@end

@implementation FSMyCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getCarListFromServer];
}

- (void)initDatas
{
    self.carListAry = [FSBaseDataInstance.userInfoForm.car_list mutableCopy];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"我的车辆";
    
    FSAddMyCarButtomView* generalCell = [PUtils getXibViewByName:@"FSAddMyCarButtomView"];
    generalCell.frame = CGRectMake(0, PJ_SCREEN_HEIGHT - 105, PJ_SCREEN_WIDTH, 55);

    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, generalCell.size.width, generalCell.size.height);
    [addBtn addTarget:self action:@selector(addMyCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [generalCell addSubview:addBtn];
    [self.view addSubview:generalCell];
    
    //消息中心表格视图
    CGRect tableRect = CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64 - 105);
    self.myTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.clipsToBounds = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.backgroundColor = CLEARCOLOR;
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
    return self.carListAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCarListForm* carListForm = self.carListAry[indexPath.section];
    
    CZJMyCarListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJMyCarListCell" forIndexPath:indexPath];
    [cell.brandImg sd_setImageWithURL:[NSURL URLWithString:carListForm.icon] placeholderImage:DefaultPlaceHolderRectangle];
    cell.tag  = indexPath.section;
    cell.carNameLabel.text = carListForm.car_type_name;
    cell.carModelLabel.text = carListForm.car_model_name;
    cell.carNumberPlate.text = carListForm.car_num;
    cell.setDefaultBtn.selected = carListForm.is_default;
    cell.delegate = self;
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
    FSCarListForm* carListForm = self.carListAry[indexPath.section];
    switch (self.carFromType) {
        case FSCarListFromTypeGeneral:
        {
            
            CZJAddMyCarController* addCarVC = (CZJAddMyCarController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"addMyCarSBID"];
            addCarVC.carForm = carListForm;
            [self.navigationController pushViewController:addCarVC animated:YES];
        }
            break;
            
        case FSCarListFromTypeCommitOrder:
        {
            if ([self.delegate respondsToSelector:@selector(selectOneCar:)])
            {
                [self.delegate selectOneCar:carListForm];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)addMyCarAction:(id)sender
{
    CZJCarBrandChooseController *svc = [[CZJCarBrandChooseController alloc] initWithType:CZJCarListTypeGeneral];
    svc.viewFrom = @"carList";
    [self.navigationController pushViewController:svc animated:YES];
}


#pragma mark- CZJMyCarListCellDelegate
- (void)deleteMyCarActionCallBack:(id)sender
{
    FSCarListForm* carForm = _carListAry[((UIButton*)sender).tag];
    __weak typeof(self) weakSelf = self;
    [self showFSAlertView:@"确认删除此爱车么？" andConfirmHandler:^{
        [FSBaseDataInstance removeMyCar:@{@"car_id" : carForm.car_id} Success:^(id json) {
            [PUtils tipWithText:@"删除爱车成功" andView:self.view];
            [_carListAry removeObjectAtIndex:((UIButton*)sender).tag];
            [weakSelf getCarListFromServer];
        } fail:^{
            
        }];
        [weakSelf hideWindow];
    } andCancleHandler:nil];
}

- (void)setDefaultAcitonCallBack:(id)sender
{
    FSCarListForm* carForm = _carListAry[((UIButton*)sender).tag];
    __weak typeof(self) weakSelf = self;
        
    [FSBaseDataInstance setDefaultCar:@{@"car_id" : carForm.car_id,
                                        @"is_default" : @"1"} Success:^(id json) {
        [PUtils tipWithText:@"设置默认成功" andView:self.view];
        for (FSCarListForm* tmpForm in _carListAry)
        {
            tmpForm.is_default = NO;
            if (tmpForm.car_id == carForm.car_id)
            {
                tmpForm.is_default = YES;
            }
        }
        [weakSelf getCarListFromServer];
    } fail:^{
        
    }];
}

@end
