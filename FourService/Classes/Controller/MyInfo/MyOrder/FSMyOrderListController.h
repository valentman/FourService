//
//  FSMyOrderListController.h
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZJOrderListCell.h"

@interface FSMyOrderListController : PBaseViewController
{
    NSMutableDictionary* _params;
    NSString* _noDataPrompt;
}
@property (strong, nonatomic)NSMutableDictionary* params;
@property (strong, nonatomic)NSString* noDataPrompt;
@property (weak, nonatomic)id<CZJOrderListCellDelegate> delegate;

- (void)initMyDatas;
- (void)getOrderListFromServer;
- (void)removeOrderlistControllerNotification;
@property (assign, nonatomic)FSOrderListType orderType;
@end
