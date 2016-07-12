//
//  FSWebViewJSI.h
//  FourService
//
//  Created by Joe.Pen on 2/27/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJsBridge.h"

//实现这个代理的是NativeVC，也就是FSWebViewController
@protocol jsActionDelegate <NSObject>
@optional
- (void)showToast:(NSString*)msg;
- (void)showGoodsOrServiceInfo:(NSDictionary*)storeItemPid;
- (void)showStoreInfo:(NSString*)storeId;
- (void)toSettleOrder:(NSArray*)goodsInfo andCouponUsable:(BOOL)couponUseable;
- (void)toShare:(NSArray*)json;
@end

@interface FSWebViewJSI : WebViewJsBridge
@property (nonatomic, assign) id<jsActionDelegate> JSIDelegate;

//V2.0
- (void)toGoodsOrServiceInfo:(NSArray*)json;            //跳转到商品或服务详情
- (void)toStoreInfo:(NSArray*)json;                     //跳转到门店详情
- (void)jiesuan:(NSArray*)json;                         //结算
- (void)showToast:(NSString*)json;                      //提示框
- (void)toShare:(NSString*)json;
@end
