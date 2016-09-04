//
//  FSServiceForm.h
//  FourService
//
//  Created by Joe.Pen on 8/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//




#import <Foundation/Foundation.h>
//服务项目数据、服务列表
@interface FSServiceListForm : NSObject
@property (strong, nonatomic) NSString* service_type_id;
@property (strong, nonatomic) NSString* service_type_image;
@property (strong, nonatomic) NSString* service_type_script;
@property (strong, nonatomic) NSString* service_type_weight;
@property (strong, nonatomic) NSString* service_type_name;
@end

//门店图文数据
@interface FSStoreImageForm : NSObject
@property (strong, nonatomic) NSString* shop_image_id;
@property (strong, nonatomic) NSString* shop_id;
@property (strong, nonatomic) NSString* image_url;
@property (strong, nonatomic) NSString* image_name;
@property (strong, nonatomic) NSString* create_time;
@end

//对应服务提供门店数据
@interface FSStoreServiceListForm : NSObject
@property (strong, nonatomic) NSString* shop_service_type_id;
@property (strong, nonatomic) NSString* shop_id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* service_desc;
@property (strong, nonatomic) NSString* is_discount;
@property (strong, nonatomic) NSString* service_type_id;
@property (strong, nonatomic) NSString* service_image;
@end

//门店详情数据
@interface FSStoreInfoForm : NSObject
@property (strong, nonatomic) NSString* shop_service_type_id;
@property (strong, nonatomic) NSString* shop_id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* service_desc;
@property (strong, nonatomic) NSString* is_discount;
@property (strong, nonatomic) NSString* service_type_id;
@property (strong, nonatomic) NSString* service_image;
@property (strong, nonatomic) NSString* area_id;
@property (strong, nonatomic) NSString* shop_name;
@property (strong, nonatomic) NSString* shop_province;
@property (strong, nonatomic) NSString* shop_city;
@property (strong, nonatomic) NSString* shop_zone;
@property (strong, nonatomic) NSString* shop_address;
@property (strong, nonatomic) NSString* shop_tel;
@property (strong, nonatomic) NSString* shop_site;
@property (strong, nonatomic) NSString* shop_mail;
@property (strong, nonatomic) NSString* shop_wechat;
@property (strong, nonatomic) NSString* shop_weibo;
@property (strong, nonatomic) NSString* shop_like_num;
@property (strong, nonatomic) NSString* shop_view_num;
@property (strong, nonatomic) NSString* create_time;
@property (strong, nonatomic) NSString* professional_score;
@property (strong, nonatomic) NSString* environment_score;
@property (strong, nonatomic) NSString* service_score;
@property (strong, nonatomic) NSString* description_score;
@property (strong, nonatomic) NSString* shop_pho;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lng;
@property (strong, nonatomic) NSArray* service_list;
@property (strong, nonatomic) NSArray* shop_image_list;
@end

//服务步骤数据
@interface FSServiceStepForm : NSObject
@property (strong, nonatomic) NSString* shop_service_step_id;
@property (strong, nonatomic) NSString* shop_service_type_id;
@property (strong, nonatomic) NSString* step_name;
@property (strong, nonatomic) NSString* step_desc;
@property (strong, nonatomic) NSString* desc_image;
@property (strong, nonatomic) NSString* create_time;
@property (strong, nonatomic) NSArray* product_list;
@property (assign, nonatomic) BOOL is_expand;
@end

//服务步骤里面相关商品数据
@interface FSServiceStepProductForm : NSObject
@property (strong, nonatomic) NSString* order_step_product_id;
@property (strong, nonatomic) NSString* product_id;
@property (strong, nonatomic) NSString* shop_service_step_id;
@property (strong, nonatomic) NSString* creater;
@property (strong, nonatomic) NSString* create_time;
@property (strong, nonatomic) NSString* product_name;
@property (strong, nonatomic) NSString* product_image;
@property (strong, nonatomic) NSString* product_price;
@property (strong, nonatomic) NSString* product_script;
@property (strong, nonatomic) NSString* product_num;
@property (strong, nonatomic) NSString* product_type_id;
@property (strong, nonatomic) NSString* product_item_id;
@end