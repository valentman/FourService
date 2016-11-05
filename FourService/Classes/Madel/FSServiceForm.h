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
@property (strong, nonatomic) NSString* order_num;
@property (strong, nonatomic) NSString* comment_num;
@property (strong, nonatomic) NSString* service_discount;
@property (strong, nonatomic) NSString* service_price;
@property (strong, nonatomic) NSString* service_discount_price;
@property (strong, nonatomic) NSString* shop_score;
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
@property (strong, nonatomic) NSString* service_time;
@property (strong, nonatomic) NSArray* service_list;
@property (strong, nonatomic) NSArray* shop_image_list;
@property (strong, nonatomic) NSArray* comment_list;
@end

@interface FSStoreCommentForm : NSObject
@property(nonatomic, strong) NSString* order_comment_id;
@property(nonatomic, strong) NSString* shop_id;
@property(nonatomic, strong) NSString* order_id;
@property(nonatomic, strong) NSString* customer_id;
@property(nonatomic, strong) NSString* comment_time;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* comment_status;
@property(nonatomic, strong) NSString* comment_score;
@property(nonatomic, strong) NSString* username;
@property(nonatomic, strong) NSString* customer_pho;
@property(nonatomic, strong) NSArray* comment_image_list;
@end

@interface FSStoreCommentImageForm : NSObject
@property(nonatomic, strong) NSString* order_comment_image_id;
@property(nonatomic, strong) NSString* order_comment_id;
@property(nonatomic, strong) NSString* image_name;
@property(nonatomic, strong) NSString* image_url;
@property(nonatomic, strong) NSString* create_time;
@end

//服务套餐ABC数据
@interface FSServiceSegmentTypeForm : NSObject
@property (strong, nonatomic) NSString* shop_service_type_item_id;
@property (strong, nonatomic) NSString* shop_service_type_id;
@property (strong, nonatomic) NSString* item_name;
@property (strong, nonatomic) NSString* item_desc;
@property (strong, nonatomic) NSString* item_cost;
@property (strong, nonatomic) NSString* desc_image;
@property (strong, nonatomic) NSString* create_time;
@property (strong, nonatomic) NSString* creator;
@property (strong, nonatomic) NSArray* step_list;
@end

//服务步骤数据
@interface FSServiceStepForm : NSObject
@property (strong, nonatomic) NSString* shop_service_step_id;
@property (strong, nonatomic) NSString* shop_service_type_id;
@property (strong, nonatomic) NSString* step_name;
@property (strong, nonatomic) NSString* step_desc;
@property (strong, nonatomic) NSString* desc_image;
@property (strong, nonatomic) NSString* create_time;
@property (assign, nonatomic) float stepPrice;
@property (strong, nonatomic) NSMutableArray* product_list;
@property (assign, nonatomic) BOOL is_expand;
@property (assign, nonatomic) BOOL is_Edit;
@end

//服务步骤里面相关商品数据
@interface FSServiceStepProductForm : NSObject
@property (strong, nonatomic) NSString* brand_id;
@property (strong, nonatomic) NSString* create_time;
@property (strong, nonatomic) NSString* creater;
@property (strong, nonatomic) NSString* item_color;
@property (strong, nonatomic) NSString* item_name;
@property (strong, nonatomic) NSString* item_size;
@property (strong, nonatomic) NSString* product_bar_code;
@property (strong, nonatomic) NSString* product_buy_num;
@property (strong, nonatomic) NSString* product_comment_num;
@property (strong, nonatomic) NSString* product_desc;
@property (strong, nonatomic) NSString* product_favorite_num;
@property (strong, nonatomic) NSString* product_id;
@property (strong, nonatomic) NSString* product_item_id;
@property (strong, nonatomic) NSString* product_like_num;
@property (strong, nonatomic) NSString* product_material;
@property (strong, nonatomic) NSString* product_name;
@property (strong, nonatomic) NSString* product_section_code;
@property (strong, nonatomic) NSString* product_type;
@property (strong, nonatomic) NSString* product_view_num;
@property (strong, nonatomic) NSString* production_date;
@property (strong, nonatomic) NSString* sale_price;
@property (strong, nonatomic) NSString* service_step_product_id;
@property (strong, nonatomic) NSString* shop_service_step_id;
@property (strong, nonatomic) NSString* stock;
@property (strong, nonatomic) NSString* sub_type_id;
@property (strong, nonatomic) NSString* sub_type_name;
@property (strong, nonatomic) NSString* type_name;
@property (strong, nonatomic) NSArray* product_image_list;
@end


//商品详情数据
@interface FSProductDetailForm : NSObject
@property (strong, nonatomic) NSString* product_id;
@property (strong, nonatomic) NSString* type_id;
@property (strong, nonatomic) NSString* brand_id;
@property (strong, nonatomic) NSString* product_item_id;
@property (strong, nonatomic) NSString* product_name;
@property (strong, nonatomic) NSString* product_desc;
@property (strong, nonatomic) NSString* product_bar_code;
@property (strong, nonatomic) NSString* product_section_code;
@property (strong, nonatomic) NSString* production_date;
@property (strong, nonatomic) NSString* product_material;
@property (strong, nonatomic) NSString* product_type;
@property (strong, nonatomic) NSString* product_like_num;
@property (strong, nonatomic) NSString* product_view_num;
@property (strong, nonatomic) NSString* product_comment_num;
@property (strong, nonatomic) NSString* product_favorite_num;
@property (strong, nonatomic) NSString* product_buy_num;
@property (strong, nonatomic) NSArray* product_image_list;
@property (strong, nonatomic) NSString* item_name;
@property (strong, nonatomic) NSString* item_color;
@property (strong, nonatomic) NSString* item_size;
@property (strong, nonatomic) NSString* sale_price;
@property (strong, nonatomic) NSString* stock;
@property (strong, nonatomic) NSArray* comment_list;
@end


//商品图片
@interface FSProductImageForm : NSObject
@property (strong, nonatomic) NSString* img_id;
@property (strong, nonatomic) NSString* product_id;
@property (strong, nonatomic) NSString* img_url;
@property (strong, nonatomic) NSString* img_name;
@end


//评论列表
@interface FSCommentForm : NSObject
@property (strong, nonatomic) NSString* comment_id;
@property (strong, nonatomic) NSString* product_id;
@property (strong, nonatomic) NSString* customer_id;
@property (strong, nonatomic) NSString* product_comment;
@property (strong, nonatomic) NSString* comment_time;
@property (strong, nonatomic) NSString* comment_status;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* customer_pho;
@property (strong, nonatomic) NSArray* comment_image_list;
@end

//评论图片
@interface FSCommentImageForm : NSObject
@property (strong, nonatomic) NSString* product_comment_image_id;
@property (strong, nonatomic) NSString* product_comment_id;
@property (strong, nonatomic) NSString* image_name;
@property (strong, nonatomic) NSString* image_url;
@end
