//
//  FSStartPageForm.m
//  FourService
//
//  Created by Joe.Pen on 15/9/6.
//  Copyright (c) 2015年 Joe.Pen. All rights reserved.
//

#import "FSStartPageForm.h"

@implementation FSStartPageForm
@end

@implementation FSVersionForm
@end

@implementation FSNotificationForm
- (id)init
{
    if (self = [super init])
    {
        self.isRead = NO;
        self.isSelected = NO;
        self.storeName = @"车之健";
        return self;
    }
    return nil;
}
@end
