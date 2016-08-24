//
//  FSStoreListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStoreListController.h"
#import "FSBaseDataManager.h"
#import "FSServiceStepController.h"

@interface FSStoreListController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) __block NSArray* storeList;
@property (strong, nonatomic) UITableView* myTableView;
@end

@implementation FSStoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self getDataFromServer];
}

- (void)initViews
{
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"选择门店";
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
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.myTableView.backgroundColor = CZJTableViewBGColor;
        [self.view addSubview:self.myTableView];
        
        NSArray* nibArys = @[];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

- (void)getDataFromServer
{
    NSDictionary* params = @{@"service_type_id" : self.serviceId};
    __weak typeof (self) weakSelf = self;
    [YXSpritesLoadingView showWithText:nil andShimmering:NO andBlurEffect:NO];
    [FSBaseDataInstance getStoreList:params type:CZJHomeGetDataFromServerTypeOne success:^(id json) {
        [YXSpritesLoadingView dismiss];
        NSArray* tmpAry = [json valueForKey:kResoponData];
        _storeList = [FSStoreInfoForm objectArrayWithKeyValuesArray:tmpAry];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    FSStoreInfoForm* storeInfo = _storeList[indexPath.row];
    [self performSegueWithIdentifier:@"segueToStep" sender:storeInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FSServiceStepController* serviceStepVC = segue.destinationViewController;
    serviceStepVC.serviceID = ((FSStoreInfoForm*)sender).shop_service_type_id;
    serviceStepVC.shopID = ((FSStoreInfoForm*)sender).shop_id;
}

@end
