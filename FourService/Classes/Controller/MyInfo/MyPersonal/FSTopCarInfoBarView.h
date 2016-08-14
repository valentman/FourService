//
//  FSTopCarInfoBarView.h
//  FourService
//
//  Created by Joe.Pen on 8/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTopCarInfoBarView : PBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTitle;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
