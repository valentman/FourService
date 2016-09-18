//
//  CZJMyInfoHeadCell.h
//  CZJShop
//
//  Created by Joe.Pen on 1/11/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CZJMyInfoHeadCellDelegate <NSObject>
- (void)clickMyInfoHeadCell:(id)sender;
@end

@interface CZJMyInfoHeadCell : PBaseTableViewCell
@property(weak, nonatomic)id<CZJMyInfoHeadCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *unLoginView;
@property (weak, nonatomic) IBOutlet UIView *haveLoginView;
@property (weak, nonatomic) IBOutlet BadgeButton *messageBtn;


- (void)setUserPersonalInfo:(UserBaseForm*)userinfo andDefaultCar:(FSCarListForm*)car;
@end
