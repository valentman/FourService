//
//  FSHomeForm.h
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FSHomeBannerForm : NSObject
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* news_id;
@property (strong, nonatomic)NSString* news_image_url;
@property (strong, nonatomic)NSString* news_place;
@property (strong, nonatomic)NSString* news_script;
@property (strong, nonatomic)NSString* news_type;
@property (strong, nonatomic)NSString* summary;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* url;
@property (strong, nonatomic)NSString* weight;
@end

@interface FSHomeLuckyForm : NSObject
@property (strong, nonatomic)NSString* activity_id;
@property (strong, nonatomic)NSString* discount_desc;
@property (strong, nonatomic)NSString* discount_id;
@property (strong, nonatomic)NSString* discount_image;
@property (strong, nonatomic)NSString* discount_name;
@property (strong, nonatomic)NSString* discount_type;
@end

@interface FSHomeNewsForm : NSObject
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* news_id;
@property (strong, nonatomic)NSString* news_image_url;
@property (strong, nonatomic)NSString* news_place;
@property (strong, nonatomic)NSString* news_script;
@property (strong, nonatomic)NSString* news_type;
@property (strong, nonatomic)NSString* summary;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* url;
@property (strong, nonatomic)NSString* weight;
@end

@interface FSHomeActivityForm : NSObject
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* news_id;
@property (strong, nonatomic)NSString* news_image_url;
@property (strong, nonatomic)NSString* news_place;
@property (strong, nonatomic)NSString* news_script;
@property (strong, nonatomic)NSString* news_type;
@property (strong, nonatomic)NSString* summary;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* url;
@property (strong, nonatomic)NSString* weight;
@end

@interface FSHomeAdvertiseForm : NSObject
@property (strong, nonatomic)NSString* create_time;
@property (strong, nonatomic)NSString* news_id;
@property (strong, nonatomic)NSString* news_image_url;
@property (strong, nonatomic)NSString* news_place;
@property (strong, nonatomic)NSString* news_script;
@property (strong, nonatomic)NSString* news_type;
@property (strong, nonatomic)NSString* summary;
@property (strong, nonatomic)NSString* title;
@property (strong, nonatomic)NSString* url;
@property (strong, nonatomic)NSString* weight;
@end

@interface CZJSCanQRForm : NSObject
@property (strong, nonatomic) NSString *operationType;  //付款、活动展示、扫描下载App、
@property (strong, nonatomic) NSString *storeType;      //门店、加油站、4S店，其他
@property (strong, nonatomic) NSString *storeName;      //门店名称
@property (strong, nonatomic) NSString *content;        //内容
@property (strong, nonatomic) NSString *discount;       //评星
@property (strong, nonatomic) NSString *todo;           //备注信息
@end
