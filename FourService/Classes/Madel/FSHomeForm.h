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