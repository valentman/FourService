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

@interface FSCommitOrderController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* _orderTypeAry;                     //支付方式（支付宝，微信，银联）
    __block CZJOrderTypeForm* _defaultOrderType;        //默认支付方式（为支付宝）
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
    return 4;
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
            return 1 + _orderTypeAry.count + 1;
            break;
            
        case 3:
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
            FSOrderContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderContactCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 1:
        {
            FSOrderProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderProductCell" forIndexPath:indexPath];
            [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DefaultPlaceHolderSquare];
            cell.productNamesLabel.text = @"一共3件商品、1项服务";
            cell.LabelOne.layer.borderColor = CZJTableViewBGColor.CGColor;
            cell.LabelOne.layer.borderWidth = 1;
            cell.LabelTwo.layer.borderColor = CZJTableViewBGColor.CGColor;
            cell.LabelTwo.layer.borderWidth = 1;
            return cell;
        }
            break;
            
        case 2:
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
            
        case 3:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabelLeading.constant = 20;
            cell.detailLabel.textColor = FSYellow;
            if (0 == indexPath.row)
            {
                cell.nameLabel.text = @"商品金额";
                cell.detailLabel.hidden = NO;
                cell.detailLabel.text = @"￥699";
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
            return 70;
            break;
            
        case 2:
            return 44;
            break;
            
        case 3:
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
            
            break;
            
        case 2:
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
            
        case 3:
            
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

- (IBAction)commitOrderAction:(id)sender {
}
@end
