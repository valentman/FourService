//
//  FSLotteryCell.h
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLotteryCell : PBaseTableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lotteryButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lotteryButtonTrailing;

- (IBAction)beginLotteryAnimation:(id)sender;
@end
