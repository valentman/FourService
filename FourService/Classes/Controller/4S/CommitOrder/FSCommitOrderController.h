//
//  FSCommitOrderController.h
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCommitOrderForm : NSObject
@property (strong, nonatomic) NSString* car_id;
@property (strong, nonatomic) NSString* shop_id;
@property (strong, nonatomic) NSString* service_type_id;
@property (strong, nonatomic) NSString* remark;
@property (strong, nonatomic) NSArray* step_list;
@end



@interface FSCommitStepForm : NSObject
@property (strong, nonatomic) NSString* shop_service_step_id;
@property (strong, nonatomic) NSArray* product_list;
@end


@interface FSCommitProductForm : NSObject
@property (strong, nonatomic) NSString* product_id;
@end



@interface FSCommitOrderController : PBaseViewController
@property (strong, nonatomic) NSArray<FSServiceStepForm*>* orderServiceAry;
@property (strong, nonatomic) NSString* shopId;
@property (strong, nonatomic) NSString* serviceTypeId;
@end
