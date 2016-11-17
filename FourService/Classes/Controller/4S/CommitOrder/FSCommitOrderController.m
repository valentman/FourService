//
//  FSCommitOrderController.m
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSCommitOrderController.h"
#import "CZJGeneralCell.h"
#import "CZJOrderTypeCell.h"
#import "FSOrderContactCell.h"
#import "FSOrderProductCell.h"
#import "FSBaseDataManager.h"
#import "FSStepServiceListController.h"
#import "CPEvaluateSuccessController.h"
#import "OpenShareHeader.h"
#import "CZJPaymentManager.h"
#import "FSMyCarListController.h"



@implementation FSCommitOrderForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"step_list" : @"FSCommitStepForm"};
}
@end

@implementation FSCommitStepForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"product_list" : @"FSCommitProductForm"};
}
@end

@implementation FSCommitProductForm
@end


@interface FSCommitOrderController ()
<
UITableViewDelegate,
UITableViewDataSource,
FSMyCarListControllerDelegate
>
{
    NSArray* _orderTypeAry;                     //支付方式（支付宝，微信，银联）
    __block CZJOrderTypeForm* _defaultOrderType;        //默认支付方式（为支付宝）
    FSCommitOrderForm* commitOrderForm;
    FSOrderContactCell* contactCell;
    FSCarListForm *commitCarForm;
    
    NSInteger productNum;
    NSInteger serviceNum;
    float totalPrice;
    float otherPrice;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *settleView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitOrderAction:(id)sender;
@end

@implementation FSCommitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
}

- (void)initDatas
{
    
    for (FSCarListForm *carform in FSBaseDataInstance.userInfoForm.car_list)
    {
        if (carform.is_default)
        {
            commitCarForm = carform;
            break;
        }
    }
    if (!commitCarForm)
    {
        commitCarForm = FSBaseDataInstance.userInfoForm.car_list.firstObject;
    }
    
    //支付方式
    _orderTypeAry = FSBaseDataInstance.orderPaymentTypeAry;
    for (CZJOrderTypeForm* form in _orderTypeAry)
    {
        if (form.isSelect)
        {
            _defaultOrderType = form;
            continue;
        }
    }
    serviceNum = 0;
    productNum = 0;
    
    commitOrderForm = [[FSCommitOrderForm alloc] init];
    commitOrderForm.shop_id = self.shopId;
    commitOrderForm.service_type_id = self.serviceTypeId;
    commitOrderForm.car_id = @"1";
    commitOrderForm.remark = @"";
    
    NSMutableArray* tmpStepAry = [NSMutableArray array];
    for (FSServiceStepForm* stepForm in self.orderServiceAry)
    {
        FSCommitStepForm* stepForm2 = [FSCommitStepForm objectWithKeyValues:stepForm.keyValues];
        [tmpStepAry addObject:stepForm2];
        if (stepForm.is_expand)
        {
            serviceNum++;
            productNum += stepForm.product_list.count;
        }
    }
    commitOrderForm.step_list = tmpStepAry;
    
    DLog(@"%@",commitOrderForm.keyValues);
    
    totalPrice = 0;
    for (FSServiceStepForm* productForm in self.orderServiceAry)
    {
        float price = 0;
        for (FSServiceStepProductForm* stepProductForm in productForm.product_list)
        {
            price += [stepProductForm.sale_price floatValue]*[stepProductForm.product_buy_num floatValue];
        }
        productForm.stepPrice = price;
        
        if (productForm.is_expand)
        {
            totalPrice += productForm.stepPrice;
        }
    }
    otherPrice = 30;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", otherPrice + totalPrice];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"订单确认";
    self.naviBarView.mainTitleLabel.textColor = WHITECOLOR;
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    
    [self.myTableView reloadData];
}

- (UITableView*)myTableView
{
    _myTableView.tableFooterView = [[UIView alloc]init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView.backgroundColor = CZJTableViewBGColor;
    
    NSArray* nibArys = @[@"CZJGeneralCell",
                         @"CZJOrderTypeCell",
                         @"FSOrderContactCell",
                         @"FSOrderProductCell"
                         ];
    
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [_myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
    return _myTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 1 + _orderTypeAry.count + 1;
            break;
            
        case 4:
            return 2;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            contactCell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderContactCell" forIndexPath:indexPath];
            
            contactCell.contactNameLabel.text = FSBaseDataInstance.userInfoForm.chinese_name;
            contactCell.contactPhoneLabel.text = FSBaseDataInstance.userInfoForm.customer_pho;
            return contactCell;
        }
            break;
            
        case 1:
        {
            CZJGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.textColor = FSBLUECOLOR;
            cell.nameLabelWidth.constant = PJ_SCREEN_WIDTH - 150;
            cell.nameLabelLeading.constant = 15;
            cell.nameLabel.font = SYSTEMFONT(15);
            NSString *carInfo = [NSString stringWithFormat:@"%@ %@",commitCarForm.car_model_name,commitCarForm.car_type_name];
            cell.nameLabel.text = carInfo;
            cell.detailLabel.text = @"点击更换";
            return cell;
        }
            break;
            
        case 2:
        {
            FSOrderProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderProductCell" forIndexPath:indexPath];
            [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DefaultPlaceHolderSquare];
            cell.productNamesLabel.text = [NSString stringWithFormat:@"一共%ld件商品、%ld项服务",productNum,serviceNum];
            cell.LabelOne.layer.borderColor = CZJTableViewBGColor.CGColor;
            cell.LabelOne.layer.borderWidth = 1;
            cell.LabelTwo.layer.borderColor = CZJTableViewBGColor.CGColor;
            cell.LabelTwo.layer.borderWidth = 1;
            return cell;
        }
            break;
            
        case 3:
        {
            if (indexPath.row >=1 &&
                indexPath.row <= _orderTypeAry.count)
            {//支付方式Title
                CZJOrderTypeForm* ordertypeForm = _orderTypeAry[indexPath.row - 1];
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                cell.arrowImg.hidden = NO;
                [cell.arrowImg setImage:nil];
                cell.headImgView.hidden = NO;
                [cell.headImgView setImage:nil];
                cell.imageViewWidth.constant = 21;
                cell.imageViewHeight.constant = 21;
                cell.arrowImageWidth.constant = 21;
                cell.arrowImageHeight.constant = 21;
                cell.nameLabel.text = ordertypeForm.orderTypeName;
                
                [cell.arrowImg setImage:IMAGENAMED((ordertypeForm.isSelect ? @"shop_btn_sel" : @"shop_btn_unSel"))];
                [cell.headImgView setImage:IMAGENAMED(ordertypeForm.isSelect ? ordertypeForm.orderTypeImgSelect : ordertypeForm.orderTypeImg)];
                
                if (indexPath.row == _orderTypeAry.count)
                {
                    [cell setSeparatorViewHidden:NO];
                }
                return  cell;
            }
            else
            {//优惠
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                cell.arrowImg.hidden = YES;
                cell.detailLabel.hidden = NO;
                cell.nameLabelLeading.constant = 20;
                if (0 == indexPath.row)
                {
                    NSString* typeStr;
                    for (CZJOrderTypeForm* form in _orderTypeAry)
                    {
                        if (form.isSelect)
                        {
                            typeStr = form.orderTypeName;
                            break;
                        }
                    }
                    cell.nameLabel.text = @"支付方式";
                    cell.detailLabel.text = typeStr;
                    [cell setSeparatorViewHidden:NO];
                }
                else
                {
                    cell.nameLabel.text = @"优惠";
                    cell.detailLabel.text = @"没有可用的优惠券";
                }

                return cell;
            }
            
        }
            break;
            
        case 4:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabelLeading.constant = 20;
            cell.detailLabel.textColor = FSYellow;
            cell.arrowImg.hidden = YES;
            if (0 == indexPath.row)
            {

                cell.nameLabel.text = @"商品金额";
                cell.detailLabel.hidden = NO;
               
                cell.detailLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
                cell.detailLabel.textColor = FSYellow;
                cell.detailLabel.font = SYSTEMFONT(14);
            }
            else
            {
                cell.nameLabel.text = @"其他费用";
                cell.detailLabel.hidden = NO;
                cell.detailLabel.text = [NSString stringWithFormat:@"￥%.2f",otherPrice];
                cell.detailLabel.textColor = FSYellow;
                cell.detailLabel.font = SYSTEMFONT(14);
            }
            [cell setSeparatorViewHidden:NO];
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
    switch (indexPath.section)
    {
        case 0:
            return 54;
            break;
            
        case 1:
            return 54;
            break;
            
        case 2:
            return 70;
            break;
            
        case 3:
            return 44;
            break;
            
        case 4:
            return 44;
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
        return 10;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            
            break;
            
        case 1:
        {
            FSMyCarListController *carlist = (FSMyCarListController *)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"carListSBID"];
            carlist.delegate = self;
            carlist.carFromType = FSCarListFromTypeCommitOrder;
            [self.navigationController pushViewController:carlist animated:YES];
        }
            break;
            
        case 2:
        {
            FSStepServiceListController* servicelist = [[FSStepServiceListController alloc] init];
            servicelist.orderServiceAry = self.orderServiceAry;
            [self.navigationController pushViewController:servicelist animated:YES];
        }
            break;
            
        case 3:
        {
            if (indexPath.row >=1 &&
                indexPath.row <= _orderTypeAry.count)
            {
                CZJOrderTypeForm* ordertypeForm = _orderTypeAry[indexPath.row - 1];
                for (CZJOrderTypeForm* form in _orderTypeAry)
                {
                    form.isSelect = NO;
                    if ([form.orderTypeName isEqualToString:ordertypeForm.orderTypeName])
                    {
                        form.isSelect = YES;
                    }
                }
                [tableView reloadData];
            }
        }
            break;
            
        case 4:
            
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

- (IBAction)commitOrderAction:(id)sender
{
    
    if (![PUtils isMobileNumber:contactCell.contactPhoneLabel.text]) {
        [PUtils tipWithText:@"请填写正确的手机号码" andView:nil];
        return;
    }
    
    if ([PUtils isBlankString:contactCell.contactNameLabel.text]) {
        [PUtils tipWithText:@"请填写正确的联系人" andView:nil];
        return;
    }
    
    NSString* currentOrdertypeName;
    for (CZJOrderTypeForm* form in _orderTypeAry)
    {
        if (form.isSelect)
        {
            currentOrdertypeName = form.orderTypeName;
            break;
        }
    }
    if ([currentOrdertypeName isEqualToString:@"到店支付"]) {
        weaky(self);
        [FSBaseDataInstance submitOrder:commitOrderForm.keyValues Success:^(id json) {
            CPEvaluateSuccessController* success = [[CPEvaluateSuccessController alloc] init];
            [weakSelf.navigationController pushViewController:success animated:YES];
        } fail:nil];
    }
    
    
    
    
    [self checkPay:currentOrdertypeName];
    
    CZJPaymentOrderForm* paymentOrderForm = [[CZJPaymentOrderForm alloc] init];
    paymentOrderForm.order_no = @"1231234";
    paymentOrderForm.order_name = @"测试订单";
    paymentOrderForm.order_description = @"支付宝你个SB";
    paymentOrderForm.order_price = @"0.1";
    paymentOrderForm.order_for = @"pay";
    weaky(self);
    if ([currentOrdertypeName isEqualToString:@"微信支付"])
    {
        DLog(@"提交订单页面请求微信支付");
        [CZJPaymentInstance weixinPay:weakSelf OrderInfo:paymentOrderForm Success:^(NSDictionary *message) {
        } Fail:^(NSDictionary *message, NSError *error) {
            [PUtils tipWithText:@"微信支付失败" withCompeletHandler:^{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiJumpToOrderList object:nil];
                }];
            }];
        }];
    }
    if ([currentOrdertypeName isEqualToString:@"支付宝支付"])
    {
        DLog(@"提交订单页面请求支付宝支付");
        [CZJPaymentInstance aliPay:weakSelf OrderInfo:paymentOrderForm Success:^(NSDictionary *message) {
        } Fail:^(NSDictionary *message, NSError *error) {
            [PUtils tipWithText:@"支付宝支付失败" withCompeletHandler:^{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kCZJNotifiJumpToOrderList object:nil];
                }];
                DLog(@"支付宝支付失败");
            }];
        }];
    }
    
    if ([currentOrdertypeName isEqualToString:@"支付宝支付"])
    {
        
    }
    if ([currentOrdertypeName isEqualToString:@"微信支付"])
    {
        
    }
}

- (void)checkPay:(NSString*)_orderTypeName
{
    if ([_orderTypeName isEqualToString:@"微信支付"] &&
        ![OpenShare isWeixinInstalled])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIAlertView* alertview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的手机未安装微信客户端，请安装后支付" delegate:window cancelButtonTitle:@"收到" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    if ([_orderTypeName isEqualToString:@"支付宝支付"] &&
        ![OpenShare isAlipayInstalled])
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIAlertView* alertview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的手机未安装支付宝客户端，请安装后支付" delegate:window cancelButtonTitle:@"收到" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    
}

#pragma mark- FSMyCarListControllerDelegate
- (void)selectOneCar:(FSCarListForm *)carForm
{
    commitCarForm = carForm;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}



@end
