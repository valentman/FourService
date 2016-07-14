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


//-------------------------分类数据------------------------------
//获取分类数据
- (void)showCategoryTypeId:(NSString*)typeId
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)fail;

//获取商品列表
- (void)loadGoodsList:(NSDictionary*)postParams
                 type:(CZJHomeGetDataFromServerType)type
              success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)failure;

//获取商品列表筛选条件列表
- (void)loadGoodsFilterTypes:(NSDictionary*)postParams
                     success:(SuccessBlockHandler)success
                        fail:(FailureBlockHandler)failure;

//获取商品品牌列表或价格列表
- (void)loadGoodsPriceOrBrandList:(NSDictionary*)postParams
                             type:(NSString*)typeName
                          success:(SuccessBlockHandler)success
                             fail:(FailureBlockHandler)failure;

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

//获取商品SKU
- (void)loadGoodsSKU:(NSDictionary*)postParams
             Success:(GeneralBlockHandler)success
                fail:(FailureBlockHandler)fail;

//获取商品优惠券列表
- (void)loadShoppingCouponsCart:(NSDictionary*)postParams
                        Success:(GeneralBlockHandler)success
                           fail:(FailureBlockHandler)fail;

//领取优惠券
- (void)takeCoupons:(NSDictionary*)postParams
            Success:(SuccessBlockHandler)success
               fail:(FailureBlockHandler)fail;

//获取评价列表
- (void)loadUserEvalutions:(NSDictionary*)postParams
                      type:(CZJHomeGetDataFromServerType)type
                   Success:(GeneralBlockHandler)success
                      fail:(FailureBlockHandler)fail;

//获取评价回复列表
- (void)loadUserEvalutionReplys:(NSDictionary*)postParams
                           type:(CZJHomeGetDataFromServerType)type
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

//关注门店
- (void)attentionStore:(NSDictionary*)postParams
               success:(SuccessBlockHandler)success;

//取消关注门店
- (void)cancleAttentionStore:(NSDictionary*)postParams
               success:(SuccessBlockHandler)success;

//关注商品
- (void)attentionGoods:(NSDictionary*)postParams
               success:(SuccessBlockHandler)success;

//取消关注商品
- (void)cancleAttentionGoods:(NSDictionary*)postParams
               success:(SuccessBlockHandler)success;

//其他门店列表
- (void)loadOtherStoreList:(NSDictionary*)postParams
                   success:(SuccessBlockHandler)success
                      fail:(FailureBlockHandler)failure;



//-------------------------发现数据------------------------------
//获取发现数据
- (void)showDiscoverWithBlocksuccess:(SuccessBlockHandler)success
                                fail:(FailureBlockHandler)fail;



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

//获取安装门店列表
- (void)loadStoreSetupList:(NSDictionary*)postParams
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

//获取已退换货列表
- (void)getReturnedOrderList:(NSDictionary*)postParams
                     Success:(SuccessBlockHandler)success
                        fail:(FailureBlockHandler)fail;

//获取可退换货列表
- (void)getReturnableOrderList:(NSDictionary*)postParams
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

//获取浏览记录
- (void)loadScanList:(NSDictionary*)postParams
             Success:(SuccessBlockHandler)success
                fail:(FailureBlockHandler)fail;

//清空浏览记录
- (void)clearScanList:(NSDictionary*)postParams
              Success:(SuccessBlockHandler)success
                 fail:(FailureBlockHandler)fail;

//搜索
- (void)searchAnything:(NSDictionary*)postParams
               Success:(SuccessBlockHandler)success
                  fail:(FailureBlockHandler)fail;

//获取服务分类
- (void)loadServiceType:(NSDictionary*)postParams
                Success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail;

//获取关注列表
- (void)loadMyAttentionList:(NSDictionary*)postParams
                    success:(SuccessBlockHandler)success
                       fail:(FailureBlockHandler)fail;

//取消关注列表
- (void)cancleAttentionList:(NSDictionary*)postParams
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

@end
