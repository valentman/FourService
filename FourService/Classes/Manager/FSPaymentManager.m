//
//  FSPaymentManager.m
//  FourService
//
//  Created by Joe.Pen on 3/14/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "FSPaymentManager.h"
#import "FSBaseDataManager.h"
#import "payRequsestHandler.h"
#import "OpenShareHeader.h"
#import "AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "CZJOrderPaySuccessController.h"
//#import "CZJCommitOrderController.h"

@implementation FSPaymentManager
singleton_implementation(FSPaymentManager);


//- (void)weixinPay:(PJViewController*)target
//        OrderInfo:(CZJPaymentOrderForm*)_orderDict
//          Success:(paySuccess)sucsess
//             Fail:(payFail)fail
//{
//    self.targetViewController = target;
//    _paymentOrderForm = _orderDict;
//    //请求支付的uil
//    [FSBaseDataInstance generalPost:@{@"payMethod":@"1"} success:^(id json) {
//        DLog(@"支付管理单例类请求微信支付信息返回成功");
//        NSDictionary* dict = [PUtils DataFromJson:json];
//        NSDictionary* subDict = [dict valueForKey:@"msg"];
//        NSString* appid = [subDict valueForKey:@"appid"];
//        NSString* partnerid = [subDict valueForKey:@"partnerid"];
//        
//        payRequsestHandler* tst = [payRequsestHandler alloc];
//        [tst init:appid mch_id:partnerid];
//        [tst setKey:PARTNER_ID];
//        NSString* lk = [tst sendPayWithOrderInfo:[_paymentOrderForm keyValues]];
//        
//        __weak typeof(self) weak = self;
//        if (lk) {
//            DLog(@"支付管理类生成订单信息微信支付URL");
//            [OpenShare WeixinPay:lk Success:^(NSDictionary *message) {
//                [weak jumpToSuc:message];
//            } Fail:^(NSDictionary *message, NSError *error) {
//                fail(message,error);
//            }];
//        }
//    }  fail:^{
//        
//    } andServerAPI:kCZJServerAPIGetWeixinPayParams];
//}
//
//- (void)aliPay:(PJViewController*)target
//     OrderInfo:(CZJPaymentOrderForm*)_orderDict
//       Success:(paySuccess)success
//          Fail:(payFail)fail
//{
//    _paymentOrderForm = _orderDict;
//    self.targetViewController = target;
//    __weak typeof(self) weak = self;
//    AliPayManager* tmp =[[AliPayManager alloc] init];
//    DLog(@"支付管理单例类请求支付宝支付信息,AliPayManager:%@",tmp);
//    [tmp generateWithOrderDict:[_paymentOrderForm keyValues] Success:^(NSDictionary *message) {
//        [weak jumpToSuc:message];
//    } Fail:^(NSDictionary *message, NSError *error) {
//        fail(message,error);
//    }];
//}

-(void)jumpToSuc:(id)info
{
    UINavigationController* mynavi = self.targetViewController.navigationController;
    [mynavi popViewControllerAnimated:NO];
    
//    CZJOrderPaySuccessController *paySuccessVC = (CZJOrderPaySuccessController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:kCZJStoryBoardIDPaymentSuccess];
//    paySuccessVC.orderNo= _paymentOrderForm.order_no;
//    paySuccessVC.orderPrice = _paymentOrderForm.order_price;
//    [mynavi pushViewController:paySuccessVC animated:YES];
}

@end
