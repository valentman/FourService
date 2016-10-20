//
//  FSProductChangeController.h
//  FourService
//
//  Created by Joe.Pen on 9/12/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSProductChangeDelegate <NSObject>

- (void)chooseProduct:(FSServiceStepProductForm*)chooseProduct andIndex:(NSIndexPath*)cellIndex;

@end

@interface FSProductChangeController : PBaseViewController
@property (strong, nonatomic) NSString* subTypeId;
@property (strong, nonatomic) NSString* productItem;
@property (strong, nonatomic) NSIndexPath* cellIndexPath;
@property (weak, nonatomic) id<FSProductChangeDelegate> delegate;
@end
