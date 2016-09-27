//
//  FSServiceStepController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceStepController.h"
#import "FSBaseDataManager.h"
#import "FSServiceStepCell.h"
#import "FSServiceStepGoodsCell.h"
#import "FSStoreInfoCell.h"
#import "CZJGeneralCell.h"
#import "CZJOrderListPayCell.h"
#import "FSPageCell.h"
#import "FSGoodsDetailController.h"
#import "FSCommitOrderController.h"
#import "FSProductChangeController.h"

@interface FSServiceStepController ()
<
UITableViewDelegate,
UITableViewDataSource,
CZJOrderListPayCellDelegate,
FSPageCellDelegate,
FSServiceStepGoodsDelegate,
FSProductChangeDelegate
>
@property (strong, nonatomic) __block NSMutableArray* serviceStepAry;
@property (strong, nonatomic) __block NSMutableArray* serviceTypeAry;
@property (strong, nonatomic) __block NSMutableArray* titleArray;
@property (assign, nonatomic) NSInteger currentSelectIndex;
@property (strong, nonatomic)UITableView* myTableView;
@property (strong, nonatomic) CZJOrderListPayCell* payCell;
@end

@implementation FSServiceStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getDataFromServer];
}

- (void)initDatas
{
    _currentSelectIndex = 0;
    _serviceStepAry = [NSMutableArray array];
    _serviceTypeAry = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"选择项目";
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    [self.naviBarView.btnMore setBackgroundImage:nil forState:UIControlStateNormal];
    [self.naviBarView.btnMore setImage:IMAGENAMED(@"shop_share") forState:UIControlStateNormal];
    self.naviBarView.btnMore.hidden = NO;
    
    _payCell = [PUtils getXibViewByName:@"CZJOrderListPayCell"];
    _payCell.frame = CGRectMake(0, PJ_SCREEN_HEIGHT - 50, PJ_SCREEN_WIDTH, 50);
    _payCell.delegate = self;
    [self.view addSubview:_payCell];
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT - 50) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.clipsToBounds = NO;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CZJTableViewBGColor;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        NSArray* nibArys = @[@"FSServiceStepCell",
                             @"FSServiceStepGoodsCell",
                             @"FSStoreInfoCell",
                             @"CZJGeneralCell",
                             @"FSPageCell"];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)getDataFromServer
{
    NSDictionary* params = @{@"shop_service_type_id" : self.serviceID, @"shop_id" : self.shopID};
    __weak typeof (self) weakSelf = self;
    [FSBaseDataInstance getServiceStepList:params success:^(id json) {
        DLog(@"%@",[json description]);
        NSArray* tmpAry = [json valueForKey:kResoponData];
        _serviceTypeAry = [[FSServiceSegmentTypeForm objectArrayWithKeyValuesArray:tmpAry] mutableCopy];
        [weakSelf dealWithStepAry];
        [weakSelf.myTableView reloadData];
    } fail:^{
        
    }];
}

- (void)dealWithStepAry
{
    for (FSServiceSegmentTypeForm* form in _serviceTypeAry)
    {
        NSDictionary* dict = @{kSegmentViewMainTitleKey : form.item_name,
                               kSegmentViewSubTitleKey : form.item_desc};
        
        [_titleArray addObject:dict];
    }
    _serviceStepAry = [((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list mutableCopy];
    
    [self calculateTotalSelectedServicePrice];
}

- (void)calculateTotalSelectedServicePrice
{
    float totalPrice = 0;
    for (FSServiceStepForm* productForm in _serviceStepAry)
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
    _payCell.orderMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    _payCell.orderButton.enabled = YES;
    [_payCell.orderButton setBackgroundColor:FSBLUECOLOR2];
    if (totalPrice == 0)
    {
        _payCell.orderButton.enabled = NO;
        [_payCell.orderButton setBackgroundColor:CZJGRAYCOLOR];
    }
    
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, _serviceStepAry.count)] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _serviceStepAry.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    else if (1 == section)
    {
        return 2;
    }
    else if (2 == section)
    {
        return 1;
    }
    else
    {
        FSServiceStepForm* stepForm = _serviceStepAry[section - 3];
        return stepForm.is_expand ? (stepForm.product_list.count + 1) : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            
            if (0 == indexPath.row)
            {
                FSStoreInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSStoreInfoCell" forIndexPath:indexPath];
                
                [cell.storeBgImageView sd_setImageWithURL:[NSURL URLWithString:@"https://img7-tuhu-cn.alikunlun.com/Images/Marketing/Shops/c63b293d-f057-4311-bb7a-4c1d35fda13d.jpg@230w_230h_100Q.jpg"]];
                return cell;
            }
        }
            break;
            
        case 1:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            if (0 == indexPath.row)
            {
                [cell.headImgView setImage:IMAGENAMED(@"shop_location")];
                cell.nameLabel.text = @"成都市天仁路399号";
            }
            if (1 == indexPath.row)
            {
                [cell.headImgView setImage:IMAGENAMED(@"shop_phone")];
                cell.nameLabel.text = @"028-86889898";
            }
            return cell;
        }
            break;
            
        case 2:
        {
            FSPageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSPageCell" forIndexPath:indexPath];
            DLog(@"FSPageCell:%@",cell);
            [cell setTitleArray:_titleArray];
            [cell setCurrentTouchIndex:_currentSelectIndex];
            [cell setSeparatorViewHidden:NO];
            cell.delegate = self;
            return cell;
        }
            break;
            
        default:
        {
            FSServiceStepForm* stepForm = _serviceStepAry[indexPath.section - 3];
            
            if (stepForm.is_expand && indexPath.row > 0)
            {
                FSServiceStepProductForm* stepProductForm = stepForm.product_list[indexPath.row - 1];
                FSServiceStepGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepGoodsCell" forIndexPath:indexPath];
                cell.delegate = self;
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
                cell.editView.hidden = !stepForm.is_expand;
                cell.stepImageButton.selected = stepForm.is_expand;
                cell.stepSelectBtn.selected = stepForm.is_expand;
                cell.stemNameLabel.text = stepForm.step_name;
                cell.stepDescLabel.text = stepForm.step_desc;
                cell.stepPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",stepForm.stepPrice];
                [cell.editBtn addTarget:self action:@selector(stepEdit:) forControlEvents:UIControlEventTouchUpInside];
                [cell.acceptBtn addTarget:self action:@selector(stepAccept:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
            break;
    }
    return nil;
}

- (void)stepEdit:(UIButton*)sender
{
    id suerview1 = [sender superview];
    id superview2 = [suerview1 superview];
    id superView3 = [superview2 superview];
    if ([superView3 isKindOfClass:[FSServiceStepCell class]])
    {
        NSIndexPath* indepath = ((FSServiceStepCell*)superView3).cellIndex;
        FSServiceStepForm* stepForm = _serviceStepAry[indepath.section - 3];
        stepForm.is_Edit = YES;
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, _serviceStepAry.count)] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)stepAccept:(id)sender
{
    id suerview1 = [sender superview];
    id superview2 = [suerview1 superview];
    id superView3 = [superview2 superview];
    if ([superView3 isKindOfClass:[FSServiceStepCell class]])
    {
        NSIndexPath* indepath = ((FSServiceStepCell*)superView3).cellIndex;
        FSServiceStepForm* stepForm = _serviceStepAry[indepath.section - 3];
        stepForm.is_Edit = NO;
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, _serviceStepAry.count)] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return 167;
            break;
            
        case 1:
        case 2:
            return 46;
            break;
            
        default:
            if (0 == indexPath.row)
            {
                return 46;
            }
            else
            {
                return 85;
            }
            break;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (1 == section || 2 == section)
    {
        return 10;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sbIdentifer;
    id senderData;
    switch (indexPath.section)
    {
        case 0:
            sbIdentifer = @"segueToStoreDetail";
            break;
            
        case 1:
            if (0 == indexPath.row)
            {
                sbIdentifer = @"segueToStoreMap";
            }
            if (1 == indexPath.row)
            {
                [PUtils callHotLine:@"028-86889898" AndTarget:nil];
            }
            break;

        default:
        {
            FSServiceStepForm* stepForm = _serviceStepAry[indexPath.section - 3];
            if (stepForm.is_expand && indexPath.row > 0)
            {
                sbIdentifer = @"segueToGoodsDetail";
                senderData = (FSServiceStepProductForm*)stepForm.product_list[indexPath.row - 1];
            }
            else
            {
                stepForm.is_expand = !stepForm.is_expand;
                [self calculateTotalSelectedServicePrice];
            }
        }
            break;
    }
    if (sbIdentifer)
        [self performSegueWithIdentifier:sbIdentifer sender:senderData];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 2 && indexPath.row > 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 2 && indexPath.row > 0)
    {
        return @"四川汉子";
    }
    return @"";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
    }
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone: {
            DLog(@"no");
            break;
        }
        case UITableViewCellEditingStyleDelete: {
            DLog(@"dele");
            break;
        }
        case UITableViewCellEditingStyleInsert: {
            DLog(@"inset");
            break;
        }
    }
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog();
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog();
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToGoodsDetail"])
    {
        FSGoodsDetailController* goodsDetail = segue.destinationViewController;
        goodsDetail.productForm = sender;
    }
    if ([segue.identifier isEqualToString:@"segueToCommitOrder"])
    {
        FSCommitOrderController* commitOrder = segue.destinationViewController;
        commitOrder.orderServiceAry = sender;
    }
}


#pragma mark- FSPageCellDelegate
- (void)segmentButtonTouchHandle:(NSInteger)toucheIndex
{
    _currentSelectIndex = toucheIndex;
    [_serviceStepAry removeAllObjects];
    _serviceStepAry = [((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list mutableCopy];
    [self calculateTotalSelectedServicePrice];
}


#pragma mark- FSServiceStepGoodsDelegate
- (void)deleteProduct:(NSIndexPath*)indexPath
{
    iLog(@"delete:%ld, %ld",indexPath.section,indexPath.row);
    [_serviceStepAry removeAllObjects];
    FSServiceStepForm* stepForm = ((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list[indexPath.section - 3];
    [stepForm.product_list removeObjectAtIndex:indexPath.row - 1];
    _serviceStepAry = [((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list mutableCopy];
    [self calculateTotalSelectedServicePrice];
}

- (void)changeProduct:(NSIndexPath*)indexPath
{
    iLog(@"change:%ld, %ld",indexPath.section,indexPath.row);
    FSServiceStepProductForm* stepProduct = ((FSServiceStepForm*)_serviceStepAry[indexPath.section - 3]).product_list[indexPath.row - 1];
    FSProductChangeController* productVC = [[FSProductChangeController alloc] init];
    productVC.subTypeId = stepProduct.sub_type_id;
    productVC.productItem = stepProduct.product_item_id;
    productVC.delegate = self;
    productVC.cellIndexPath = indexPath;
    [self.navigationController pushViewController:productVC animated:YES];
    
    FSServiceStepForm* stepForm = _serviceStepAry[indexPath.section - 3];
    stepForm.is_Edit = NO;
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, _serviceStepAry.count)] withRowAnimation:UITableViewRowAnimationFade];

}

- (void)updateProductNum:(NSInteger)productNum andIndex:(NSIndexPath*)indexPath
{
    iLog(@"update:%ld, %ld, %ld",productNum, indexPath.section,indexPath.row);
    [_serviceStepAry removeAllObjects];
    FSServiceStepForm* stepForm = ((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list[indexPath.section - 3];
    ((FSServiceStepProductForm*)stepForm.product_list[indexPath.row - 1]).product_buy_num = [NSString stringWithFormat:@"%ld",productNum];
    _serviceStepAry = [((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list mutableCopy];
    [self calculateTotalSelectedServicePrice];
}

#pragma mark- FSProductChangeDelegate
- (void)chooseProduct:(FSServiceStepProductForm*)chooseProduct andIndex:(NSIndexPath*)cellIndex
{
    [_serviceStepAry removeAllObjects];
    FSServiceStepForm* stepForm = ((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list[cellIndex.section - 3];
    stepForm.product_list[cellIndex.row - 1] = chooseProduct;
    _serviceStepAry = [((FSServiceSegmentTypeForm*)_serviceTypeAry[_currentSelectIndex]).step_list mutableCopy];
    [self calculateTotalSelectedServicePrice];
}


#pragma mark- CZJOrderListPayCellDelegate
- (void)clickToPay:(id)sender
{
    NSMutableArray* tmpAry = [NSMutableArray array];
    for (FSServiceStepForm* stepForm in _serviceStepAry)
    {
        if (stepForm.is_expand)
        {
            [tmpAry addObject:stepForm];
        }
    }
    [self performSegueWithIdentifier:@"segueToCommitOrder" sender:tmpAry];
}
@end
