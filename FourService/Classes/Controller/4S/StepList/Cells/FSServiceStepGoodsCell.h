//
//  FSServiceStepGoodsCell.h
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSServiceStepGoodsCell : CZJTableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *productInfoView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *operateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operateViewLeading;

@property (strong, nonatomic)UISwipeGestureRecognizer *swipeLeft;
@end
