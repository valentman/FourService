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

@interface FSServiceStepController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) __block NSArray* serviceStepAry;
@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSServiceStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self getDataFromServer];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"选择项目";
    self.naviBarView.mainTitleLabel.textColor = WHITECOLOR;
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    [self.naviBarView.btnMore setBackgroundImage:nil forState:UIControlStateNormal];
    [self.naviBarView.btnMore setImage:IMAGENAMED(@"shop_share") forState:UIControlStateNormal];
    self.naviBarView.btnMore.hidden = NO;
    
    CZJOrderListPayCell* payCell = [PUtils getXibViewByName:@"CZJOrderListPayCell"];
    payCell.frame = CGRectMake(0, PJ_SCREEN_HEIGHT - 50, PJ_SCREEN_WIDTH, 50);
    [self.view addSubview:payCell];
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
        _serviceStepAry = [FSServiceStepForm objectArrayWithKeyValuesArray:tmpAry];
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

            return cell;
        }
            break;
            
        default:
        {
            FSServiceStepForm* stepForm = _serviceStepAry[indexPath.section - 3];
            
            if (stepForm.is_expand && indexPath.row > 0)
            {
                FSServiceStepGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepGoodsCell" forIndexPath:indexPath];
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
                
                return cell;
            }
        }
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
                [tableView reloadData];
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
}



@end
