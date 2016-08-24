//
//  FSServiceStepController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceStepController.h"
#import "FSBaseDataManager.h"

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
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.scrollEnabled = NO;
        self.myTableView.clipsToBounds = NO;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return _serviceStepAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
