//
//  FSAddCarOneCell.h
//  FourService
//
//  Created by Joe.Pen on 14/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAddCarOneCell : CZJTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *sepaView;
@property (weak, nonatomic) IBOutlet UIImageView *logonImage;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@end
