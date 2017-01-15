//  /**  统一加CZJ（车之健）前缀 **/
//  FSDefinition.h
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#ifndef FSDefinition_h
#define FSDefinition_h

//----------------------------服务器接口-------------------------------
//服务地址
static NSString *const kCZJServerAddr = @"http://119.29.135.211/";                              //线上正式环境

//首页接口组 
static NSString *const kFSServerAPIShowHome = @"Home/home";                                     //获取首页数据
static NSString *const kFSServerAPILottery = @"Home/lucky/activity_id/1";                       //抽奖

//登录模块接口组
static NSString *const kFSServerAPIRegister = @"Login/register";                                //注册
static NSString *const kFSServerAPILogin = @"Login/customerLogin";                              //登录
static NSString *const kFSServerAPILoginOut = @"Login/customerLogout";                          //注销
static NSString *const kFSServerAPIVerifyCode = @"Login/verify";                                //验证码
static NSString *const kFSServerAPICheckVerifyCode = @"Login/checkVerify";                      //确认验证码

//个人信息模块接口组
static NSString *const kFSServerAPIGetMyInfo = @"Customer/customerInfo";                        //个人信息
static NSString *const kFSServerAPIEditMyInfo = @"Customer/editCustomer";                       //编辑个人信息
static NSString *const kFSServerAPIUploadHeadImage = @"Customer/uploadHeadImage";               //上传头像
static NSString *const kFSServerAPIAddMyCar = @"Customer/addCustomerCar";                       //增加车辆
static NSString *const kFSServerAPIDeleteMyCar = @"Customer/delCustomerCar";                    //删除车辆
static NSString *const kFSServerAPIEditMyCar = @"Customer/editCustomerCar";                     //编辑车辆
static NSString *const kFSServerAPIGetCarBrands = @"Common/carBrand";                           //车辆品牌
static NSString *const kFSServerAPIGetCarModels = @"Common/carModel";                           //品牌车系
static NSString *const kFSServerAPIGetCarTypes = @"Common/carType";                             //车系车型
static NSString *const kFSServerAPIScanList = @"Customer/customerShopViewList";                 //足迹
static NSString *const kFSServerAPIFavoriteList = @"Customer/customerShopFavoriteList";         //收藏
static NSString *const kFSServerAPIEvalutionList = @"";                                         //评价列表
static NSString *const kFSServerAPIDiscountList = @"Customer/customerDiscountList";             //优惠券
static NSString *const kFSServerAPIOrderList = @"Customer/customerOrderList";                   //订单列表
static NSString *const kFSServerAPIOrderDetail = @"Customer/orderDetail";                       //订单详情


//4s服务接口组
static NSString *const kFSServerAPIServiceList = @"Service/serviceList";                        //服务列表
static NSString *const kFSServerAPIStoreList = @"Service/shopList";                             //门店列表
static NSString *const kFSServerAPIStoreDetail = @"Service/shopInfo";                           //门店详情
static NSString *const kFSServerAPIStoreEvaluate = @"Service/shopCommentList";                  //门店评论列表
static NSString *const kFSServerAPIServiceStepList = @"Service/serviceStep";                    //服务步骤列表
static NSString *const kFSserverAPIProductChangeable= @"Service/sameProductList";               //可更换商品列表
static NSString *const kFSServerAPIProductDetailInfo = @"Service/productInfo";                  //商品详情
static NSString *const kFSServerAPIProductEvaluate = @"Service/productCommentList";             //商品评论列表
static NSString *const kFSServerAPICommitOrder = @"Service/bookOrder";                          //提交订单
static NSString *const kFSServerAPIUploadImage = @"Service/uploadImage";                        //上传图片
static NSString *const kFSServerAPIOrderEvaluate = @"Service/orderComment";                     //订单评价





static NSString *const kCZJServerAPILoadCarBrands = @"http://czapp.chezhijian.com/appserver/chezhu/loadCarBrandsV2.do";                   //获取汽车品牌列表
static NSString *const kCZJServerAPILoadCarSeries = @"http://czapp.chezhijian.com/appserver/chezhu/loadCarSeries.do";                     //获取汽车品牌车系列表

static NSString *const kCZJServerAPILoadCarModels = @"http://czapp.chezhijian.com/appserver/chezhu/loadCarModels.do";                     //获取汽车品牌车系列表
static NSString *const kCZJServerAPIPayWeixinNotify = @"chezhu/notifyForWeixin.do";                 //微信支付回调
static NSString *const kCZJServerAPIPayZhifubaoNotify = @"chezhu/notifyForZhifubao.do";             //支付宝支付回调
static NSString *const kCZJServerAPIChargeForWeixin = @"chezhu/chargeForWeixin.do";                 //充值微信支付回调
static NSString *const kCZJServerAPIChargeForZhifubao = @"chezhu/chargeForZhifubao.do";             //充值支付宝支付回调
static NSString *const kCZJServerAPIGetWeixinPayParams = @"chezhu/getPayParams.do";                 //获取微信支付参数



//-------------------------------分享-------------------
static NSString *const kCZJGoodsShare = @"chezhu/showGoodsShare.do";                                //分享商品
static NSString *const kCZJServiceShare = @"chezhu/showServiceShare.do";                            //分享服务
static NSString *const kCZJStoreShare = @"chezhu/showStoreShare.do";                                //分享门店
static NSString *const SHARE_URL = @"http://czapp.FourService.com/appserver/html/share.html";        //分享的url
static NSString *const SHARE_LOGO_URL = @"http://czapp.FourService.com/appserver/images/logo.png";   //分享的LOGO
static NSString *const SHARE_CONTENT = @"车之健是汽车后市场的移动商城,每用一次,多省一点";                  //分享的内容



//--------------------------------------------------
static NSString *const REDPACKET_HINT = @"jsp/redpacket.jsp";                                       //红包使用说明
static NSString *const CODE_HINT = @"jsp/couponCode.jsp";                                           //优惠码使用说明
static NSString *const YUE_HINT = @"jsp/cardmoney.jsp";                                             //余额使用说明
static NSString *const COUPON_HINT = @"jsp/coupon.jsp";                                             //优惠券使用说明
static NSString *const MemberCard_HINT = @"jsp/memberCard.jsp";                                     //会员卡使用说明
static NSString *const PointCard_HINT = @"jsp/pointCard.jsp";                                       //积分卡使用说明
static NSString *const SetMenuCard_HINT = @"jsp/setmenuCard.jsp";                                   //套餐卡使用说明

static NSString *const SUOLUE_PIC_200 = @"?imageView2/1/w/200/h/200/q/75";
static NSString *const SUOLUE_PIC_600 = @"?imageView2/1/w/600/h/600/q/75";
static NSString *const SUOLUE_PIC_1000 = @"?imageView2/1/w/1000/h/1000/q/75";
static NSString *const SUOLUE_PIC_400 = @"?imageView2/1/w/400/h/400/q/75";


//-----------------------系统常量定义---------------------------
//在应用商店中本APP的地址
static NSString *const kCZJAPPURL = @"https://itunes.apple.com/us/app/id1035567397";
static NSString *const kCZJAPPURLVersionCheck = @"http://itunes.apple.com/lookup";

//第三方推送服务方申请的AppID和AppKey,暂时使用信鸽的。
static uint32_t const kCZJPushServerAppId = 2200242393;
static NSString *const kCZJPushServerAppKey = @"IS4EG86J1S2N";

//分享设置ID
static NSString *const kCZJOpenShareQQAppId = @"1105749219";
static NSString *const kCZJOpenShareWeiboAppKey = @"2884886503";
static NSString *const kCZJOpenShareWeixinAppId = @"wx8fb9def99081a89f";


//----------------------本地Plist文件名--------------------------
static NSString *const kCZJPlistFileProvinceCitys = @"ProvinceCitys.plist";                 //省份城市列表文件
static NSString *const kCZJPlistFileMessage = @"Message.plist";                             //信息管理文件
static NSString *const kCZJPlistFileSearchHistory = @"SearchHistory.plist";                 //搜索栏历史文件
static NSString *const kCZJPlistFileDefaultDeliveryAddr = @"UserDefaultDeliveryAddr.plist"; //默认收货地址
static NSString *const kCZJPlistFileUserBaseForm = @"userBaseForm.plist";


//----------------------UserDefault键名定义
static NSString *const kUserDefaultTimeDay = @"userdefaultTimeDay";                         //以天为间隔时间
static NSString *const kUserDefaultTimeMin = @"userdefaultTimeMin";                         //以分钟为间隔时间
static NSString *const kUserDefaultTimeMinLocation = @"userdefaultTimeMinLocation";         //定位间隔时间
static NSString *const kUserDefaultRandomCode = @"userdefaultRandomCode";                   //随机码
static NSString *const kUserDefaultServiceTypeID = @"userdefaultserviceyypeid";             //服务项目ID
static NSString *const kUserDefaultChoosedCarModelType = @"userdefaultchoosedcarmodel";     //选择的车型名称
static NSString *const kUserDefaultChoosedCarModelID = @"userdefaultchoosedcarmodelID";     //选择的车型ID
static NSString *const kUserDefaultChoosedBrandID = @"userdefaultchoosedgoodbrandID";       //选择的商品品牌ID
static NSString *const kUserDefaultStartPrice = @"userdefaultstarprice";                    //起价
static NSString *const kUserDefaultEndPrice = @"userdefaultendprice";                       //顶价
static NSString *const kUserDefaultServicePlace = @"userdefaultserviceplace";               //上门服务
static NSString *const kUserDefaultDetailStoreItemPid = @"DetailStoreItemPid";              //详情界面storeitemPid
static NSString *const kUserDefaultDetailItemCode = @"DetailItemCode";                      //详情界面Itemcode
static NSString *const kUserDefaultShoppingCartCount = @"ShoppingCartCount";                //购物车数量
static NSString *const kUSerDefaultSexual = @"sexual";

static NSString *const kUSerDefaultStockFlag = @"stockFlag";                                //有货与否
static NSString *const kUSerDefaultPromotionFlag = @"promotionFlag";                        //促销与否
static NSString *const kUSerDefaultRecommendFlag = @"recommendFlag";                        //推荐与否

static NSString *const kUserDefaultStartPageUrl = @"StartPageUrl";                          //启动页图片地址
static NSString *const kUserDefaultStartPageImagePath = @"StartPageImagePath";              //启动页图片地址
static NSString *const kUserDefaultStartPageForm = @"StartPageForm";                        //启动页数据
static NSString *const kUserDefaultDeviceTokenStr = @"DeviceTokenStr";                      //设备Token
static NSString *const kuserDefaultPushNotification = @"PushNotification";                  //是否开启消息推送


//-----------------------常用字符常量定义---------------------------
//登录信息
static NSString *const kCZJLastVersion = @"lastVersion";
static NSString *const kCZJIsFirstLogin = @"isFirstLogin";
static NSString *const kCZJIsUserHaveLogined = @"isHaveLogined";

//城市定位
static NSString *const kCZJDefaultCityID = @"defaultyCityId";
static NSString *const kCZJDefaultyCityName = @"defaultyCityName";
static NSString *const kCZJChengdu = @"成都市";
static NSString *const kCZJChengduID = @"469";

//Alert提示字符串
static NSString *const kCZJTitle = @"提示";
static NSString *const kCZJMessageUpdate = @"您需去应用商店更新版本，否则将无法正常使用";
static NSString *const kCZJMessageNet = @"网络异常，请确认当前网络是否连接。";
static NSString *const kCZJConfirmUpdateTitle = @"更新";
static NSString *const kCZJConfirmTitle = @"确定";
static NSString *const kCZJCancelTitle = @"取消";

//版本检测
static NSString *const kCZJChangeCurCityName = @"changeCurCityName";
static NSString *const kCZJAlipaySuccseful = @"alipaySuccseful";


//-----------------------Notification常量定义---------------------------
static NSString *const kCZJNotifiRefreshDetailView = @"refreshDetailView";
static NSString *const kCZJNotifiPicDetailBack = @"PicDetailBack";
static NSString *const kCZJNotifiJumpToOrderList = @"jumptoOrderList";
static NSString *const kCZJNotifikOrderListType = @"kOrderListType";
static NSString *const kCZJNotifiRefreshOrderlist = @"refreshOrderListNotify";
static NSString *const kCZJNotifiRefreshReturnOrderlist = @"refreshReturnOrderListNotify";
static NSString *const kCZJNotifiMoveChatView = @"moveChatview";
static NSString *const kCZJNotifiRefreshMessageReadStatus = @"refreshMessageReadStatus";        //新消息已读
static NSString *const kCZJNotifiGetNewNotify = @"getNewNotify";                                //新消息通知
static NSString *const kCZJNotifiLoginSuccess = @"loginSuccess";                                //登录成功
static NSString *const kCZJNotifiLoginOut = @"loginout";                                        //退出登录
static NSString *const kCZJNotifiNotCurrentCity = @"notCurrentcity";                            //切换城市
static NSString *const kFSNotifiShowAlertView = @"showAlertView";
static NSString *const kFSNotifiSendEvent = @"sendEvent";


//-----------------------StoryBoardID常量定义---------------------------
static NSString *const kCZJStoryBoardFileMain = @"Main";
static NSString *const kCZJStoryBoardIDHomeView = @"homeViewSBID";
static NSString *const kCZJStoryBoardIDMyInfoView = @"MyInfoSBID";
static NSString *const kCZJStoryBoardIDStartPage = @"startPageSBID";
static NSString *const kCZJStoryBoardIDConfirmPay = @"confirmPaySBID";
static NSString *const kCZJStoryBoardIDGoodsDetailVC = @"goodsDetailSBID";              //商品或服务详情
static NSString *const kCZJStoryBoardIDStoreDetailVC = @"storeDetailVC";                //门店详情
static NSString *const kCZJStoryBoardIDPaymentSuccess = @"paymentSuccessSBID";          //订单支付成功
static NSString *const kCZJStoryBoardIDCommitSettle = @"SBIDCommitSettle";
static NSString *const kCZJStoryBoardIDMyOrderList = @"myOrderSBID";                    //订单列表
static NSString *const kCZJStoryBoardIDScanQR= @"scanQRSBID";                           //订单列表
static NSString *const kCZJStoryBoardIDRecord = @"myScanRecordSBID";                    //浏览记录


//-----------------------CollectionViewCellIdentifier常量定义---------------------------
static NSString *const kCZJCollectionCellReuseIdMiaoSha = @"CZJMiaoShaCollectionCell";
static NSString *const kCZJCollectionCellReuseIdLimit = @"CZJLimitCollectionCell";
static NSString *const kCZJCollectionCellReuseIdGoodReco = @"CZJGoodsRecoCollectionCell";

static NSString *const kServiceCollectionViewCell = @"FSServiceCell";



////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
static NSString *const kResoponCode = @"code";
static NSString *const kResoponData = @"data";
static NSString *const kResoponMessage = @"message";


#endif /* FSDefinition_h */


