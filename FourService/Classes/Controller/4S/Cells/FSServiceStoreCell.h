//
//  FSServiceStoreCell.h
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSServiceStoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;
@property (weak, nonatomic) IBOutlet UIImageView *yinlianImage;
@property (weak, nonatomic) IBOutlet UIImageView *cashImage;
@property (weak, nonatomic) IBOutlet UILabel *storeTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet MMLabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet MMLabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderLabel;

@property (weak, nonatomic) IBOutlet UILabel *storeAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discoutPriceLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originPriceLabelWidth;

- (void)setPaymentAvaiable:(id)types;

@end
