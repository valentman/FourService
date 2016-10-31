//
//  FSServiceListController.m
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceListController.h"
#import "FSTopCarInfoBarView.h"
#import "FSBaseDataManager.h"
#import "FSServiceCell.h"
#import "FSStoreListController.h"
#import "UIButton+AFNetworking.h"
#import "PJBrowserView.h"
#import "FSTopAddCarCell.h"
#import "FSHomeNotifyCell.h"
#import "YQSlideMenuController.h"
#import "FSWebViewController.h"
#import "CZJAddMyCarController.h"
#import "CZJCarBrandChooseController.h"
#import "FSCityLocationController.h"

#define kHomeTopBgHeight 247

typedef  NS_ENUM(NSInteger, MoveDirection)
{
    MoveDirectionTop,
    MoveDirectionDown
};

@interface FSServiceListController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
PBaseNaviagtionBarViewDelegate,
PJBrowserDelegate,
CityLocationDelegate
>
{
    NSDictionary* todoThingDict;
    NSArray* serviceAry;
    __block NSString *currentCityStr;
    
    FSHomeNotifyCell* notifyCell;
    PJBrowserView* browserView;
    UserBaseForm *serviceUserBaseForm;
    
    __block BOOL isTop;
}
@property (strong, nonatomic)UITableView* myTableView;
@property (strong, nonatomic)UICollectionView* myCollectionView;
@end

@implementation FSServiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
}

- (void)initData
{
    [self getDataFromServer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromServer) name:kCZJNotifiLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopViewsWhenGetDataSuccess) name:kCZJNotifiLoginOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showExchangeCity:) name:kCZJNotifiNotCurrentCity object:nil];
    isTop = NO;
    currentCityStr = [USER_DEFAULT valueForKey:CCLastCity];
}

- (void)getDataFromServer
{
    __weak typeof(self) weakSelf = self;
    [FSBaseDataInstance getServiceList:^(id json) {
        NSDictionary* tmpDict = json[kResoponData];
        serviceAry = [FSServiceListForm objectArrayWithKeyValuesArray:[tmpDict valueForKey:@"type_list"]];
        serviceUserBaseForm = [UserBaseForm objectWithKeyValues:[tmpDict valueForKey:@"customer_info"]];
        todoThingDict = [tmpDict valueForKey:@"todo_list"];
        [weakSelf.myCollectionView reloadData];
        if (FSBaseDataInstance.userInfoForm) {
            [weakSelf updateTopViewsWhenGetDataSuccess];
        }
    } fail:^{
        
    }];
}

- (void)showExchangeCity:(NSNotification *)notify
{
    currentCityStr = notify.object;
    NSString *alertStr = [NSString stringWithFormat:@"您当前位置为%@,是否切换到当前位置？", currentCityStr];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"切换城市" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    weaky(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不切换" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        currentCityStr = [USER_DEFAULT valueForKey:CCLatestCity];
        [USER_DEFAULT setValue:currentCityStr forKey:CCLastCity];
        [USER_DEFAULT setValue:[USER_DEFAULT valueForKey:CCLatestLat] forKey:CCLastLatitude];
        [USER_DEFAULT setValue:[USER_DEFAULT valueForKey:CCLatestLon] forKey:CCLastLongitude];
        [USER_DEFAULT synchronize];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLatestLat],[USER_DEFAULT doubleForKey:CCLatestLon]);
        [FSBaseDataInstance setCurLocation:location];
        
        [weakSelf updateCityButton];
        [weakSelf getDataFromServer];
    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}


- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kHomeTopBgHeight + 17 + 40 + 20, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 20 - 44 - kMovieBrowserHeight) collectionViewLayout:flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.clipsToBounds = YES;
    self.myCollectionView.alwaysBounceVertical = YES;
    self.myCollectionView.userInteractionEnabled = YES;
    self.myCollectionView.backgroundColor = WHITECOLOR;
    UINib *nib=[UINib nibWithNibName:kServiceCollectionViewCell bundle:nil];
    [self.myCollectionView registerNib: nib forCellWithReuseIdentifier:kServiceCollectionViewCell];
    [self.view addSubview:self.myCollectionView];
    
    //naviBar
    [self addCZJNaviBarView:CZJNaviBarViewTypeFourservice];
    self.naviBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, kHomeTopBgHeight);
    self.naviBarView.mainTitleLabel.text = @"养车人家";
    self.naviBarView.mainTitleLabel.textColor = WHITECOLOR;
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    [self updateHeadButton];
    [self updateCityButton];
    
    //通知栏
    notifyCell = [PUtils getXibViewByName:@"FSHomeNotifyCell"];
    notifyCell.frame = CGRectMake(0, kHomeTopBgHeight + 17, PJ_SCREEN_WIDTH, 40);
    notifyCell.contentLabel.text = @"办理违章送油卡红包，拉上朋友一起享受新鲜福利";
    [notifyCell.notifyButton addTarget:self action:@selector(notifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notifyCell];
}

- (void)updateHeadButton
{
    self.naviBarView.btnHead.hidden = NO;
    [self.naviBarView.btnHead.headBtn addTarget:self action:@selector(clickHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.naviBarView.btnHead.badgeLabel.layer.borderColor = WHITECOLOR.CGColor;
    self.naviBarView.btnHead.badgeLabel.layer.borderWidth = 1.5;
    [self.naviBarView.btnHead.headBtn setBackgroundColor:WHITECOLOR];
    
    NSInteger badgeNum = [serviceUserBaseForm.order_init_num integerValue] +
                        [serviceUserBaseForm.order_payed_num integerValue] +
                        [serviceUserBaseForm.order_finish_num integerValue] +
                        [serviceUserBaseForm.order_commented_num integerValue] +
                        [serviceUserBaseForm.discount_normal_num integerValue];
    
    NSString* badgeStr = [NSString stringWithFormat:@"%ld", (long)badgeNum];
    CGSize labelSize = [PUtils calculateTitleSizeWithString:badgeStr AndFontSize:14];
    self.naviBarView.btnHead.badgeLabelWidth.constant = (labelSize.width < 15) ? 20 : (labelSize.width + 10);
    if (0 == badgeNum) {
        [self.naviBarView.btnHead.badgeLabel setHidden:YES];
    }
    [self.naviBarView.btnHead.badgeLabel setText:badgeStr];
}

- (void)updateCityButton
{
    [self.naviBarView.btnMore setTitle:currentCityStr forState:UIControlStateNormal];
    CGSize citySize = [PUtils calculateTitleSizeWithString:currentCityStr AndFontSize:14];
    [self.naviBarView.btnMore setSize:CGSizeMake(citySize.width + 20, 44)];
    self.naviBarView.btnMore.frame = CGRectMake(PJ_SCREEN_WIDTH - citySize.width - 20 - 15, 20, citySize.width + 20, 44);
    
    CAShapeLayer *trangle = [PUtils creatIndicatorWithColor:WHITECOLOR andPosition:CGPointMake(citySize.width + 15, 23)];
    [self.naviBarView.btnMore.layer removeShapeSubLayer];
    [self.naviBarView.btnMore.layer addSublayer:trangle];
}

- (void)moveCollectionView
{
    [UIView animateWithDuration:0.5 animations:^{
        if (isTop)
        {
            self.myCollectionView.frame = CGRectMake(0, kHomeTopBgHeight + 17 + 40 + 20, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 20 - 44 - kMovieBrowserHeight);
            self.naviBarView.frame =CGRectMake(0, 0, PJ_SCREEN_WIDTH, kHomeTopBgHeight);
            notifyCell.frame = CGRectMake(0, kHomeTopBgHeight + 17, PJ_SCREEN_WIDTH, 40);
            browserView.frame = CGRectMake(0, 87, PJ_SCREEN_WIDTH, kMovieBrowserHeight);
        }
        else
        {
            self.myCollectionView.frame = CGRectMake(0, 84 + 17 + 40 + 20, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 20 - 44 - 17 - 40);
            self.naviBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 84);
            notifyCell.frame = CGRectMake(0, 84 + 17, PJ_SCREEN_WIDTH, 40);
            browserView.frame = CGRectMake(0, 87, PJ_SCREEN_WIDTH, 0);
        }
    } completion:^(BOOL finished) {
        self.myCollectionView.scrollEnabled = YES;
        isTop = !isTop;
    }];
}


- (void)notifyAction:(id)sender
{
    FSWebViewController* webView = (FSWebViewController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"webViewSBID"];
    webView.cur_url = @"www.baidu.com";
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)updateTopViewsWhenGetDataSuccess
{
    //提取出当前默认车辆，如果没有，则显示添加车辆
    
    //carInfoBar
    NSMutableArray* carViewItems = [NSMutableArray array];
    if (FSBaseDataInstance.userInfoForm.car_list.count > 0)
    {
        for (FSCarListForm* carForm in FSBaseDataInstance.userInfoForm.car_list)
        {
            FSTopCarInfoBarView* carInfoBarView = [PUtils getXibViewByName:@"FSTopCarInfoBarView"];
            [carInfoBarView.iconImageView sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, carForm.icon)] placeholderImage:DefaultPlaceHolderCircle];
            carInfoBarView.numberLabel.text = carForm.car_num;
            carInfoBarView.carTypeLabel.text = [NSString stringWithFormat:@"%@%@%@",carForm.car_brand_name,carForm.car_model_name, carForm.car_type_name];
            carInfoBarView.backgroundColor = CLEARCOLOR;
            [carViewItems addObject:carInfoBarView];
        }
    }
    FSTopAddCarCell* addcarView = [PUtils getXibViewByName:@"FSTopAddCarCell"];
    [addcarView.addBtnImage setImage:IMAGENAMED(@"home_addBtn")];
    addcarView.backgroundColor = CLEARCOLOR;
    addcarView.frame = CGRectMake(0, 0, 120, kMovieBrowserHeight);
    [carViewItems addObject:addcarView];
    

    if (!browserView) {
        browserView = [[PJBrowserView alloc] initWithFrame:CGRectMake(0, 87, PJ_SCREEN_WIDTH, kMovieBrowserHeight) items:carViewItems];
        browserView.delegate = self;
        [self.naviBarView addSubview:browserView];
    }
    else
    {
        [browserView updateItems:carViewItems];
    }
    
    
    NSURL* headImgUrl;
    if (FSBaseDataInstance.userInfoForm.customer_photo ) {
        headImgUrl = [NSURL URLWithString:FSBaseDataInstance.userInfoForm.customer_photo];
    }
    
    [self.naviBarView.btnHead.headBtn setImageForState:UIControlStateNormal withURL:headImgUrl placeholderImage:IMAGENAMED(@"placeholder_personal")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return serviceAry.count;
}

//返回CollectionCell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kServiceCollectionViewCell forIndexPath:indexPath];
    FSServiceListForm* serviceListForm = serviceAry[indexPath.item];
    cell.cellLabel.text = serviceListForm.service_type_name;
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:ConnectString(kCZJServerAddr, serviceListForm.service_type_image)] placeholderImage:DefaultPlaceHolderCircle];
    return cell;
}


//返回collectionCell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width =  (PJ_SCREEN_WIDTH - 37*2 - 42*2)/3;
    int height = 105;
    return CGSizeMake(width, height);
}


//返回
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 36, 20, 36);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSServiceListForm* serviceListForm = serviceAry[indexPath.item];
    [self performSegueWithIdentifier:@"segueToStoreList" sender:serviceListForm.service_type_id];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //去掉tableview中section的headerview粘性
    DLog(@"%f",scrollView.contentOffset.y);
    if ((scrollView.contentOffset.y > 0 && !isTop) ||
        (scrollView.contentOffset.y < 0 && isTop))
    {
        [self.myCollectionView setContentOffset:CGPointZero];
        self.myCollectionView.scrollEnabled = NO;
        [self moveCollectionView];
        
    }
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    FSStoreListController* storeListVC = segue.destinationViewController;
    storeListVC.serviceId = sender;
}


- (void)clickHeadBtn:(nullable id)sender
{
    [((YQSlideMenuController*)self.parentViewController) showMenu];

}


#pragma mark- PJBrowserDelegate
- (void)browser:(PJBrowserView *)movieBrowser didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"%ld",index);
    if (index < FSBaseDataInstance.userInfoForm.car_list.count) {
        FSCarListForm* carForm = FSBaseDataInstance.userInfoForm.car_list[index];
        CZJAddMyCarController* addCarVC = (CZJAddMyCarController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"addMyCarSBID"];
        addCarVC.carForm = carForm;
        [self.navigationController pushViewController:addCarVC animated:YES];
    }
    else
    {
        CZJCarBrandChooseController *svc = [[CZJCarBrandChooseController alloc] initWithType:CZJCarListTypeGeneral];
        svc.viewFrom = @"carList";
        [self.navigationController pushViewController:svc animated:YES];
    }
}


- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
        {
            FSCityLocationController *cityListView = [[FSCityLocationController alloc]init];
            cityListView.delegate = self;
            //热门城市列表
            NSMutableArray *hotcityAry = [@[@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南"] mutableCopy];
            cityListView.arrayHotCity = hotcityAry;
            //历史选择城市列表
            cityListView.arrayHistoricalCity = [@[@"福州",@"厦门",@"泉州"] mutableCopy];
            //定位城市列表
            cityListView.arrayLocatingCity   = [@[[USER_DEFAULT valueForKey:CCLatestCity]] mutableCopy];
        
            [self presentViewController:cityListView animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)didClickedWithCityName:(NSString*)cityName
{
    [USER_DEFAULT setValue:cityName forKey:CCLastCity];
    [USER_DEFAULT synchronize];
    currentCityStr = cityName;
    [self updateCityButton];
    
}

@end
