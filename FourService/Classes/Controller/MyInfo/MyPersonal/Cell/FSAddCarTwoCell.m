//
//  FSAddCarTwoCell.m
//  FourService
//
//  Created by Joe.Pen on 14/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSAddCarTwoCell.h"

@implementation FSAddCarTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topseparaHeight.constant = 0.3;
    self.sepaWidth.constant = 0.3;
    
    CGPoint pt = CGPointMake(48, 27);
    CAShapeLayer *indicator = [PUtils creatIndicatorWithColor:BLUECOLOR andPosition:pt];
    [self.carNumberButton.layer addSublayer:indicator];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
