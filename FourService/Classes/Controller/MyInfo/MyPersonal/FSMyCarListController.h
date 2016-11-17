//
//  FSMyCarListController.h
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FSCarListFromType)
{
    FSCarListFromTypeGeneral       =0,        //
    FSCarListFromTypeCommitOrder   =1
};


@protocol FSMyCarListControllerDelegate <NSObject>

- (void)selectOneCar:(FSCarListForm *)carForm;

@end

@interface FSMyCarListController : PBaseViewController
@property (nonatomic, strong) __block NSMutableArray* carListAry;
@property (nonatomic, assign) FSCarListFromType carFromType;
@property (nonatomic, weak) id<FSMyCarListControllerDelegate> delegate;
- (void)getCarListFromServer;
@end
