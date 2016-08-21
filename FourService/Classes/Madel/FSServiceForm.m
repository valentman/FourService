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
             @"service_list" : @"FSStoreServiceListForm"};
}
@end

@implementation FSServiceStepForm
+ (NSDictionary *)objectClassInArray
{
    return @{@"product_list" : @"FSServiceStepProductForm"};
}
@end


@implementation FSServiceStepProductForm
@end