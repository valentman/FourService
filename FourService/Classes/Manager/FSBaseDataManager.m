  //
//  CZJHomeViewManager.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSBaseDataManager.h"
#import "FSNetworkManager.h"
#import "WGS84TOGCJ02.h"
#import "FSLoginModelManager.h"
#import "FSErrorCodeManager.h"
#import "CCLocationManager.h"
#import "ZXLocationManager.h"
//#import "FourServicepingCartForm.h"
//#import "CZJOrderForm.h"
#import "AppDelegate.h"

@implementation FSBaseDataManager
#pragma mark- synthesize
@synthesize curLocation =  _curLocation;
//@synthesize homeForm = _homeForm;
//@synthesize carForm = _carForm;
//@synthesize storeForm = _storeForm;
@synthesize params = _params;
//@synthesize shoppingCartForm = _shoppingCartForm;
@synthesize discoverForms = _discoverForms;
@synthesize goodsTypesAry = _goodsTypesAry;
@synthesize serviceTypesAry = _serviceTypesAry;
@synthesize carBrandForm = _carBrandForm;
@synthesize carModealForm = _carModealForm;
@synthesize carSerialForm = _carSerialForm;
@synthesize orderPaymentTypeAry = _orderPaymentTypeAry;

#pragma mark- implement
singleton_implementation(FSBaseDataManager);

- (id) init
{
    if (self = [super init])
    {
        _params = [NSMutableDictionary dictionary];
        _discoverForms = [NSMutableDictionary dictionary];
        _orderStoreCouponAry = [NSMutableArray array];
        _serviceTypesAry = [NSMutableArray array];
        _goodsTypesAry = [NSMutableArray array];
        _orderPaymentTypeAry = [NSArray array];

        _userInfoForm = [[UserBaseForm alloc]init];
        [self initPostBaseParameters];
        return self;
    }
    return nil;
}

- (void)initPostBaseParameters
{
    //固定请求参数确定
    NSDictionary* _tmpparams = @{@"identifier" : @"",
                                 @"token" : @"",
                                 @"os" : @"ios",
                                 @"suffix" : ((iPhone6Plus || iPhone6) ? @"@3x" : @"@2x")
                                 };
    _params = [_tmpparams mutableCopy];
}

- (void)refreshChezhuID
{
    [_params setValue:((nil == self.userInfoForm.identifier) ? @"0" : self.userInfoForm.identifier) forKey:@"identifier"];
    [_params setValue:((nil == self.userInfoForm.token) ? @"0" : self.userInfoForm.token) forKey:@"token"];
//    [_params setValue:((nil == self.userInfoForm.mobile) ? @"0" : self.userInfoForm.mobile) forKey:@"chezhuMobile"];
}


- (void)setCurLocation:(CLLocationCoordinate2D)curLocation
{
    if (![WGS84TOGCJ02 isLocationOutOfChina:curLocation])
    {
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:curLocation];
        _curLocation = coord;
    }
    else
    {
        _curLocation = curLocation;
    }
    [_params setValue:@(self.curLocation.longitude) forKey:@"lng"];
    [_params setValue:@(self.curLocation.latitude) forKey:@"lat"];
}

- (void)setCurCityName:(NSString *)curCity
{
//    if (curCity)
//    {
//        [self generalPost:@{@"cityName":curCity} success:^(id json) {
//            NSDictionary* dict = [[PUtils DataFromJson:json] valueForKey:@"msg"];
//            self.curCityID = [dict valueForKey:@"cityId"];
//            self.curProvinceID = [dict valueForKey:@"provinceId"];
//            [_params setValue:self.curCityID forKey:@"cityId"];
//            
////            self.userInfoForm.cityId = self.curCityID;
////            self.userInfoForm.cityName = curCity;
//            [USER_DEFAULT setValue:self.curCityID forKey: kCZJDefaultCityID];
//            [USER_DEFAULT setValue:curCity forKey: kCZJDefaultyCityName];
//        } fail:^{
//        
//        } andServerAPI:kCZJServerAPIGetCityIdByName];
//    }
}

- (BOOL)showAlertView:(id)info{
    NSDictionary* dict = [NSDictionary dictionaryWithDictionary:info];
    NSString* msgKey = [[info valueForKey:@"code"] stringValue];
    if (![msgKey isEqual:@"0"]) {
//        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowErrorInfoWithErrorCode: stringValue]];
        [PUtils tipWithText:[dict valueForKey:@"message"] andView:nil];
        return NO;
    }
    DLog(@"%@",msgKey);
    return YES;
}




/*/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////*/


- (void)generalPost:(NSDictionary*)postParams
            success:(SuccessBlockHandler)success
            failure:(SuccessBlockHandler)failure
       andServerAPI:(NSString*)api
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
        else
        {
            if (failure)
                failure(json);
        }
    };
    
    SuccessBlockHandler failBlock = ^(id json){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (failure)
            failure(json);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:api
                            parameters:params
                               success:successBlock
                                  fail:failBlock];
}


- (void)generalPost:(NSDictionary*)postParams
            success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
       andServerAPI:(NSString*)api
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
        else
        {
            if (fail)
                fail();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (fail)
            fail();
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:api
                            parameters:params
                               success:successBlock
                                  fail:failBlock];
}


- (void)getAreaInfos
{
    SuccessBlockHandler successBlock = ^(id json) {
        if ([self showAlertView:json])
        {
            NSDictionary* newdict = [[PUtils DataFromJson:json] valueForKey:@"msg"];
            
            //省份信息写入缓存
            [PUtils writeDictionaryToDocumentsDirectory:[newdict mutableCopy] withPlistName:kCZJPlistFileProvinceCitys];
//            [_storeForm setNewProvinceDataWithDictionary:newdict];
        }
    };

    FailureBlockHandler failBlock = ^{
    };
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetCitys
                             parameters:_params
                                success:successBlock
                                   fail:failBlock];
}


-(void)getSomeInfoSuccess:(SuccessBlockHandler)success{
//    NSString* tst = [self.userInfoForm.chezhuId stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString* str = [NSString stringWithFormat:@"{\"chezhuId\":\"%@\",\"cityId\":\"%@\",\"mobile\":\"%@\",\"lat\":\"%@\",\"lng\":\"%@\"}",tst,_curCityID,self.userInfoForm.mobile,[NSNumber numberWithDouble:_curLocation.latitude],[NSNumber numberWithDouble:_curLocation.longitude]];
//    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
//    {
//        success(str);
//    }
//    else
//    {
//        success(@"");
//    }
}


#pragma mark- 首页
- (void)showHomeType:(CZJHomeGetDataFromServerType)dataType
                page:(int)page
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;
{
    __block SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            if (dataType == CZJHomeGetDataFromServerTypeOne)
            {
//                [_homeForm setNewDictionary:[PUtils DataFromJson:json]];
//                if (_storeForm.provinceForms.count == 0)
//                {
//                    [self getAreaInfos];
//                }
            }
            else if (dataType == CZJHomeGetDataFromServerTypeTwo)
            {
                //推荐商品分页返回数据
//                [_homeForm  appendGoodsRecommendDataWith:[PUtils DataFromJson:json]];
            }
        }
        success(json);
    };
    
    __block FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        fail();
    };
    
    GeneralBlockHandler loadHomeBlock = ^{
        NSString* explicitUrl = @"";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        switch (dataType) {
            case CZJHomeGetDataFromServerTypeOne:
            {
                explicitUrl = kFSServerAPIShowHome;
                [params setValuesForKeysWithDictionary:_params];
            }
                break;
                
            case CZJHomeGetDataFromServerTypeTwo:
            {
//                explicitUrl = kCZJServerAPIGetRecoGoods;
//                int randNum = [[USER_DEFAULT valueForKey:kUserDefaultRandomCode]intValue];
//                [params setValuesForKeysWithDictionary:_params];
//                [params setValue:@(page) forKey:@"page"];
//                [params setValue:@(randNum) forKey:@"randomCode"];
            }
                break;
            default:
                break;
        }
        
        [FSNetWorkInstance postJSONWithUrl:explicitUrl
                                 parameters:params
                                    success:successBlock
                                       fail:failBlock];
    };
    [PUtils performBlock:loadHomeBlock afterDelay:0];
}




#pragma mark- 筛选列表，汽车车型选择
- (void)getCarBrandsList:(SuccessBlockHandler)success
{
    SuccessBlockHandler successBlock = ^(id json){
        _carForm = [[FSCarForm alloc]init];
        [_carForm setNewCarBrandsFormDictionary:json];
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    
    if (!_carForm)
    {
//        [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoadCarBrands
//                                 parameters:params
//                                    success:successBlock
//                                       fail:failBlock];
        [FSNetWorkInstance postJSONWithNoServerAPI:kCZJServerAPILoadCarBrands
                                        parameters:params
                                           success:successBlock
                                              fail:failBlock];
    }
}

- (void)loadCarSeriesWithBrandId:(NSString*)brandId
                        BrandName:(NSString*)brandName
                          Success:(GeneralBlockHandler)success
                             fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
//            NSDictionary* dict = [PUtils DataFromJson:json];
            [_carForm setNewCarSeriesWithDict:json AndBrandName:brandName];
            DLog(@"login suc");
            success();
        }
    };
        
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setObject:brandId forKey:@"brandId"];
    
//    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoadCarSeries
//                            parameters:params
//                               success:successBlock
//                                  fail:failBlock];
    
    [FSNetWorkInstance postJSONWithNoServerAPI:kCZJServerAPILoadCarSeries
                                    parameters:params
                                       success:successBlock
                                          fail:failBlock];
}

- (void)loadCarModelSeriesId:(NSString*)seriesId
                      Success:(GeneralBlockHandler)success
                         fail:(FailureBlockHandler)fail
{
    
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
//            NSDictionary* dict = [PUtils DataFromJson:json];
            [_carForm setNewCarModelsWithDict:json ];
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setObject:seriesId forKey:@"seriesId"];
    
//    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoadCarModels
//                            parameters:params
//                               success:successBlock
//                                  fail:failBlock];
    [FSNetWorkInstance postJSONWithNoServerAPI:kCZJServerAPILoadCarModels
                                    parameters:params
                                       success:successBlock
                                          fail:failBlock];
}



#pragma mark- 获取商品或服务详情
- (void)loadDetailsWithType:(CZJDetailType)type
            AndStoreItemPid:(NSString*)storeItemPid
                    Success:(GeneralBlockHandler)success
                       fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setObject:storeItemPid forKey:@"storeItemPid"];
    NSString* apiUrl;
    if (CZJDetailTypeGoods == type)
    {
        apiUrl = kCZJServerAPIGoodsDetail;
    }
    else if (CZJDetailTypeService == type)
    {
        apiUrl = kCZJServerAPIServiceDetail;
    }
    
    [FSNetWorkInstance postJSONWithUrl:apiUrl
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}


- (void)loadDetailHotRecommendWithType:(CZJDetailType)type
                            andStoreId:(NSString*)storeId
                               Success:(GeneralBlockHandler)success
                                  fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setObject:storeId forKey:@"storeId"];

    NSString* apiUrl;
    if (CZJDetailTypeGoods == type)
    {
        apiUrl = kCZJServerAPIGoodsHotReco;
    }
    else if (CZJDetailTypeService == type)
    {
        apiUrl = kCZJServerAPIGoodsHotReco;
    }
    
    [FSNetWorkInstance postJSONWithUrl:apiUrl
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}






#pragma mark- 门店
- (void)showStoreWithParams:(NSDictionary*)postParams
                       type:(CZJHomeGetDataFromServerType)type
                    success:(SuccessBlockHandler)success
                       fail:(FailureBlockHandler)failure
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        failure();
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetNearbyStores
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)loadStoreInfo:(NSDictionary*)postParams
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)failure
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (failure)
        {
            failure();
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPILoadGoodsInStore
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)loadStoreDetail:(NSDictionary*)postParams
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)failure
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetStoreDetail
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}



#pragma mark- 购物车
- (void)loadShoppingCart:(NSDictionary*)postParams
                    type:(CZJHomeGetDataFromServerType)type
                 Success:(GeneralBlockHandler)success
                    fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
//            NSDictionary* dict = [PUtils DataFromJson:json];
//            if (CZJHomeGetDataFromServerTypeOne == type) {
//                [_shoppingCartForm setNewShoppingCartDictionary:dict];
//            }
//            else if (CZJHomeGetDataFromServerTypeTwo == type)
//            {
//                [_shoppingCartForm appendNewShoppingCartData:dict];
//            }
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        fail();
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:postParams];
    [params setValuesForKeysWithDictionary:_params];
    
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIShoppingCartList
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)loadShoppingCartCount:(NSDictionary*)postParams
                      Success:(SuccessBlockHandler)success
                         fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            if (success)
            {
                NSDictionary* dict = [PUtils DataFromJson:json];
                [USER_DEFAULT setObject:[dict valueForKey:@"msg"] forKey:kUserDefaultShoppingCartCount];
                success(json);
            }
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIShoppingCartCount
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)addProductToShoppingCart:(NSDictionary*)postParams
                         Success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIAddToShoppingCart
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)removeProductFromShoppingCart:(NSDictionary*)postParams
                              Success:(GeneralBlockHandler)success
                                 fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIDeleteShoppingCartInfo
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)loadSettleOrder:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPISettleOrders
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

- (void)submitOrder:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (fail) {
            fail();
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPISubmitOrder
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}



- (void)loadAddrList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            success(json);
        }
        
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetAddrList
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

//添加地址
- (void)addDeliveryAddr:(NSDictionary*)postParams
                Success:(GeneralBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIAddAddr
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

//修改收货地址
- (void)updateDeliveryAddr:(NSDictionary*)postParams
                   Success:(GeneralBlockHandler)success
                      fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIUpdateAddr
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

//删除收货地址
- (void)removeDeliveryAddr:(NSDictionary*)postParams
                   Success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIRemoveAddr
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

//设置默认地址
- (void)setDefaultAddr:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
        }
        success(json);
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPISetDefaultAddr
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}



- (void)getOrderList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetOrderList
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}


- (void)getOrderDetail:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
        else
        {
            if (fail) {
                fail();
            }
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (fail) {
            fail();
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIGetOrderDetail
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}


- (void)getOrderCarCheck:(NSDictionary*)postParams
                 Success:(SuccessBlockHandler)success
                    fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPICarCheck
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}


- (void)getOrderBuildProgress:(NSDictionary*)postParams
                      Success:(SuccessBlockHandler)success
                         fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIBuildingProgress
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}






//获取用户信息详情
- (void)getUserInfo:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    [self generalPost:params success:success fail:fail andServerAPI:kFSServerAPIGetMyInfo];
}


//上传用户头像
- (void)uploadUserHeadPic:(NSDictionary*)postParams
                    Image:(UIImage*)image
                  Success:(SuccessBlockHandler)success
                     fail:(FailureBlockHandler)fail
{
    [self generalUploadImage:image withAPI:kCZJServerAPIUploadHeadPic Success:success fail:fail];
}


- (void)generalUploadImage:(UIImage*)image
                   withAPI:(NSString*)serverAPI
                   Success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    
    [FSNetWorkInstance uploadImageWithUrl:serverAPI
                                     Image:image
                                Parameters:params
                                   success:successBlock
                                   failure:failBlock];
}

//修改用户信息
- (void)updateUserInfo:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kFSServerAPIEditMyInfo
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}

//添加车辆
- (void)addMyCar:(NSDictionary*)postParams
         Success:(SuccessBlockHandler)success
            fail:(FailureBlockHandler)fail
{
    SuccessBlockHandler successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:kCZJServerAPIAddCar
                             parameters:params
                                success:successBlock
                                   fail:failBlock];
}




//-------------------------注册登录------------------------------

- (void)loginWithPwdOrCode:(NSDictionary*)loginParams
                   success:(SuccessBlockHandler)success
                      fail:(SuccessBlockHandler)fail
{
    [self generalPost:loginParams success:success failure:fail andServerAPI:kFSServerAPILogin];
}


- (void)getAuthCodeWithIphone:(NSString*)phone
                      success:(GeneralBlockHandler)success
                         fail:(GeneralBlockHandler)fail
{
    NSDictionary *params = @{@"mobile" : phone};
    [self generalPost:params success:success fail:fail andServerAPI:kFSServerAPILogin];
}


- (void)getImageCodeWithSuccess:(SuccessBlockHandler)success
                          fail:(GeneralBlockHandler)fail
{
    [self generalPost:nil success:success fail:fail andServerAPI:kFSServerAPIVerifyCode];
}

- (void)verifyCodeWithParam:(NSDictionary*)codeParams
                    success:(GeneralBlockHandler)success
                       fail:(GeneralBlockHandler)fail
{
    [self generalPost:codeParams success:success fail:fail andServerAPI:kFSServerAPICheckVerifyCode];
}


- (void)userRegistWithParam:(NSDictionary*)postParams
                    success:(SuccessBlockHandler)success
                       fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIRegister];
}


//获取爱车列表
- (void)getMyCarList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:@"TODO"];
}

//移除爱车
- (void)removeMyCar:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIDeleteMyCar];
}

//设置默认车辆
- (void)setDefaultCar:(NSDictionary*)postParams
              Success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIEditMyCar];
}

//启动读出用户默认配置信息
- (void)loginWithDefaultInfoSuccess:(void (^)())success
                               fail:(void (^)())fail{
    
    NSDictionary* userDict = [PUtils readDictionaryFromDocumentsDirectoryWithPlistName:kCZJPlistFileUserBaseForm];
    if (!userDict)
    {
        [USER_DEFAULT setBool:NO forKey:kCZJIsUserHaveLogined];
        return;
    }
    self.userInfoForm = [[UserBaseForm alloc] init];
    self.userInfoForm = [UserBaseForm objectWithKeyValues:userDict];
    [self refreshChezhuID];
    success();
}


@end
