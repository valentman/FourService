//
//  FSBaseDataManager.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "CZJCarForm.h"
//@class HomeForm;
//@class CZJStoreForm;
//@class CZJDiscoverForm;
//@class FourServicepingCartForm;
//@class CZJOrderStoreCouponsForm;
//@class UserBaseForm;
//@class CZJGoodsDetailForm;

@interface FSBaseDataManager : NSObject
{
//    HomeForm* _homeForm;                            //首页信息
//    CZJCarForm* _carForm;                           //汽车列表信息
//    CZJStoreForm* _storeForm;                       //门店信息
//    FourServicepingCartForm* _shoppingCartForm;         //购物车信息
    UserBaseForm* _userInfoForm;                    //我的个人信息
//
//    CarBrandsForm* _carBrandForm;
//    CarSeriesForm* _carSerialForm;
//    CarModelForm* _carModealForm;
    
    NSMutableDictionary* _discoverForms;            //发现信息
    NSMutableArray* _orderStoreCouponAry;           //订单结算页面可用优惠券列表
    
    NSMutableArray* _goodsTypesAry;
    NSMutableArray* _serviceTypesAry;
    NSMutableDictionary *_params;                   //post参数字典
    
    //固定数据
    NSArray* _orderPaymentTypeAry;           //支付方式数组（暂时固定为三个支付方式）
}
//--------------------服务器返回数据对象模型----------------------------
//@property (nonatomic, retain) HomeForm* homeForm;
//@property (nonatomic, retain) CZJCarForm* carForm;
//@property (nonatomic, retain) CZJStoreForm* storeForm;
@property (nonatomic, retain) UserBaseForm* userInfoForm;
//@property (nonatomic, retain) FourServicepingCartForm* shoppingCartForm;
//
//@property (nonatomic, retain) CarBrandsForm* carBrandForm;
//@property (nonatomic, retain) CarSeriesForm* carSerialForm;
//@property (nonatomic, retain) CarModelForm* carModealForm;


@property (nonatomic, retain) NSMutableDictionary* discoverForms;

@property (nonatomic, retain) NSMutableArray* goodsTypesAry;
@property (nonatomic, retain) NSMutableArray* serviceTypesAry;
@property (nonatomic, retain) NSArray* orderPaymentTypeAry;
//-------------------------本地数据对象------------------------------
@property (nonatomic, assign) CLLocationCoordinate2D curLocation;
@property (nonatomic, retain) NSString* curCityName;                    //用户当前城市
@property (nonatomic, retain) NSString* curCityID;                    //用户当前城市ID
@property (nonatomic, retain) NSString* curProvinceID;                    //用户当前省份ID
@property (nonatomic) NSMutableDictionary *params;

singleton_interface(FSBaseDataManager);

- (void)initPostBaseParameters;
- (void)refreshChezhuID;
- (void)getAreaInfos;
-(void)getSomeInfoSuccess:(SuccessBlockHandler)success;

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

//获取商品或服务详情
- (void)loadDetailsWithType:(CZJDetailType)type
            AndStoreItemPid:(NSString*)storeItemPid
                    Success:(GeneralBlockHandler)success
                       fail:(FailureBlockHandler)fail;

//获取详情界面热门推荐列表
- (void)loadDetailHotRecommendWithType:(CZJDetailType)type
                            andStoreId:(NSString*)storeId
                               Success:(GeneralBlockHandler)success
                                  fail:(FailureBlockHandler)fail;



//-------------------------门店数据------------------------------
//获取门店数据
- (void)showStoreWithParams:(NSDictionary*)postParams
                       type:(CZJHomeGetDataFromServerType)type
                    success:(SuccessBlockHandler)success
                       fail:(FailureBlockHandler)failure;

//门店信息详情
- (void)loadStoreInfo:(NSDictionary*)postParams
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)failure;

//门店服务商品详情
- (void)loadStoreDetail:(NSDictionary*)postParams
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)failure;



//-------------------------订单数据------------------------------
//获取购物车信息
- (void)loadShoppingCart:(NSDictionary*)postParams
                    type:(CZJHomeGetDataFromServerType)type
                 Success:(GeneralBlockHandler)success
                    fail:(FailureBlockHandler)fail;

//获取购物车数量
- (void)loadShoppingCartCount:(NSDictionary*)postParams
                      Success:(SuccessBlockHandler)success
                         fail:(FailureBlockHandler)fail;

//加入购物车
- (void)addProductToShoppingCart:(NSDictionary*)postParams
                         Success:(SuccessBlockHandler)success
                            fail:(FailureBlockHandler)fail;

//删除购物车物品
- (void)removeProductFromShoppingCart:(NSDictionary*)postParams
                              Success:(GeneralBlockHandler)success
                                 fail:(FailureBlockHandler)fail;

//获取结算页数据
- (void)loadSettleOrder:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;

//提交订单
- (void)submitOrder:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//获取地址列表
- (void)loadAddrList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;

//添加地址
- (void)addDeliveryAddr:(NSDictionary*)postParams
                Success:(GeneralBlockHandler)success
                   fail:(FailureBlockHandler)fail;

//修改收货地址
- (void)updateDeliveryAddr:(NSDictionary*)postParams
                Success:(GeneralBlockHandler)success
                   fail:(FailureBlockHandler)fail;

//删除收货地址
- (void)removeDeliveryAddr:(NSDictionary*)postParams
                   Success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail;

//设置默认地址
- (void)setDefaultAddr:(NSDictionary*)postParams
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

//车况检查
- (void)getOrderCarCheck:(NSDictionary*)postParams
                 Success:(SuccessBlockHandler)success
                    fail:(FailureBlockHandler)fail;

//施工进度
- (void)getOrderBuildProgress:(NSDictionary*)postParams
                      Success:(SuccessBlockHandler)success
                         fail:(FailureBlockHandler)fail;



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

- (void)generalUploadImage:(UIImage*)image
                   withAPI:(NSString*)serverAPI
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



//-------------------------注册登录------------------------------

//验证码登录或密码登录
- (void)loginWithPwdOrCode:(NSDictionary*)loginParams
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

@end
