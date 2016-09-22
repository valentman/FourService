//
//  FSServiceStepGoodsCell.h
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSServiceStepGoodsDelegate <NSObject>

- (void)deleteProduct:(NSIndexPath*)indexPath;
- (void)changeProduct:(NSIndexPath*)indexPath;
- (void)updateProductNum:(NSInteger)productNum andIndex:(NSIndexPath*)indexPath;

@end

@interface FSServiceStepGoodsCell : CZJTableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *productInfoView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *operateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operateViewLeading;
@property (strong, nonatomic)UISwipeGestureRecognizer *swipeLeft;

@property (weak, nonatomic) id<FSServiceStepGoodsDelegate> delegate;

- (void)setChooseCount:(NSInteger)chooseCount;
@end
