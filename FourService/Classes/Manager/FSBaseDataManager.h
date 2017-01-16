//
//  FSBaseDataManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FSBaseDataManager : NSObject

//--------------------服务器返回数据对象模型----------------------------
@property (nonatomic, retain) UserBaseForm* userInfoForm;

@property (nonatomic, retain) FSCarForm* carForm;
@property (nonatomic, retain) CarBrandsForm* carBrandForm;
@property (nonatomic, retain) CarSeriesForm* carSerialForm;
@property (nonatomic, retain) CarModelForm* carModealForm;

@property (nonatomic, retain) NSMutableDictionary* discoverForms;

@property (nonatomic, retain) NSMutableArray* goodsTypesAry;
@property (nonatomic, retain) NSMutableArray* serviceTypesAry;
@property (nonatomic, retain) NSArray* orderPaymentTypeAry;

//-------------------------本地数据对象------------------------------
@property (nonatomic, assign) CLLocationCoordinate2D curLocation;
@property (nonatomic, retain) NSString* curCityName;                    //用户当前城市
@property (nonatomic, retain) NSString* curCityID;                    //用户当前城市ID
@property (nonatomic, retain) NSString* curProvinceID;                    //用户当前省份ID
@property (nonatomic) NSMutableDictionary *baseParams;

singleton_interface(FSBaseDataManager);

- (void)initPostBaseParameters;
- (void)refreshChezhuID;


//-------------------------通用接口------------------------------
- (void)directPost:(NSDictionary*)postParams
           success:(SuccessBlockHandler)success
           failure:(FailureBlockHandler)failure
      andServerAPI:(NSString*)api;

//通用(失败回调带参数)
- (void)generalPost:(NSDictionary*)postParams
            success:(SuccessBlockHandler)success
            failure:(SuccessBlockHandler)failure
       andServerAPI:(NSString*)api;

//通用(失败回调不带参数)
- (void)generalPost:(NSDictionary*)postParams
            success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail
       andServerAPI:(NSString*)api;


//上传图片通用(失败回调不带参数)
- (void)generalUploadImages:(NSArray*)_imageAry
                      param:(NSDictionary*)_params
                   progress:(ProgressBlockHandler)_progress
                    success:(SuccessBlockHandler)_success
                    failure:(FailureBlockHandler)_fail
                     andUrl:(NSString*)_url;


/**
 *  图片上传接口
 *
 *  @param _imageAry 图片数组
 *  @param _params   参数（）
 *  @param _progress 进度回调
 *  @param _success  成功回调
 *  @param _fail     失败回调
 */
- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(ProgressBlockHandler)_progress
             success:(SuccessBlockHandler)_success
             failure:(FailureBlockHandler)_fail;



//-------------------------首页数据------------------------------
//获取首页数据
- (void)showHomeType:(CZJHomeGetDataFromServerType)dataType
                page:(int)page
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;



//获取汽车品牌列表信息
- (void)getCarBrandsList:(SuccessBlockHandler)success;



//获取汽车品牌车系列表
- (void) loadCarSeriesWithBrandId:(NSString*)brandId
                        BrandName:(NSString*)brandName
                          Success:(GeneralBlockHandler)success
                             fail:(FailureBlockHandler)fail;

//获取汽车车型信息列表
- (void)loadCarModelSeriesId:(NSString*)seriesId
                     Success:(GeneralBlockHandler)success
                        fail:(FailureBlockHandler)fail;

////获取商品或服务详情
//- (void)loadDetailsWithType:(CZJDetailType)type
//            AndStoreItemPid:(NSString*)storeItemPid
//                    Success:(GeneralBlockHandler)success
//                       fail:(FailureBlockHandler)fail;

//获取详情界面热门推荐列表
//- (void)loadDetailHotRecommendWithType:(CZJDetailType)type
//                            andStoreId:(NSString*)storeId
//                               Success:(GeneralBlockHandler)success
//                                  fail:(FailureBlockHandler)fail;



//-------------------------门店数据------------------------------
//获取门店数据
//- (void)showStoreWithParams:(NSDictionary*)postParams
//                       type:(CZJHomeGetDataFromServerType)type
//                    success:(SuccessBlockHandler)success
//                       fail:(FailureBlockHandler)failure;

//门店信息详情
//- (void)loadStoreInfo:(NSDictionary*)postParams
//                success:(SuccessBlockHandler)success
//                   fail:(FailureBlockHandler)failure;

//门店服务商品详情
//- (void)loadStoreDetail:(NSDictionary*)postParams
//                success:(SuccessBlockHandler)success
//                   fail:(FailureBlockHandler)failure;



//-------------------------订单数据------------------------------

//获取结算页数据
//- (void)loadSettleOrder:(NSDictionary*)postParams
//                Success:(SuccessBlockHandler)success
//                   fail:(FailureBlockHandler)fail;

//提交订单
- (void)submitOrder:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//获取订单列表
- (void)getOrderList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;

//获取订单详情
- (void)getOrderDetail:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail;

//评价订单
- (void)evaluateOrder:(NSDictionary*)postParams
              Success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)fail;

//车况检查
//- (void)getOrderCarCheck:(NSDictionary*)postParams
//                 Success:(SuccessBlockHandler)success
//                    fail:(FailureBlockHandler)fail;

//施工进度
//- (void)getOrderBuildProgress:(NSDictionary*)postParams
//                      Success:(SuccessBlockHandler)success
//                         fail:(FailureBlockHandler)fail;



//-------------------------个人信息中心------------------------------
//获取用户信息详情
- (void)getUserInfo:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//上传用户头像
- (void)uploadUserHeadPic:(NSDictionary*)postParams
                    Image:(UIImage*)image
                  Success:(SuccessBlockHandler)success
                     fail:(FailureBlockHandler)fail;

//修改用户信息
- (void)updateUserInfo:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail;

//添加车辆
- (void)addMyCar:(NSDictionary*)postParams
         Success:(SuccessBlockHandler)success
            fail:(FailureBlockHandler)fail;

//编辑车辆
- (void)editMyCar:(NSDictionary*)postParams
         Success:(SuccessBlockHandler)success
            fail:(FailureBlockHandler)fail;

//获取爱车列表
- (void)getMyCarList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;

//移除爱车
- (void)removeMyCar:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//设置默认车辆
- (void)setDefaultCar:(NSDictionary*)postParams
              Success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)fail;

//获取足迹列表
- (void)getScanList:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//获取收藏列表
- (void)getFavoriteList:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;

//获取评价列表
- (void)getEvalutionList:(NSDictionary*)postParams
                 Success:(SuccessBlockHandler)success
                    fail:(FailureBlockHandler)fail;

//优惠券
- (void)getDiscountList:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;



//-------------------------注册登录------------------------------

//验证码登录或密码登录
- (void)loginWithPwdOrCode:(NSDictionary*)loginParams
                   success:(SuccessBlockHandler)success
                      fail:(SuccessBlockHandler)fail;

//退出登录
- (void)loginOut:(NSDictionary*)loginoutParams
         success:(SuccessBlockHandler)success
            fail:(SuccessBlockHandler)fail;


//获取短信验证码
- (void)getAuthCodeWithIphone:(NSString*)phone
                      success:(GeneralBlockHandler)success
                         fail:(GeneralBlockHandler)fail;

//获取图片验证码
- (void)getImageCodeWithSuccess:(SuccessBlockHandler)success
                           fail:(GeneralBlockHandler)fail;

//验证码验证
- (void)verifyCodeWithParam:(NSDictionary*)codeParams
                    success:(GeneralBlockHandler)success
                       fail:(GeneralBlockHandler)fail;

//注册
- (void)userRegistWithParam:(NSDictionary*)postParams
                    success:(SuccessBlockHandler)success
                       fail:(FailureBlockHandler)fail;

//读取个人信息
- (void)loginWithDefaultInfoSuccess:(void (^)())success
                               fail:(void (^)())fail;



//------------------------- 服务步骤 ------------------------------
//获取服务列表
- (void)getServiceList:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail;

//获取提供服务的门店列表
- (void)getStoreList:(NSDictionary*)postParams
                type:(CZJHomeGetDataFromServerType)type
             success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)failure;

//获取门店详细信息
- (void)getStoreDetailInfo:(NSDictionary*)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail;

/**
 *  获取门店评论列表
 *
 *  @param postParams 参数结构： @{@"shop_id" : @"",
                                 @"page_num" : @"",
                                 @"page_size" : @""}
 *  @param success
 *  @param fail
 */
- (void)getStoreEvaluationList:(NSDictionary*)postParams
                       success:(SuccessBlockHandler)success
                          fail:(FailureBlockHandler)fail;

//获取服务步骤列表
- (void)getServiceStepList:(NSDictionary*)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail;

//获取可更换商品列表
- (void)getProductChangeableList:(NSDictionary*)postParams
                         success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail;

//商品详情
- (void)getProductDetailInfo:(NSDictionary*)postParams
                     success:(SuccessBlockHandler)success
                        fail:(FailureBlockHandler)fail;

//商品评论列表
- (void)getProductEvaluationList:(NSDictionary*)postParams
                         success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail;


//意见反馈
- (void)feedBack:(NSDictionary *)postParams
               success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail;

//维修反馈
- (void)maintainceFeedback:(NSDictionary *)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail;

@end
