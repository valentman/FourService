//
//  FSProductChangeController.m
//  FourService
//
//  Created by Joe.Pen on 9/12/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSProductChangeController.h"
#import "FSBaseDataManager.h"
#import "FSServiceStepGoodsCell.h"

@interface FSProductChangeController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray* productListAry;
}
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSProductChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getGoodsListFromServer];
}

- (void)initDatas
{
    productListAry = [NSArray array];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"更换商品";
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"FSServiceStepGoodsCell"];
    
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
}

- (void)getGoodsListFromServer
{
    NSDictionary* params = @{@"shop_id" : self.shopId,
                             @"sub_type_id" : self.subTypeId,
                             @"product_item_id" : self.productItem};
    weakSelf(self);
    [FSBaseDataInstance getProductChangeableList:params success:^(id json) {
        DLog(@"%@",[json description]);
        productListAry = [FSServiceStepProductForm objectArrayWithKeyValuesArray:json[kResoponData]];
        [weakSelf.myTableView reloadData];
    } fail:nil];
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
    return productListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSServiceStepProductForm* productform = productListAry[indexPath.row];
    FSServiceStepGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepGoodsCell" forIndexPath:indexPath];
    NSString* imagUrl = @"";
    if (productform.product_image_list.firstObject) {
        imagUrl = ConnectString(kCZJServerAddr, ((FSProductImageForm*)productform.product_image_list.firstObject).img_url);
    }
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:imagUrl] placeholderImage:DefaultPlaceHolderSquare];
    cell.productNameLabel.text = productform.product_name;
    cell.productPriceLabel.text = productform.sale_price;
    cell.productNumLabel.hidden = YES;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSServiceStepProductForm* productform = productListAry[indexPath.row];
    if ([_delegate respondsToSelector:@selector(chooseProduct:andIndex:)])
    {
        [_delegate chooseProduct:productform andIndex:_cellIndexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
