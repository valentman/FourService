//
//  FSMyInfoForm.h
//  FourService
//
//  Created by Joe.Pen on 7/14/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSPersonalForm : NSObject
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* chinese_name;
@property (strong, nonatomic)NSString* english_name;
@property (strong, nonatomic)NSString* customer_identity;
@property (strong, nonatomic)NSString* customer_pho;
@property (strong, nonatomic)NSString* customer_wechat;
@property (strong, nonatomic)NSString* customer_mail;
@property (strong, nonatomic)NSString* customer_sex;
@property (strong, nonatomic)NSString* customer_height;
@property (strong, nonatomic)NSString* customer_weight;
@property (strong, nonatomic)NSString* customer_birthday;
@property (strong, nonatomic)NSString* customer_remark;
@property (strong, nonatomic)NSString* customer_qq;
@property (strong, nonatomic)NSString* last_login;
@property (strong, nonatomic)NSString* reg_ip;
@property (strong, nonatomic)NSString* last_ip;
@property (strong, nonatomic)NSString* login_num;
@property (strong, nonatomic)NSString* customer_status;
@property (strong, nonatomic)NSString* reg_time;
@property (strong, nonatomic)NSString* username;
@property (strong, nonatomic)NSString* lucky_times;
@property (strong, nonatomic)NSString* customer_photo;
@property (strong, nonatomic)NSString* customer_score;
@property (strong, nonatomic)NSString* identifier;
@property (strong, nonatomic)NSString* token;
@property (strong, nonatomic)NSString* timeout;
@end


@interface FSDiscountForm : NSObject
@property (strong, nonatomic)NSString* customer_discount_id;
@property (strong, nonatomic)NSString* discount_id;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* get_time;
@property (strong, nonatomic)NSString* get_way;
@property (strong, nonatomic)NSString* discount_status;
@end

@interface FSDiscountNormalForm : FSDiscountForm
@end

@interface FSDiscountUsedForm : FSDiscountForm
@end

@interface FSDiscountExpiredForm : FSDiscountForm
@end


@interface FSCarListForm : NSObject
@property (strong, nonatomic)NSString* car_id;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* car_type_id;
@property (strong, nonatomic)NSString* buy_date;
@property (strong, nonatomic)NSString* maintain_date;
@property (strong, nonatomic)NSString* vin_code;
@property (strong, nonatomic)NSString* engine_code;
@property (strong, nonatomic)NSString* remark;
@property (strong, nonatomic)NSString* is_default;
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* update_time;
@property (strong, nonatomic)NSString* car_type_name;
@property (strong, nonatomic)NSString* car_model_name;
@property (strong, nonatomic)NSString* car_brand_image;     //服务器须添加字段(品牌车标图)
@property (strong, nonatomic)NSString* prov;                //服务器须添加字段(省份简称（如：川）)
@property (strong, nonatomic)NSString* number;              //服务器须添加字段(地级市代号（如：L）)
@property (strong, nonatomic)NSString* numberPlate;         //服务器须添加字段(车牌号（如：M8195）)
@end


@interface FSCustomerViewdForm : NSObject
@property (strong, nonatomic)NSString* customer_shop_view_id;
@property (strong, nonatomic)NSString* shop_id;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* view_time;
@end


@interface FSCustomerFavoriteForm : NSObject
@property (strong, nonatomic)NSString* customer_shop_view_id;
@property (strong, nonatomic)NSString* shop_id;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* view_time;
@end


@interface FSShopCommentForm : NSObject
@property (strong, nonatomic)NSString* shop_comment_id;
@property (strong, nonatomic)NSString* shop_id;
@property (strong, nonatomic)NSString* customer_id;
@property (strong, nonatomic)NSString* order_id;
@property (strong, nonatomic)NSString* professional_score;
@property (strong, nonatomic)NSString* environment_score;
@property (strong, nonatomic)NSString* service_score;
@property (strong, nonatomic)NSString* description_score;
@end



