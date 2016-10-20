//
//  FSMyDiscountController.h
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSMyDiscountController : PBaseViewController

@end

@interface CZJMyWalletCouponListBaseController : UIViewController
{
    NSMutableDictionary* _params;
    NSInteger _couponType;
}
@property (assign, nonatomic)NSInteger couponType;
@property (strong, nonatomic)NSMutableDictionary* params;

- (void)getCouponListFromServer;
@end


@interface CZJMyWalletCouponUnUsedController : CZJMyWalletCouponListBaseController

@end

@interface CZJMyWalletCouponUsedController : CZJMyWalletCouponListBaseController

@end

@interface CZJMyWalletCouponOutOfTimeController : CZJMyWalletCouponListBaseController

@end