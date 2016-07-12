//
//  FSWebViewJSI.m
//  FourService
//
//  Created by Joe.Pen on 2/27/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "FSWebViewJSI.h"
#import "FSBaseDataManager.h"
#import "AppDelegate.h"

@implementation FSWebViewJSI
#pragma mark- JSAction
- (void)toGoodsOrServiceInfo:(NSArray*)json
{
    NSDictionary* ns1 = [PUtils dictionaryFromJsonString:[json firstObject]];
    [self.JSIDelegate showGoodsOrServiceInfo:ns1];
}

- (void)toStoreInfo:(NSArray*)json
{
    NSString* ns1 = [PUtils resetString:[json firstObject]];
    NSLog(@"%@",ns1);
    [self.JSIDelegate showStoreInfo:ns1];
}

- (void)jiesuan:(NSArray*)json
{
    DLog(@"jiesuan:%@, cout:%@",json[0],json[1]);
//    BOOL coupnuseable = [json[1] isEqualToString:@"0"] ? YES : NO;
//    NSArray* settle = [CZJSettleOrderForm objectArrayWithKeyValuesArray:json[0]];
//    NSMutableArray* settleKeyvalues = [NSMutableArray array];
//    for (CZJSettleOrderForm* orderForm in settle)
//    {
//        [settleKeyvalues addObject:orderForm.keyValues];
//    }
//    [self.JSIDelegate toSettleOrder:settleKeyvalues andCouponUsable:coupnuseable];
}


-(void)showToast:(NSArray*)cars{
    NSString* ns1 = [PUtils resetString:[cars firstObject]];
    NSLog(@"%@",ns1);
    [self.JSIDelegate showToast:ns1];
}

-(void)getChezhuInfo{
}

- (void)logon
{
    if (![USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
    {
        UIViewController* currentVC = ((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController;
        [PUtils showLoginView:currentVC andNaviBar:nil];
    }
}

- (void)toShare:(NSArray*)json
{
    [self.JSIDelegate toShare:json];
}

@end
