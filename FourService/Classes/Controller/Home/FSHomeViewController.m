//
//  FSHomeViewController.m
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSHomeViewController.h"
#import "FSActivityCell.h"
#import "FSLotteryCell.h"
#import "FSRecommendInfoCell.h"
#import "FSBaseDataManager.h"

@interface FSHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FSImageViewTouchDelegate,
PBaseNaviagtionBarViewDelegate
>
{
    MJRefreshAutoNormalFooter* refreshFooter;
    MJRefreshGifHeader* refreshHeader;
    
    int page;                                       //分页页码
    
    //数据数组
    NSMutableArray* _activityArray;                 //活动信息
    NSMutableArray* _newsArray;            //推荐信息
    NSMutableArray* _lotteryArray;                  //抽奖信息
    
    __block BOOL _isAllRefresh;
    __block BOOL _isLotteryRefresh;
    __block BOOL _isRecommendRefresh;
    BOOL _isJumpToAnotherView;
}

@property (strong, nonatomic)UITableView* myTableView;
@end

@implementation FSHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self getHomeDataFromServer];
}

- (void)initDatas
{
    _isAllRefresh = NO;
    _isLotteryRefresh = NO;
    _isRecommendRefresh = NO;
    _isJumpToAnotherView = NO;
    
    _activityArray = [NSMutableArray array];
    _newsArray = [NSMutableArray array];
    _lotteryArray = [NSMutableArray array];
}


- (void)initViews
{
    [self dealWtihNavigatorView];
    [self dealWithTableView];
}

- (void)dealWtihNavigatorView
{
    /**
     *  注意：一旦你设置了navigationBar的- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics接口，那么上面的setBarTintColor接口就不能改变statusBar的背景色
     */
    //导航栏背景透明化
    id navigationBarAppearance = self.navigationController.navigationBar;
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"nav_bargound"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"nav_bargound"];
    self.navigationController.navigationBarHidden = YES;
    
    //导航栏添加搜索栏
    [self addCZJNaviBarView:CZJNaviBarViewTypeSearch];
    [self.naviBarView setBackgroundColor:RGBA(235, 35, 38, 0)];
    self.view.backgroundColor = CZJNAVIBARBGCOLOR;
}

- (void)dealWithTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT - Tabbar_HEIGHT) style:UITableViewStylePlain];
    self.myTableView.tableFooterView = [[UIView alloc]init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView.backgroundColor = CZJNAVIBARBGCOLOR;
    [self.view addSubview:self.myTableView];
    
    NSArray* nibArys = @[@"FSActivityCell",
                         @"FSLotteryCell",
                         @"FSRecommendInfoCell"
                         ];
    
    for (id cells in nibArys) {
        UINib *nib=[UINib nibWithNibName:cells bundle:nil];
        [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
    }
}

- (void)dealWithTabbar
{
    //TabBarItem选中颜色设置及右上角标记设置
    [self.tabBarController.tabBar setTintColor:RGB(235, 20, 20)];
}

- (void)getHomeDataFromServer
{
    [FSBaseDataInstance showHomeType:CZJHomeGetDataFromServerTypeOne page:0 Success:^(id json) {
        NSDictionary* jsondata = [[NSDictionary dictionaryWithDictionary:json] valueForKey:@"data"];
        NSArray* tmpAry = [jsondata valueForKey:@"banner"];
        _activityArray = [[FSHomeBannerForm objectArrayWithKeyValuesArray:[jsondata objectForKey:@"banner"]] mutableCopy];
        _lotteryArray = [[FSHomeLuckyForm objectArrayWithKeyValuesArray:[jsondata objectForKey:@"lucky"]] mutableCopy];
        _newsArray = [[FSHomeNewsForm objectArrayWithKeyValuesArray:[jsondata objectForKey:@"news"]] mutableCopy];
        DLog(@"%@",[jsondata description]);
    } fail:^{
        
    }];
    [self.myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    _isJumpToAnotherView = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (2 == section)
    {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //依据不同的内容加载不同类型的Cell
    switch (indexPath.section) {
        case 0:
        {//ad广告展示
            FSActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSActivityCell" forIndexPath:indexPath];
            if (_activityArray.count > 0 && _isAllRefresh)
            {
                [cell someMethodNeedUse:indexPath DataModel:_activityArray];
                cell.delegate = self;
            }
            return cell;
        }
            break;
            
        case 1:
        {//抽奖
            FSLotteryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSLotteryCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        case 2:
        {//推荐信息
            FSRecommendInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FSRecommendInfoCell" forIndexPath:indexPath];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 210;
            break;
        case 1:
            return PJ_SCREEN_WIDTH*0.75;
            break;
        case 2:
            return 200;
            break;
        default:
            return 200;
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
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isJumpToAnotherView) {
        return;
    }
    float contentOffsetY = [scrollView contentOffset].y;
    if (contentOffsetY < 0) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.naviBarView setAlpha:0.0];
        }];
        [self.naviBarView setBackgroundColor:RGBA(235, 35, 38, 0)];
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^{
            [self.naviBarView setAlpha:1.0];
        }];
        
        float alphaValue = contentOffsetY / 200;
        if (alphaValue > 0.8)
        {
            alphaValue = 0.8;
        }
        [self.naviBarView setBackgroundColor:RGBA(235, 35, 38, alphaValue)];
    }
}



#pragma mark- PBaseNaviagtionBarViewDelegate
- (void)clickEventCallBack:(id)sender
{
    _isJumpToAnotherView = YES;
    switch ([sender tag]) {
        case CZJButtonTypeHomeScan:
            [self performSegueWithIdentifier:@"pushToScanQR" sender:self];
            break;
            
        case CZJButtonTypeHomeShopping:
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
