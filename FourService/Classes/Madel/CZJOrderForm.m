//
//  CZJOrderForm.m
//  CZJShop
//
//  Created by Joe.Pen on 1/7/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZJOrderForm.h"


@implementation FSOrderListForm
@end

@implementation FSOrderGoodsForm
//- (id) init
//{
//    if (self = [super init])
//    {
//        self.costPrice =  @"0";
//        self.currentPrice =  @"0";
//        self.setupPrice = @"0";
//        self.setmenuFlag = false;
//        self.setupFlag = false;
//        self.off = false;
//        return self;
//    }
//    return nil;
//}
@end


@implementation CZJOrderTypeForm
@end




@implementation FSOrderDetailForm

+ (NSDictionary *)objectClassInArray
{
    return @{@"order_step" : @"FSOrderGoodsForm"};
}

- (instancetype)init
{
    if (self = [super init])
    {
//        self.activityId = @"";
//        self.benefitMoney = @"";
//        self.companyId = @"";
//        self.couponPrice = @"";
//        self.createTime = @"";
//        self.evaluated = false;
//        self.fullCutPrice = @"";
//        self.items = [NSMutableArray array];
//        self.note = @"";
//        self.orderMoney = @"";
//        self.orderNo = @"";
//        self.orderPoint = @"";
//        self.orderPrice = @"";
//        self.paidFlag = false;
//        self.receiver = nil;
//        self.setupPrice = @"";
//        self.status = @"";
//        self.storeId = @"";
//        self.storeName = @"";
//        self.timeOver = @"";
//        self.transportPrice = @"";
//        self.type = @"";
        return self;
    }
    return nil;
}
@end

@implementation CZJSubmitReturnForm
@end

@implementation CZJPaymentOrderForm
@end
