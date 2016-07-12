//
//  FSHomeForm.h
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSHomeForm : NSObject

@end


@interface FSActivityForm : NSObject
@property(nonatomic, strong) NSString* activityId;
@property(nonatomic, strong) NSString* img;
@property(nonatomic, strong) NSString* url;
@end