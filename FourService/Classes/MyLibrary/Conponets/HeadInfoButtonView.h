//
//  HeadInfoButtonView.h
//  FourService
//
//  Created by Joe.Pen on 10/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadInfoButtonView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabelWidth;

@end
