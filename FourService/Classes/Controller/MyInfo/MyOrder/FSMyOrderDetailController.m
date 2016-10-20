//
//  FSMyOrderDetailController.m
//  FourService
//
//  Created by Joe.Pen on 10/4/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSMyOrderDetailController.h"
#import "FSOrderDetailNoCell.h"
#import "CZJOrderBuildingImagesCell.h"
#import "FSOrderDetailProductCell.h"
#import "CZJGeneralCell.h"
#import "FSServiceStoreCell.h"
#import "FSOrderDetailPayCell.h"
#import "FSOrderDetailTimeCell.h"
#import "FSBaseDataManager.h"

@interface FSMyOrderDetailController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    FSOrderDetailForm *orderDetailForm;
}
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSMyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getOrderDetailFromServer];
}

- (void)initDatas
{
    
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"订单详情";
    [self.myTableView reloadData];
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
        self.myTableView.backgroundColor = CZJNAVIBARBGCOLOR;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        
        NSArray* nibArys = @[@"FSOrderDetailNoCell",
                             @"CZJOrderBuildingImagesCell",
                             @"FSOrderDetailProductCell",
                             @"CZJGeneralCell",
                             @"FSServiceStoreCell",
                             @"FSOrderDetailPayCell",
                             @"FSOrderDetailTimeCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)getOrderDetailFromServer
{
    NSDictionary* params = @{@"order_id" : self.orderId};
    [FSBaseDataInstance getOrderDetail:params Success:^(id json) {
        DLog(@"%@", [json description]);
    } fail:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 4;
            break;
            
        case 2:
            return 1 + 1;
            break;
            
        case 3:
            return 1 + 1;
            break;
            
        case 4:
            return 1;
            break;
            
        case 5:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            FSOrderDetailNoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderDetailNoCell" forIndexPath:indexPath];
            cell.orderNoLable.text = orderDetailForm.order_id;
            cell.orderTypeLabel.text = orderDetailForm.service_type_name;
            cell.orderStateLabel.text = orderDetailForm.status;
            return cell;
        }
            break;
            
        case 1:
            if (0 == indexPath.row)
            {
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                [cell.headImgView setImage:IMAGENAMED(@"orderShop")];
                cell.nameLabel.text = orderDetailForm.shop_name;
                cell.arrowImg.hidden = YES;
                return cell;
            }
            if (1 == indexPath.row)
            {
                FSServiceStoreCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStoreCell" forIndexPath:indexPath];
                //门店图片
//                NSURL* imgUrl;
//                if (((FSStoreImageForm*)storeInfoForm.shop_image_list.firstObject).image_url)
//                {
//                    imgUrl = [NSURL URLWithString:ConnectString(kCZJServerAddr,((FSStoreImageForm*)storeInfoForm.shop_image_list.firstObject).image_url)];
//                }
//                [cell.storeImage sd_setImageWithURL:imgUrl placeholderImage:DefaultPlaceHolderSquare];
                
                //门店名称
                cell.storeNameLabel.text = orderDetailForm.shop_name;
                
                cell.discountPriceLabel.hidden = YES;
                cell.originPriceLabel.hidden = YES;
                
                //开门时间
                cell.openTimeLabel.text = @"08:00-18:30";
                
                //评价分数和单数
                cell.evaluateScoreLabel.text = @"5.0";
                cell.totalOrderLabel.text = [NSString stringWithFormat:@"/ %@单",@"300"];
                
                //地址距离
                cell.storeAddrLabel.text = @"成都市武侯区天仁路388号";
                cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",@"2.9" ];
                
                //门店类型
                cell.storeTypeLabel.text = @"快修店";
                
                //设置支付方式
                [cell setPaymentAvaiable:nil];
                
                return cell;
            }
            
            if (2 == indexPath.row)
            {
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                [cell.headImgView setImage:IMAGENAMED(@"shop_location")];
                cell.nameLabel.text = orderDetailForm.shop_address;
                return cell;
            }
            if (3 == indexPath.row)
            {
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                [cell.headImgView setImage:IMAGENAMED(@"shop_phone")];
                cell.nameLabel.text = orderDetailForm.shop_tel;
                return cell;
            }
            break;
            
        case 2:
            if (0 == indexPath.row)
            {
                CZJOrderBuildingImagesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJOrderBuildingImagesCell" forIndexPath:indexPath];
                cell.myTitleLabel.text = @"商品";
                cell.totalLabel.text = [NSString stringWithFormat:@"共%ld件",orderDetailForm.order_step.count];
                return cell;
            }
            else
            {
                FSOrderDetailProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderDetailProductCell" forIndexPath:indexPath];
                return cell;
            }
            break;
            
        case 3:
            if (0 == indexPath.row)
            {
                CZJOrderBuildingImagesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJOrderBuildingImagesCell" forIndexPath:indexPath];
                cell.myTitleLabel.text = @"服务";
                cell.totalLabel.hidden = YES;
                return cell;
            }
            else
            {
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                cell.detailLabel.text= @"319.00";
                cell.detailLabel.hidden = NO;
                cell.nameLabelLeading.constant = 15;
                cell.nameLabel.text = @"【人工费】机油+机滤安装费";
                cell.nameLabelWidth.constant = [PUtils calculateTitleSizeWithString:@"【人工费】机油+机滤安装费" WithFont:cell.nameLabel.font].width + 5;
                cell.arrowImg.hidden = YES;
                return cell;
            }
            break;
            
        case 4:
        {
            FSOrderDetailPayCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderDetailPayCell" forIndexPath:indexPath];
            cell.totalPrice.text = orderDetailForm.price;
            cell.couponPrice.text = @"￥0.00";
            cell.payPrice.text = orderDetailForm.price;
            return cell;
        }
            break;
            
        case 5:
        {
            FSOrderDetailTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderDetailTimeCell" forIndexPath:indexPath];
            cell.orderTimeLabel.text = orderDetailForm.pay_time;
            cell.orderPayType.text = orderDetailForm.pay_way;
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
            
        case 1:
            if (1 == indexPath.row)
            {
                return 130;
            }
            return 44;
            break;
            
        case 2:
            if (0 == indexPath.row)
            {
                return 38;
            }
            return 99;
            break;
            
        case 3:
            if (0 == indexPath.row)
            {
                return 38;
            }
            return 45;
            break;
            
        case 4:
            return 105;
            break;
            
        case 5:
            return 84;
            break;
            
        default:
            break;
    }
    return 0;
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
    switch (indexPath.section)
    {
        case 1:
            if (2 == indexPath.row)
            {
                
            }
            if (3 == indexPath.row)
            {
                [PUtils callHotLine:@"028-86889898" AndTarget:nil];
            }
            break;
            
        default:
            break;
    }
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
