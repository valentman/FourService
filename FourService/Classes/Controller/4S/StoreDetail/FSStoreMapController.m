//
//  FSStoreMapController.m
//  FourService
//
//  Created by Joe.Pen on 10/7/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStoreMapController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CZJCustomAnnotationView.h"
#import "CZJMAAroundAnnotation.h"
#import "CZJStoreMAAroundForm.h"
#import "CCLocationManager.h"
#import "ZXLocationManager.h"
#import "CZJStoreMapCell.h"
#import "CZJStoreForm.h"
#import "FSBaseDataManager.h"


#define kDefaultCalloutViewMargin       -8
#define MAPKEY @"dd2b9e1576489ef636cdda90c74cbdbe"

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
    //添加NaviBarView
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.mainTitleLabel.text = @"附近门店";
    
    [self initAttributes];
    [self initMapViews];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_annotations.count > 0)
    {
        [self updateUI];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    MAIN(^{
        [self getAroundMerchantData];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    _mapView.delegate = nil;
}

- (void)myLocation
{
    if (IS_IOS8)
    {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D coord) {
            [FSBaseDataInstance setCurLocation:coord];
            _currentLocation = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
        }];
    }
    else if (IS_IOS7)
    {
        [[ZXLocationManager sharedZXLocationManager] getLocationCoordinate:^(CLLocationCoordinate2D coord) {
            [FSBaseDataInstance setCurLocation:coord];
            _currentLocation = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
        }];
    }
}

- (void)initAttributes
{
    _annotations = [NSMutableArray array];
    _pois = [NSMutableArray array];
    //进入页面使用当前定位位置
    _currentLocation = [[CLLocation alloc]initWithLatitude:FSBaseDataInstance.curLocation.latitude longitude:FSBaseDataInstance.curLocation.longitude];
}

- (void)initMapViews
{
    //添加MapView
    [MAMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
    _mapView.delegate = self;
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    _mapView.showTraffic = NO;                                              //交通状况
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
}


-(void)initViews{
    
    //左下角自身定位按钮
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationBtn.frame = CGRectMake(20, PJ_SCREEN_HEIGHT-80, 40, 40);
    _locationBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;//
    _locationBtn.backgroundColor = [UIColor whiteColor];
    _locationBtn.layer.cornerRadius = 5;
    [_locationBtn setImage:[UIImage imageNamed:@"wl_map_icon_position"] forState:UIControlStateNormal];
    [_locationBtn setImage:[UIImage imageNamed:@"wl_map_icon_position_press"] forState:UIControlStateHighlighted];
    [_locationBtn addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationBtn];
    
    
    
    
    //添加中心位置图标按钮
    CGPoint pt = CGPointMake(PJ_SCREEN_WIDTH*0.5, PJ_SCREEN_HEIGHT*0.5);
    locationView = [PUtils getXibViewByName:@"CZJStoreMapCell"];
    [locationView setSize:CGSizeMake(iPhone5 || iPhone4 ? PJ_SCREEN_WIDTH*0.65 : PJ_SCREEN_WIDTH * 0.5, 65)];
    locationView.separatorLeading.constant = locationView.frame.size.width * 0.33;
    [locationView setPosition:CGPointMake(pt.x, pt.y - 10) atAnchorPoint:CGPointButtomMiddle];
    [locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    [self.view addSubview:locationView];
    
    UIImageView* downArrow = [[UIImageView alloc]init];
    [downArrow setImage:IMAGENAMED(@"shop_img_angle")];
    [downArrow setSize:CGSizeMake(14, 7)];
    [downArrow setPosition:CGPointMake(pt.x, pt.y - 10) atAnchorPoint:CGPointTopMiddle];
    [self.view addSubview:downArrow];
    
    UIImageView* locateImage = [[UIImageView alloc]init];
    [locateImage setImage:IMAGENAMED(@"shop_icon_location_map")];
    [locateImage setSize:CGSizeMake(20, 33)];
    [locateImage setPosition:pt atAnchorPoint:CGPointTopMiddle];
    [self.view addSubview:locateImage];
}

//获取附近商家列表
-(void)getAroundMerchantData
{
    NSDictionary* params = @{@"lat" : [NSString stringWithFormat:@"%f", _currentLocation.coordinate.latitude] , @"lng" : [NSString stringWithFormat:@"%f", _currentLocation.coordinate.longitude]};
    [FSBaseDataInstance generalPost:params success:^(id json) {
        NSArray* dict = json[kResoponData];
        DLog(@"%@",[dict description]);
        NSArray* arroundStores = [CZJNearbyStoreForm objectArrayWithKeyValuesArray:dict];
        
        if (arroundStores > 0)
        {
            [_mapView removeAnnotations:_annotations];
            [_annotations removeAllObjects];
            CLLocationCoordinate2D location = [FSBaseDataInstance curLocation];
            for (int i = 0; i < arroundStores.count; i++)
            {
                CZJNearbyStoreForm* model = arroundStores[i];
                CZJMAAroundAnnotation *annotation = [[CZJMAAroundAnnotation alloc] init];
                annotation.jzmaaroundM = model;
                annotation.title = model.name;
                annotation.subtitle = model.addr;
                annotation.thrtitle = model.openingHours;
                annotation.coordinate = CLLocationCoordinate2DMake([model.lat floatValue],[model.lng floatValue]);
                CLLocation* storeLocation = [[CLLocation alloc]initWithLatitude:[model.lat floatValue] longitude:[model.lng floatValue]];
                float distance = [storeLocation distanceFromLocation:_currentLocation];
                distance = distance > 5? distance:0;
                model.distanceMeter = [NSString stringWithFormat:@"%.0f",distance];
                [_annotations addObject:annotation];
            }
            
            //门店距离降序排序
            [arroundStores sortedArrayUsingComparator:^NSComparisonResult(CZJNearbyStoreForm* obj1, CZJNearbyStoreForm* obj2) {
                if ([obj1.distanceMeter intValue] > [obj2.distanceMeter intValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1.distanceMeter intValue] < [obj1.distanceMeter intValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            //更新距离最近门店
            CZJNearbyStoreForm* nearForm = [arroundStores firstObject];
            float meteDistance = [nearForm.distanceMeter floatValue];
            NSString* distancStr = @"";
            if (meteDistance >= 1000)
            {
                meteDistance = meteDistance / 1000;
                distancStr = [NSString stringWithFormat:@"%.1fkm",meteDistance];
            }
            else if (meteDistance >= 0 &&
                     meteDistance < 1000 &&
                     nearForm != nil)
            {
                distancStr = [NSString stringWithFormat:@"%.0fm",meteDistance];
            }
            locationView.distanceLabel.text = distancStr;
            locationView.storeNameLabel.text = nearForm.name == nil ? @"附近没有门店" : nearForm.name;
            locationView.storeAddrLabel.text = nearForm.addr;
            locationView.storeId = nearForm.storeId;
            
            if (([arroundStores count] > 0) && (location.longitude == 0) && (location.latitude == 0))
            {
                _mapView.centerCoordinate = CLLocationCoordinate2DMake([[[arroundStores firstObject] lat] doubleValue], [[[arroundStores firstObject] lng] doubleValue]);
            }
        }
        
        [self performSelectorOnMainThread:@selector(updateUI)withObject:_annotations waitUntilDone:YES];
    }  fail:^{
        
    } andServerAPI:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新地图上标注点
-(void)updateUI{
    for (int i = 0; i < _annotations.count; i++) {
        [_mapView addAnnotation:_annotations[i]];
    }
}

//点击定位自身
-(void)locateAction{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}


#pragma mark - MAMapViewDelegate
//地图区域改变完成后回调
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    if (_currentLocation.coordinate.latitude != centerCoordinate.latitude ||
        _currentLocation.coordinate.longitude != centerCoordinate.longitude)
    {
        _currentLocation = [[CLLocation alloc]initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
        [self getAroundMerchantData];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    if (_currentLocation.coordinate.latitude != centerCoordinate.latitude ||
        _currentLocation.coordinate.longitude != centerCoordinate.longitude)
    {
        _currentLocation = [[CLLocation alloc]initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
        [self getAroundMerchantData];
    }
}

//替换定位图标
-(void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated{
    if (mode == MAUserTrackingModeNone) {
        [_locationBtn setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }else{
        [_locationBtn setImage:[UIImage imageNamed:@"wl_map_icon_position"] forState:UIControlStateNormal];
    }
}

//点击门店定位图标时
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}

//显示地图门店定位图标
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CZJCustomAnnotationView *annotationView = (CZJCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CZJCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        if ([annotation isKindOfClass:[CZJMAAroundAnnotation class]]){
            annotationView.jzAnnotation = (CZJMAAroundAnnotation *)annotation;
        }
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"shop_icon_shop"];
        return annotationView;
    }
    return nil;
}


#pragma mark - 跳转到门店详情
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"mapToStoreDetail"]) {
//        CZJStoreDetailController* storeDetailVC = segue.destinationViewController;
//        storeDetailVC.storeId = locationView.storeId;
//    }
//}

- (void)handleTapGesture:(UITapGestureRecognizer*)getsture
{
//    [self performSegueWithIdentifier:@"mapToStoreDetail" sender:nil];
}

@end
