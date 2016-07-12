//
//  DynamicArrangeButtonCell.h
//  FourService
//
//  Created by Joe.Pen on 12/11/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DynamicArrangeButtonCell;

@protocol BadgeButtonArrayCellDelegate <NSObject>
-(void)cityTableViewCell:(DynamicArrangeButtonCell *)cityTableViewCell didClickLocationBtnTitle:(NSString *)title;
-(void)cityTableViewCell:(DynamicArrangeButtonCell *)cityTableViewCell didClickBtnTitle:(NSString *)title andId:(NSString *)typeID;

@end

@interface DynamicArrangeButtonCell : UITableViewCell
{
    NSMutableArray* _buttonDatas;
    NSMutableArray* _currentButtons;
}
@property (nonatomic, strong) NSMutableArray *buttonDatas;
@property (nonatomic, weak) id<BadgeButtonArrayCellDelegate>delegate;

@end
