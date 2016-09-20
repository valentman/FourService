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


#define kHomeTopBgHeight 247

@interface FSServiceListController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
PBaseNaviagtionBarViewDelegate
>
{
    UserBaseForm* userInfoForm;
    NSDictionary* todoThingDict;
    NSArray* serviceAry;
    FSHomeNotifyCell* notifyCell;
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
}

- (void)getDataFromServer
{
    __weak typeof(self) weakSelf = self;
    [FSBaseDataInstance getServiceList:^(id json) {
        DLog(@"%@",[json description]);
        NSDictionary* tmpDict = json[kResoponData];
        serviceAry = [FSServiceListForm objectArrayWithKeyValuesArray:[tmpDict valueForKey:@"type_list"]];
        userInfoForm = [UserBaseForm objectWithKeyValues:[tmpDict valueForKey:@"customer_info"]];
        todoThingDict = [tmpDict valueForKey:@"todo_list"];
        [weakSelf.myCollectionView reloadData];
        if (userInfoForm) {
            [weakSelf updateTopViewsWhenGetDataSuccess];
        }
    } fail:^{
        
    }];
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
    self.naviBarView.btnBack.hidden = NO;
    [self.naviBarView.btnBack setSize:CGSizeMake(40, 40)];
    self.naviBarView.btnBack.layer.cornerRadius = 20;
    [self.naviBarView.btnBack setBackgroundImage:nil forState:UIControlStateNormal];
    [self.naviBarView.btnBack setClipsToBounds:YES];
    [self.naviBarView.btnBack setPosition:CGPointMake(12, 28) atAnchorPoint:CGPointZero];
    [self.naviBarView.btnBack addTarget:self action:@selector(clickHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBarView.btnBack setBadgeNum:22];
    [self.naviBarView.btnBack setBadgeLabelPosition:CGPointMake(50, 0)];
    
    [self.naviBarView.btnMore setTitle:@"成都" forState:UIControlStateNormal];
    
    self.naviBarView.backgroundImageView.frame = self.naviBarView.frame;
    [self.naviBarView.backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    self.naviBarView.clipsToBounds = YES;
    
    //通知栏
    notifyCell = [PUtils getXibViewByName:@"FSHomeNotifyCell"];
    notifyCell.frame = CGRectMake(0, kHomeTopBgHeight + 17, PJ_SCREEN_WIDTH, 40);
    notifyCell.contentLabel.text = @"办理违章送油卡红包，拉上朋友一起享受新鲜福利";
    [self.view addSubview:notifyCell];
}

- (void)updateTopViewsWhenGetDataSuccess
{
    //提取出当前默认车辆，如果没有，则显示添加车辆
    
    //carInfoBar
    NSMutableArray* carViewItems = [NSMutableArray array];
    if (userInfoForm.car_list.count > 0)
    {
        for (FSCarListForm* carForm in userInfoForm.car_list)
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
    addcarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, kMovieBrowserHeight);
    [carViewItems addObject:addcarView];
    

    PJBrowserView* browserView = [[PJBrowserView alloc] initWithFrame:CGRectMake(0, 87, PJ_SCREEN_WIDTH, kMovieBrowserHeight) items:carViewItems];
    [self.naviBarView addSubview:browserView];
    
    NSURL* headImgUrl;
    if (userInfoForm.customer_photo ) {
        headImgUrl = [NSURL URLWithString:userInfoForm.customer_photo];
    }
    
    [self.naviBarView.btnBack setBackgroundImageForState:UIControlStateNormal withURL:headImgUrl placeholderImage:DefaultPlaceHolderCircle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
    DLog(@"PJ_SCREEN_WIDTH:%f",PJ_SCREEN_WIDTH);
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender
{
    FSStoreListController* storeListVC = segue.destinationViewController;
    storeListVC.serviceId = sender;
}


- (void)clickHeadBtn:(nullable id)sender
{
    [((YQSlideMenuController*)self.parentViewController) showMenu];

}

@end
