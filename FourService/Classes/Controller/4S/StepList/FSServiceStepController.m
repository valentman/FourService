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
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.clipsToBounds = NO;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CZJTableViewBGColor;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        NSArray* nibArys = @[@"FSServiceStepCell",
                             @"FSServiceStepGoodsCell",
                             @"FSStoreInfoCell",
                             @"CZJGeneralCell"];
        
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
    return _serviceStepAry.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return _serviceStepAry.count;
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
            FSServiceStepCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSServiceStepCell" forIndexPath:indexPath];
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
            return 167;
            break;
            
        case 1:
            return 46;
            break;
            
        default:
            break;
    }
    return 50;
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
    NSString* sbIdentifer;
    switch (indexPath.section)
    {
        case 0:
            sbIdentifer = @"segueToStoreDetail";
            break;
            
        case 1:
            sbIdentifer = @"segueToStoreMap";
            break;
            
        default:
            break;
    }
    if (sbIdentifer)
        [self performSegueWithIdentifier:sbIdentifer sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
