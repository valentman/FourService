//
//  FSStoreServiceForm.h
//  FourService
//
//  Created by Joe.Pen on 7/30/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSStoreDetailForm : NSObject
@property(nonatomic, strong) NSString* area_id;
@property(nonatomic, strong) NSString* create_time;
@property(nonatomic, strong) NSString* customer_id;
@property(nonatomic, strong) NSString* description_score;
@property(nonatomic, strong) NSString* environment_score;
@property(nonatomic, strong) NSString* professional_score;
@property(nonatomic, strong) NSString* service_score;
@property(nonatomic, strong) NSString* shop_address;
@property(nonatomic, strong) NSString* shop_city;
@property(nonatomic, strong) NSString* shop_id;
@property(nonatomic, strong) NSString* shop_mail;
@property(nonatomic, strong) NSString* shop_name;
@property(nonatomic, strong) NSString* shop_province;
@property(nonatomic, strong) NSString* shop_site;
@property(nonatomic, strong) NSString* shop_tel;
@property(nonatomic, strong) NSString* shop_view_num;
@property(nonatomic, strong) NSString* shop_like_num;
@property(nonatomic, strong) NSString* customer_shop_view_id;
@property(nonatomic, strong) NSString* shop_wechat;
@property(nonatomic, strong) NSString* shop_weibo;
@property(nonatomic, strong) NSString* shop_zone;
@property(nonatomic, strong) NSString* shop_img;
@property(nonatomic, strong) NSString* view_time;

@end


@interface FSViewedForm : NSObject
@property(nonatomic, strong) NSString* area_id;
@property(nonatomic, strong) NSString* create_time;
@property(nonatomic, strong) NSString* customer_id;
@property(nonatomic, strong) NSString* customer_shop_view_id;
@property(nonatomic, strong) NSString* description_score;
@property(nonatomic, strong) NSString* environment_score;
@property(nonatomic, strong) NSString* lat;
@property(nonatomic, strong) NSString* lng;
@property(nonatomic, strong) NSString* order_num;
@property(nonatomic, strong) NSString* pay_type;
@property(nonatomic, strong) NSString* professional_score;
@property(nonatomic, strong) NSString* service_score;
@property(nonatomic, strong) NSString* service_time;
@property(nonatomic, strong) NSString* shop_address;
@property(nonatomic, strong) NSString* shop_id;
@property(nonatomic, strong) NSString* shop_like_num;
@property(nonatomic, strong) NSString* shop_mail;
@property(nonatomic, strong) NSString* shop_name;
@property(nonatomic, strong) NSString* shop_pho;
@property(nonatomic, strong) NSString* shop_score;
@property(nonatomic, strong) NSString* shop_site;
@property(nonatomic, strong) NSString* shop_tel;
@property(nonatomic, strong) NSString* shop_type;
@property(nonatomic, strong) NSString* shop_view_num;
@property(nonatomic, strong) NSString* shop_wechat;
@property(nonatomic, strong) NSString* shop_weibo;
@property(nonatomic, strong) NSString* view_time;
@property(nonatomic, strong) NSString* view_time_short;
@property(nonatomic, strong) NSDate* view_time_date;
@end

