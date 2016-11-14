//
//  FSAddCarTwoCell.h
//  FourService
//
//  Created by Joe.Pen on 14/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAddCarTwoCell : CZJTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *carNumberButton;
@property (weak, nonatomic) IBOutlet UITextField *carNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topseparaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepaWidth;

@end
