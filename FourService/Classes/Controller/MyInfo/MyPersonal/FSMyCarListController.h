//
//  FSMyCarListController.h
//  FourService
//
//  Created by Joe.Pen on 7/22/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSMyCarListController : PBaseViewController
@property (nonatomic, strong)NSArray* carListAry;
- (void)getCarListFromServer;
@end
