//
//  FSServiceStepCell.h
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSServiceStepCell : CZJTableViewCell

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet UIButton *stepImageButton;

@property (weak, nonatomic) IBOutlet UILabel *stemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepDescLabel;


@property (weak, nonatomic) IBOutlet UILabel *stepPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *stepSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@end
