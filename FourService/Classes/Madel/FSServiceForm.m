//
//  FSServiceForm.m
//  FourService
//
//  Created by Joe.Pen on 8/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceForm.h"

@implementation FSServiceListForm
@end

@implementation FSStoreImageForm
@end

@implementation FSStoreInfoForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"shop_image_list" : @"FSStoreImageForm",
             @"service_list" : @"FSStoreServiceListForm",
             @"comment_list" : @"FSStoreCommentImageForm"};
}
@end

@implementation FSServiceSegmentTypeForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"step_list" : @"FSServiceStepForm"};
}
@end

@implementation FSServiceStepForm
- (instancetype)init
{
    if (self == [super init]) {
        self.is_expand = NO;
        return self;
    }
    return nil;
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"product_list" : @"FSServiceStepProductForm"};
}
@end


@implementation FSServiceStepProductForm
@end





@implementation FSProductDetailForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"comment_list" : @"FSCommentForm",
             @"product_image_list" : @"FSProductImageForm"};
}
@end

@implementation FSProductImageForm
@end

@implementation FSCommentForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"comment_image_list" : @"FSCommentImageForm"};
}
@end

@implementation FSCommentImageForm
@end