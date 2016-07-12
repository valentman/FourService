//
//  FSPaymentManager.h
//  FourService
//
//  Created by Joe.Pen on 3/14/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FSPaymentManager : NSObject
{
    PBaseViewController* _targetViewController;
//    CZJPaymentOrderForm* _paymentOrderForm;
}
@property (strong, nonatomic)PBaseViewController* targetViewController;
singleton_interface(FSPaymentManager);
//- (void)weixinPay:(PBaseViewController*)target
//        OrderInfo:(CZJPaymentOrderForm*)_orderDict
//          Success:(paySuccess)sucsess
//             Fail:(payFail)fail;
//- (void)aliPay:(PBaseViewController*)target
//     OrderInfo:(CZJPaymentOrderForm*)_orderDict
//       Success:(paySuccess)success
//          Fail:(payFail)fail;
@end
