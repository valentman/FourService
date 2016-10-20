//
//  FSServiceStoreCell.m
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceStoreCell.h"

@implementation FSServiceStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _discountPriceLabel.keyWordFont = SYSTEMFONT(18);
    _originPriceLabel.keyWordFont = SYSTEMFONT(8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPaymentAvaiable:(id)types
{
    self.zhifubaoImage.hidden = types;
    self.weixinImage.hidden = types;
    self.yinlianImage.hidden = types;
    self.cashImage.hidden = types;
}

@end
