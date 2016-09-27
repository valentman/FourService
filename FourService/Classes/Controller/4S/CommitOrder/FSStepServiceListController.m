//
//  FSStepServiceListController.m
//  FourService
//
//  Created by Joe.Pen on 9/27/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStepServiceListController.h"
#import "FSServiceStepCell.h"
#import "FSServiceStepGoodsCell.h"

@interface FSStepServiceListController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView* myTableView;
@end

@implementation FSStepServiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"商品服务列表";
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        
        NSArray* nibArys = @[@"FSServiceStepCell",
                             @"FSServiceStepGoodsCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderServiceAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FSServiceStepForm* stepForm = self.orderServiceAry[section];
    return stepForm.is_expand ? (stepForm.product_list.count + 1) : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSServiceStepForm* stepForm = self.orderServiceAry[indexPath.section];
    
    if (stepForm.is_expand && indexPath.row > 0)
    {
        FSServiceStepProductForm* stepProductForm = stepForm.product_list[indexPath.row - 1];
        FSServiceStepGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepGoodsCell" forIndexPath:indexPath];
        cell.cellIndex = indexPath;
        [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:DefaultPlaceHolderSquare];
        cell.productNameLabel.text = stepProductForm.product_name;
        cell.productNumLabel.text = [NSString stringWithFormat:@"×%@",stepProductForm.product_buy_num];
        cell.productPriceLabel.text = stepProductForm.sale_price;
        
        [cell setChooseCount:[stepProductForm.product_buy_num integerValue]];
        cell.operateView.hidden = NO;
        cell.productInfoView.hidden = stepForm.is_Edit;
        if (indexPath.row == stepForm.product_list.count)
        {
            [cell setSeparatorViewHidden:NO];
        }
        return cell;
    }
    else
    {
        FSServiceStepCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepCell" forIndexPath:indexPath];
        if (!stepForm.is_expand)
        {
            [cell setSeparatorViewHidden:NO];
        }
        else
        {
            [cell setSeparatorViewHidden:YES];
            cell.separatorInset = IndentCellSeparator(0);
        }
        cell.cellIndex = indexPath;
        cell.editView.hidden = YES;
        cell.stepImageButton.selected = stepForm.is_expand;
        cell.stepSelectBtn.selected = stepForm.is_expand;
        cell.stemNameLabel.text = stepForm.step_name;
        cell.stepDescLabel.text = stepForm.step_desc;
        cell.stepPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",stepForm.stepPrice];
        return cell;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        return 46;
    }
    else
    {
        return 85;
    }
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
@end
