//
//  FSStoreServiceForm.m
//  FourService
//
//  Created by Joe.Pen on 7/30/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSStoreServiceForm.h"

@implementation FSStoreDetailForm
@end

@implementation FSStoreCommentForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"comment_image_list" : @"FSStoreCommentImageForm"};
}
@end

@implementation FSStoreCommentImageForm
@end
