//
//  CZJOrderForm.h
//  CZJShop
//
//  Created by Joe.Pen on 1/7/16.
//  Copyright © 2016 JoeP. All rights reserved.
//
#import <Foundation/Foundation.h>

@class CZJOrderDetailBuildForm;
@class CZJCarDetailForm;

//====================== 订单列表数据 =======================
@interface FSOrderListForm : NSObject
@property (strong, nonatomic) NSString *car_id;
@property (strong, nonatomic) NSString *create_time;
@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *customer_pho;
@property (strong, nonatomic) NSString *customer_username;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *service_type_id;
@property (strong, nonatomic) NSString *service_type_image;
@property (strong, nonatomic) NSString *service_type_name;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_tel;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *username;
@end

//====================== 订单商品或服务数据 =======================
@interface FSOrderGoodsForm : NSObject
@property (strong, nonatomic) NSString *desc_image;
@property (strong, nonatomic) NSArray *image_list;
@property (strong, nonatomic) NSString *item_color;
@property (strong, nonatomic) NSString *item_name;
@property (strong, nonatomic) NSString *item_size;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString *order_step_id;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSString *shop_service_step_id;
@property (strong, nonatomic) NSString *step_desc;
@property (strong, nonatomic) NSString *step_name;
@end


//====================== 订单详情 =======================
@interface FSOrderDetailForm : NSObject
@property (strong, nonatomic)NSString* car_id;
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* customer_pho;
@property (strong, nonatomic)NSString* customer_username;
@property (strong, nonatomic)NSString* order_id;
@property (strong, nonatomic)NSArray* order_step;
@property (strong, nonatomic)NSString* pay_result;
@property (strong, nonatomic)NSString* pay_time;
@property (strong, nonatomic)NSString* pay_way;
@property (strong, nonatomic)NSString* price;
@property (strong, nonatomic)NSString* remark;
@property (strong, nonatomic)NSString* service_type_id;
@property (strong, nonatomic)NSString* service_type_image;
@property (strong, nonatomic)NSString* service_type_name;
@property (strong, nonatomic)NSString* shop_address;
@property (strong, nonatomic)NSString* shop_id;
@property (strong, nonatomic)NSString* shop_name;
@property (strong, nonatomic)NSString* shop_tel;
@property (strong, nonatomic)NSString* status;
@property (strong, nonatomic)NSString* username;
@end


@interface CZJSubmitReturnForm : NSObject
@property (strong, nonatomic)NSString* returnType;
@property (strong, nonatomic)NSString* returnNote;
@property (strong, nonatomic)NSString* orderItemPid;
@property (strong, nonatomic)NSString* returnReason;
@property (strong, nonatomic)NSString* returnImgs;
@end

@interface CZJPaymentOrderForm : NSObject
@property (nonatomic, strong) NSString* order_no;
@property (nonatomic, strong) NSString* order_name;
@property (nonatomic, strong) NSString* order_description;
@property (nonatomic, strong) NSString* order_price;
@property (nonatomic, strong) NSString* order_for;
@end

@interface CZJOrderTypeForm : NSObject
@property(strong, nonatomic)NSString* orderTypeName;
@property(strong, nonatomic)NSString* orderTypeImgSelect;
@property(strong, nonatomic)NSString* orderTypeImg;
@property(assign) BOOL isSelect;
@end
