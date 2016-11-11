//
//  FSPayMentController.m
//  FourService
//
//  Created by Joe.Pen on 05/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSPayMentController.h"
#import "FSBaseDataManager.h"
#import "FSOrderDetailNoCell.h"
#import "CZJGeneralCell.h"
#import "CZJGoodsAttentionCell.h"

@interface FSPayMentController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* _orderTypeAry;                     //支付方式（支付宝，微信，银联）
    __block CZJOrderTypeForm* _defaultOrderType;        //默认支付方式（为支付宝）
}

@property (strong, nonatomic)UITableView* myTableView;
@property (strong, nonatomic)UIButton *confirmBtn;
@end

@implementation FSPayMentController

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
    self.view.backgroundColor = WHITECOLOR;
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"确认支付";
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:FSBLUECOLOR];
    self.confirmBtn.layer.cornerRadius = 8;
    self.confirmBtn.clipsToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(actionPay:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.enabled = NO;
    
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
        self.myTableView.clipsToBounds = YES;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CLEARCOLOR;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        
        NSArray* nibArys = @[@"CZJGeneralCell",
                             @"FSOrderDetailNoCell",
                             @"CZJGoodsAttentionCell"];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section ||
        1 == section ||
        3 == section ||
        5 == section) {
        return 1;
    }
    else if (2 == section)
    {
        return 4;
    }
    else if (4 == section)
    {
        return _orderTypeAry.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            FSOrderDetailNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSOrderDetailNoCell" forIndexPath:indexPath];
            cell.orderNoLable.text = @"12341234";
            return cell;
        }
            break;
            
        case 1:
        {
            CZJGoodsAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGoodsAttentionCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 2:
        {
            CZJGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 3:
        {
            CZJGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 4:
        {
            if (indexPath.row == 0)
            {//优惠
                CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
                cell.arrowImg.hidden = YES;
                cell.detailLabel.hidden = NO;
                cell.nameLabelLeading.constant = 20;

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

                return cell;
            }
            else
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
        }
            break;
            
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmCell"];
                [cell addSubview:self.confirmBtn];
                [self.confirmBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
                cell.backgroundColor = CLEARCOLOR;
            }
            cell.separatorInset = HiddenCellSeparator;
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
    if (0 == indexPath.section ||
        3 == indexPath.section ) {
        return 44;
    }
    if (1 == indexPath.section) {
        return 100;
    }
    if (2 == indexPath.section) {
        return 30;
    }
    if (4 == indexPath.section)
    {
        if (0 == indexPath.row) {
            return 30;
        }
        return 60;
    }
    if (5 == indexPath.section) {
        return 70;
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
    
}

- (void)actionPay:(UIButton *)sender
{
    
}

@end
