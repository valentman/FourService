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
@synthesize baseParams = _baseParams;
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
        _baseParams = [NSMutableDictionary dictionary];
        _discoverForms = [NSMutableDictionary dictionary];
        _orderStoreCouponAry = [NSMutableArray array];
        _serviceTypesAry = [NSMutableArray array];
        _goodsTypesAry = [NSMutableArray array];
        _orderPaymentTypeAry = [NSArray array];

        _userInfoForm = [[UserBaseForm alloc]init];
        [self initPostBaseParameters];
        
        NSArray* dict = [PUtils readArrayFromBundleDirectoryWithName:@"PaymentType"];
        _orderPaymentTypeAry = [CZJOrderTypeForm objectArrayWithKeyValuesArray:dict];
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
    _baseParams = [_tmpparams mutableCopy];
    
    //经纬度
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLastLatitude],[USER_DEFAULT doubleForKey:CCLastLongitude]);
    [self setCurLocation:location];
}

- (NSArray*)orderPaymentTypeAry
{
    for (CZJOrderTypeForm* form in _orderPaymentTypeAry)
    {
        form.isSelect = NO;
        if ([form.orderTypeName isEqualToString:@"到店支付"])
        {
            form.isSelect = YES;
        }
    }
    return _orderPaymentTypeAry;
}

- (void)refreshChezhuID
{
    [_baseParams setValue:((nil == self.userInfoForm.identifier) ? @"0" : self.userInfoForm.identifier) forKey:@"identifier"];
    [_baseParams setValue:((nil == self.userInfoForm.token) ? @"0" : self.userInfoForm.token) forKey:@"token"];
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
    [_baseParams setValue:@(self.curLocation.longitude) forKey:@"lng"];
    [_baseParams setValue:@(self.curLocation.latitude) forKey:@"lat"];
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
        [PUtils tipWithText:[dict valueForKey:@"message"] andView:nil];
        return NO;
    }
    DLog(@"%@",[info description]);
    return YES;
}




/*/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////*/
- (void)directPost:(NSDictionary*)postParams
           success:(SuccessBlockHandler)success
           failure:(FailureBlockHandler)failure
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
                failure();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
        if (failure)
            failure();
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.baseParams];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postDataWithUrl:api
                            parameters:postParams
                               success:successBlock
                                  fail:failBlock];
}

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
    [params setValuesForKeysWithDictionary:self.baseParams];
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
    [params setValuesForKeysWithDictionary:self.baseParams];
    [params setValuesForKeysWithDictionary:postParams];
    
    [FSNetWorkInstance postJSONWithUrl:api
                            parameters:params
                               success:successBlock
                                  fail:failBlock];
}



- (void)generalUploadImages:(NSArray*)_imageAry
                      param:(NSDictionary*)_params
                   progress:(ProgressBlockHandler)_progress
                    success:(SuccessBlockHandler)_success
                    failure:(FailureBlockHandler)_fail
                     andUrl:(NSString*)_url
{
    SuccessBlockHandler successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            _success(json);
        }
        else if (_fail)
        {
            _fail();
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        if (_fail) {
            _fail();
        }
    };
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValue:@"files" forKey:@"action"];
    [params setValuesForKeysWithDictionary:self.baseParams];
    
    [FSNetWorkInstance uploadData:_imageAry
                        parameter:params
                            toURL:_url
                         progress:_progress
                           sccess:successBlock
                          failure:failBlock];
    
}


- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail
{
    [self generalUploadImages:_imageAry
                        param:_params
                     progress:_progress
                      success:_success
                      failure:_fail
                       andUrl:kFSServerAPIUploadImage];
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
                [params setValuesForKeysWithDictionary:_baseParams];
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
    [params setValuesForKeysWithDictionary:_baseParams];
    
    if (!_carForm)
    {
        [FSNetWorkInstance postJSONWithUrl:kFSServerAPIGetCarBrands
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
            [_carForm setNewCarSeriesWithDict:json AndBrandName:brandName];
            DLog(@"login suc");
            success();
        }
    };
        
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_baseParams];
    [params setObject:brandId forKey:@"brand_id"];
    
    [FSNetWorkInstance postJSONWithUrl:kFSServerAPIGetCarModels
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
            [_carForm setNewCarModelsWithDict:json ];
            success(json);
        }
    };
    
    FailureBlockHandler failBlock = ^(){
        [[FSErrorCodeManager sharedFSErrorCodeManager] ShowNetError];
    };
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_baseParams];
    [params setObject:seriesId forKey:@"model_id"];

    [FSNetWorkInstance postJSONWithUrl:kFSServerAPIGetCarTypes
                            parameters:params
                               success:successBlock
                                  fail:failBlock];
}




#pragma mark- 订单
- (void)submitOrder:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPICommitOrder];
}



- (void)getOrderList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIOrderList];
}

- (void)getOrderDetail:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIOrderDetail];
}


- (void)evaluateOrder:(NSDictionary*)postParams
              Success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIOrderEvaluate];
}





#pragma mark- 用户信息
//-------------------------个人信息中心------------------------------
//获取用户信息详情
- (void)getUserInfo:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.baseParams];
    [params setValuesForKeysWithDictionary:postParams];
    [self generalPost:params success:success fail:fail andServerAPI:kFSServerAPIGetMyInfo];
}


//上传用户头像
- (void)uploadUserHeadPic:(NSDictionary*)postParams
                    Image:(UIImage*)image
                  Success:(SuccessBlockHandler)success
                     fail:(FailureBlockHandler)fail
{
    [self generalUploadImages:@[image] param:nil progress:nil success:success failure:fail andUrl:kFSServerAPIUploadHeadImage];
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
    [params setValuesForKeysWithDictionary:self.baseParams];
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
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIAddMyCar];
}

- (void)editMyCar:(NSDictionary*)postParams
          Success:(SuccessBlockHandler)success
             fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIEditMyCar];
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

//获取足迹列表
- (void)getScanList:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIScanList];
}

//获取收藏列表
- (void)getFavoriteList:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIFavoriteList];
}

//获取评价列表
- (void)getEvalutionList:(NSDictionary*)postParams
                 Success:(SuccessBlockHandler)success
                    fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIEvalutionList];
}

//优惠券
- (void)getDiscountList:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIDiscountList];
}



#pragma mark- 注册登录
//-------------------------注册登录------------------------------

- (void)loginWithPwdOrCode:(NSDictionary*)loginParams
                   success:(SuccessBlockHandler)success
                      fail:(SuccessBlockHandler)fail
{
    [self generalPost:loginParams success:success failure:fail andServerAPI:kFSServerAPILogin];
}

- (void)loginOut:(NSDictionary*)loginoutParams
         success:(SuccessBlockHandler)success
            fail:(SuccessBlockHandler)fail
{
    [self generalPost:loginoutParams success:success fail:fail andServerAPI:kFSServerAPILoginOut];
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


- (void)getServiceList:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail
{
    [self generalPost:nil success:success fail:fail andServerAPI:kFSServerAPIServiceList];
}

- (void)getStoreList:(NSDictionary*)postParams
                type:(CZJHomeGetDataFromServerType)type
             success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)failure
{
    [self generalPost:postParams success:success fail:failure andServerAPI:kFSServerAPIStoreList];
}

//获取门店详细信息
- (void)getStoreDetailInfo:(NSDictionary*)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIStoreDetail];
}

//门店评论列表
- (void)getStoreEvaluationList:(NSDictionary*)postParams
                       success:(SuccessBlockHandler)success
                          fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIStoreEvaluate];
}

//获取服务步骤列表
- (void)getServiceStepList:(NSDictionary*)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIServiceStepList];
}

//获取步骤商品可更换列表
- (void)getProductChangeableList:(NSDictionary*)postParams
                         success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSserverAPIProductChangeable];
}

//获取商品详情
- (void)getProductDetailInfo:(NSDictionary*)postParams
                     success:(SuccessBlockHandler)success
                        fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIProductDetailInfo];
}

//获取商品评论列表
- (void)getProductEvaluationList:(NSDictionary*)postParams
                         success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail
{
    [self generalPost:postParams success:success fail:fail andServerAPI:kFSServerAPIProductEvaluate];
}
@end
