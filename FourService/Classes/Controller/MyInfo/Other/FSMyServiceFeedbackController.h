//
//  FSMyServiceFeedbackController.h
//  FourService
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PBaseViewController.h"

typedef NS_ENUM(NSInteger, FSFeedbackFromType)
{
    FSFeedbackFromTypeGeneral = 0,      //反馈咨询
    FSFeedbackFromTypeFix               //维修保养
};

@interface FSMyServiceFeedbackController : PBaseViewController
@property (assign, nonatomic) FSFeedbackFromType fromType;
@end
