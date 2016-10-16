//
//  CZJEvaluateForm.m
//  CZJShop
//
//  Created by Joe.Pen on 2/26/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CZJEvaluateForm.h"

@implementation CZJEvaluateForm
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"evaluateID" : @"id",};
}
@end

@implementation CZJMyEvaluationForm
- (id)init
{
    if (self == [super init])
    {
        self.comment_image_list = [NSMutableArray array];
    }
    return nil;
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"comment_image_list" : @"FSOrderEvaluateImageForm"};
}
@end


@implementation FSOrderEvaluateImageForm
@end


@implementation CZJDetailEvalInfo
+ (NSDictionary *)objectClassInArray
{
    return @{@"evalList" : @"CZJEvaluateForm"};
}
@end


@implementation CZJEvalutionReplyForm
@end

@implementation CZJMyEvaluationGoodsForm
@end

@implementation CZJAddedMyEvalutionForm : NSObject
@end
