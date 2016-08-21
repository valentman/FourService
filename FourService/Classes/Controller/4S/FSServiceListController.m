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

@interface FSServiceListController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    UserBaseForm* userInfoForm;
    NSDictionary* todoThingDict;
    NSArray* serviceAry;
}
@property (strong, nonatomic)UITableView* myTableView;
@property (strong, nonatomic)UICollectionView* myCollectionView;
@end

@implementation FSServiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    [self getDataFromServer];
}

- (void)getDataFromServer
{
    __weak typeof(self) weakSelf = self;
    [FSBaseDataInstance getServiceList:^(id json) {
        NSDictionary* tmpDict = [json valueForKey:@"data"];
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

- (void)viewWillLayoutSubviews
{
    DLog();
}

- (void)viewDidLayoutSubviews
{
    DLog();
    [self initViews];
}

- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=10.f;
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20 + 44 + kMovieBrowserHeight, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 20 - 44 - kMovieBrowserHeight) collectionViewLayout:flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.clipsToBounds = YES;
    self.myCollectionView.alwaysBounceVertical = YES;
    self.myCollectionView.userInteractionEnabled = YES;
    UINib *nib=[UINib nibWithNibName:kServiceCollectionViewCell bundle:nil];
    [self.myCollectionView registerNib: nib forCellWithReuseIdentifier:kServiceCollectionViewCell];
    [self.view addSubview:self.myCollectionView];
    
    //naviBar
    [self addCZJNaviBarView:CZJNaviBarViewTypeMain];
    [self.naviBarView setSize:CGSizeMake(PJ_SCREEN_WIDTH, 44 + kMovieBrowserHeight)];
    self.naviBarView.mainTitleLabel.text = @"4S服务";
    self.naviBarView.buttomSeparator.hidden = YES;
    self.naviBarView.backgroundColor = CZJREDCOLOR;
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
            [carInfoBarView.iconImageView sd_setImageWithURL:[NSURL URLWithString:carForm.logo] placeholderImage:DefaultPlaceHolderCircle];
            carInfoBarView.numberLabel.text = carForm.car_num;
            carInfoBarView.carTypeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",carForm.car_brand_name,carForm.car_model_name, carForm.car_type_name];
            carInfoBarView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, kMovieBrowserHeight);
            [carViewItems addObject:carInfoBarView];
        }
    }
    else
    {
        FSTopAddCarCell* addcarView = [PUtils getXibViewByName:@"FSTopAddCarCell"];
        addcarView.backgroundColor = GRAYCOLOR;
        [carViewItems addObject:addcarView];
    }
    

    PJBrowserView* browserView = [[PJBrowserView alloc] initWithFrame:CGRectMake(0, 44, PJ_SCREEN_WIDTH, kMovieBrowserHeight) items:carViewItems];
    browserView.backgroundColor = BLUECOLOR;
    [self.naviBarView addSubview:browserView];

    
    //左上角个人头像信息
    [self.naviBarView.btnScan setFrame:CGRectMake(20, 0, 44, 44)];
    [self.naviBarView.btnScan setHidden:NO];
    [self.naviBarView.btnScan setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userInfoForm.customer_pho] placeholderImage:DefaultPlaceHolderCircle];
    
    //右上角头像信息
    if (todoThingDict)
    {
        [self.naviBarView.btnMore setHidden:NO];
        [self.naviBarView.btnMore setBadgeNum:-1];
    }
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
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:serviceListForm.service_type_image] placeholderImage:DefaultPlaceHolderCircle];
    return cell;
}


//返回collectionCell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width =  (PJ_SCREEN_WIDTH - 40)/3;
    int height = 130;
    return CGSizeMake(width, height);
}


//返回
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSServiceListForm* serviceListForm = serviceAry[indexPath.item];
    DLog(@"%@",serviceListForm.service_type_name);
    
    
    
//    FSStoreListController* storeListVC = [[FSStoreListController alloc]init];
//    [self.navigationController pushViewController:storeListVC animated:YES];
    
    [self performSegueWithIdentifier:@"segueToStoreList" sender:self];
}


@end
