//
//  PUtils+NSDate.m
//  FourService
//
//  Created by Joe.Pen on 04/12/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PUtils+NSDate.h"

@implementation PUtils(NSDateUtils)
+ (NSDate *)dateFromNString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [formatter setTimeZone:timeZone];
    
    return [formatter dateFromString:dateStr];
}

+ (BOOL)isTimeCrossOneDay
{//判断俩次启动相隔时长
    
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970];     //当前时间
    UInt64 lastUpdateTime = [[USER_DEFAULT valueForKey:kUserDefaultTimeDay] longLongValue];   //上次更新时间
    UInt64 intervalTime = currentTime - lastUpdateTime;
    if (0 == lastUpdateTime ||
        intervalTime > 86400)
    {
        [USER_DEFAULT setValue:[NSString stringWithFormat:@"%llu",currentTime] forKey:kUserDefaultTimeDay];
        return YES;
    }
    return NO;
}


+ (BOOL)isTimeCrossFiveMin:(int)intervalMin
{
    return [self isTimeCrossMinInterval:intervalMin withIdentity:kUserDefaultTimeMin];
}

+ (BOOL)isTimeCrossMinInterval:(int)intervalTimer withIdentity:(NSString*)userDefault
{
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970];     //当前时间
    UInt64 lastUpdateTime = [[USER_DEFAULT valueForKey:userDefault] longLongValue];   //上次更新时间
    UInt64 intervalTime = currentTime - lastUpdateTime;
    if (0 == lastUpdateTime ||
        intervalTime > intervalTimer*60)
    {
        [USER_DEFAULT setValue:[NSString stringWithFormat:@"%llu",currentTime] forKey:userDefault];
        return YES;
    }
    return NO;
}

+ (FSDateTime*)getLeftDatetime:(NSInteger)timeStamp
{
    FSDateTime* dateTime = [[FSDateTime alloc]init];
    NSInteger ms = timeStamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSString* hourStr = [NSString stringWithFormat:@"%d", hour];
    if (hour < 10)
    {
        hourStr =[NSString stringWithFormat:@"0%d", hour];
    }
    
    NSString* minutesStr = [NSString stringWithFormat:@"%d", minute];
    if (minute < 10)
    {
        minutesStr = [NSString stringWithFormat:@"0%d", minute];
    }
    
    NSString* secondStr = [NSString stringWithFormat:@"%d", second];
    if (second < 10)
    {
        secondStr = [NSString stringWithFormat:@"0%d", second];
    }
    
    dateTime.day = [NSString stringWithFormat:@"%d", day];
    dateTime.hour = hourStr;
    dateTime.minute = minutesStr;
    dateTime.second = secondStr;
    return dateTime;
}

+ (NSString*)getCurrentHourTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


+ (NSString*)getCurrentDateTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString*)getFullDateTime:(NSInteger)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    return dateTime;
}

+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:skillTime];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}
@end
