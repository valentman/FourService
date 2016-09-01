//
//  FSStoreMapController.m
//  FourService
//
//  Created by Joe.Pen on 9/1/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStoreMapController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CZJCustomAnnotationView.h"
#import "CZJMAAroundAnnotation.h"
#import "CZJStoreMAAroundForm.h"
#import "FSBaseDataManager.h"
#import "CCLocationManager.h"
#import "ZXLocationManager.h"
#import "CZJStoreMapCell.h"
#import "CZJStoreForm.h"

@interface FSStoreMapController ()
<
MAMapViewDelegate,
UIGestureRecognizerDelegate
>
{
    MAMapView *_mapView;
    CZJStoreMapCell* locationView;          //地图中心
    UIButton *_locationBtn;                 //定位按钮
    
    //地址转码
    CLLocation *_currentLocation;
    
    //附近搜索数据
    NSMutableArray *_pois;
    NSMutableArray *_annotations;
    
    CLLocationCoordinate2D nearstoreLocation;
}

@end

@implementation FSStoreMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
}

- (void)initDatas
{
}

- (void)initViews
{
    //添加NaviBarView
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"附近门店";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
