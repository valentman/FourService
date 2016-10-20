//
//  FSGoodsDetailController.m
//  FourService
//
//  Created by Joe.Pen on 9/1/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSGoodsDetailController.h"
#import "FSActivityCell.h"
#import "FSProductNameCell.h"
#import "FSProductPriceCell.h"
#import "CZJDetailReturnableAnyWayCell.h"
#import "FSProductEvaluateCell.h"
#import "FSProductEvaluateHeadCell.h"
#import "CZJGeneralCell.h"
#import "FSBaseDataManager.h"
#import "FSWebViewController.h"

@interface FSGoodsDetailController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSArray* picDetailAry;
    NSArray* serviceIntroAry;
    __block FSProductDetailForm* productDetailForm;
}
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getGoodsDetailFromServer];
    [self.myTableView reloadData];
}

- (void)initDatas
{
    picDetailAry = [NSArray array];
    serviceIntroAry = [NSArray array];
    
    NSDictionary* dict1 = @{@"title" : @"图文详情"};
    NSDictionary* dict2 = @{@"title" : @"产品参数"};
    picDetailAry = @[dict1, dict2];
    
    NSDictionary* dict3 = @{@"title" : @"服务介绍"};
    NSDictionary* dict4 = @{@"title" : @"常见问题"};
    NSDictionary* dict5 = @{@"title" : @"购买帮助"};
    serviceIntroAry = @[dict3,dict4,dict5];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"商品详情";
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        _myTableView.tableFooterView = [[UIView alloc]init];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _myTableView.backgroundColor = CZJTableViewBGColor;
        [self.view addSubview:_myTableView];
        
        NSArray* nibArys = @[@"FSActivityCell",
                             @"FSProductNameCell",
                             @"CZJDetailReturnableAnyWayCell",
                             @"FSProductPriceCell",
                             @"FSProductEvaluateCell",
                             @"FSProductEvaluateHeadCell",
                             @"CZJOrderTypeExpandCell",
                             @"CZJGeneralCell"];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [_myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)getGoodsDetailFromServer
{
    NSDictionary* params = @{@"product_id" : _productForm.product_id};
    weaky(self);
    [FSBaseDataInstance getProductDetailInfo:params success:^(id json) {
        DLog(@"%@",[json description]);
        productDetailForm = [FSProductDetailForm objectWithKeyValues:json[kResoponData]];
        [weakSelf.myTableView reloadData];
    } fail:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 3;
            break;
            
        case 3:
            return 4;
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
            if (0 == indexPath.row) {
                FSActivityCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSActivityCell" forIndexPath:indexPath];
                NSMutableArray* imageArray = [NSMutableArray array];
                for (FSProductImageForm* tmp in productDetailForm.product_image_list) {
                    if (tmp.img_url) {
                        [imageArray addObject:[kCZJServerAddr stringByAppendingString:tmp.img_url]];
                    }
                }
                [cell someMethodNeedUse:indexPath DataModel:imageArray];
                return cell;
            }
            if (1 ==indexPath.row) {
                FSProductNameCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSProductNameCell" forIndexPath:indexPath];
                cell.productNameLabel.text = productDetailForm.item_name;
                return cell;
            }
            if (2 == indexPath.row) {
                FSProductPriceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSProductPriceCell" forIndexPath:indexPath];
                cell.productPriceLabel.text = productDetailForm.sale_price;
                cell.productBuyNumLabel.text = productDetailForm.product_buy_num;
                return cell;
            }
            if (3 == indexPath.row) {
                CZJDetailReturnableAnyWayCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJDetailReturnableAnyWayCell" forIndexPath:indexPath];
                return cell;
            }
            break;
            
        case 1:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.text = picDetailAry[indexPath.row][@"title"];
            return cell;
        }
            break;
            
        case 2:
        {
            CZJGeneralCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CZJGeneralCell" forIndexPath:indexPath];
            cell.nameLabel.text = serviceIntroAry[indexPath.row][@"title"];
            return cell;
        }
            break;
            
        case 3:
        {
            if (0 == indexPath.row ||
                3 == indexPath.row) {
                FSProductEvaluateHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSProductEvaluateHeadCell" forIndexPath:indexPath];
                return cell;
            }
            else
            {
                FSProductEvaluateCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSProductEvaluateCell" forIndexPath:indexPath];
                return cell;
            }
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
            if (0 == indexPath.row) {
                return 253;
            }
            if (1 ==indexPath.row) {
                return 70;
            }
            if (2 == indexPath.row) {
                return 53;
            }
            if (3 == indexPath.row) {
                return 30;
            }
            return 4;
            break;
            
        case 1:
            return 46;
            break;
            
        case 2:
            return 46;
            break;
            
        case 3:
            if (0 == indexPath.row ||
                3 == indexPath.row) {
                return 46;
            }
            else
            {
                return 80;
            }
            return 4;
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
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:
        {
            FSWebViewController* webView = (FSWebViewController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"webViewSBID"];
            webView.cur_url = @"www.baidu.com";
            webView.webTitle = picDetailAry[indexPath.row][@"title"];;
            [self.navigationController pushViewController:webView animated:YES];
        }
            
            break;
            
        case 2:
        {
            FSWebViewController* webView = (FSWebViewController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"webViewSBID"];
            webView.cur_url = @"www.baidu.com";
            webView.webTitle = serviceIntroAry[indexPath.row][@"title"];;
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
}

@end
