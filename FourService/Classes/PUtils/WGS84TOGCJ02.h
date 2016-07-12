//
//  WGS84TOGCJ02.h
//  FourService
//
//  Created by Joe.Pen on 15/10/16.
//  Copyright © 2015年 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WGS84TOGCJ02 : NSObject
//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end

