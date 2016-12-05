//
//  PUtils+NSDate.h
//  FourService
//
//  Created by Joe.Pen on 04/12/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUtils.h"

@interface PUtils(NSDateUtils)
+ (NSDate *)dateFromNString:(NSString *)dateStr;


//获取时间间隔
+ (BOOL)isTimeCrossOneDay;
+ (BOOL)isTimeCrossFiveMin:(int)intervalMin;
+ (BOOL)isTimeCrossMinInterval:(int)intervalTimer withIdentity:(NSString*)userDefault;
+ (FSDateTime*)getLeftDatetime:(NSInteger)timeStamp;
+ (NSString*)getCurrentDateTime;
+ (NSString*)getFullDateTime:(NSInteger)time;
//+ (NSString*)getChatDatetime:(NSInteger)chatTime;
+ (NSString*)getCurrentHourTime;
+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime;
@end
