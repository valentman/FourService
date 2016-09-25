//
//  FSPageCell.h
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString* const kSegmentViewMainTitleKey = @"mainTitleKey";
static NSString* const kSegmentViewSubTitleKey = @"subTitleKey";

@protocol FSPageCellDelegate <NSObject>

- (void)segmentButtonTouchHandle:(NSInteger)toucheIndex;

@end

@interface FSPageCell : CZJTableViewCell
@property (strong, nonatomic) NSMutableArray* titleArray;
@property (weak, nonatomic) id<FSPageCellDelegate> delegate;
@property (assign, nonatomic) NSInteger currentTouchIndex;
@end

@interface FSSegmentView : UIControl
@property (strong, nonatomic) UILabel* mainTitleLabel;
@property (strong, nonatomic) UILabel* subTitleLabel;
@property (strong, nonatomic) UIView* lineView;

@end
