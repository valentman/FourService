//
//  FSConfirmInfoCell.h
//  FourService
//
//  Created by Joe.Pen on 05/11/2016.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSConfirmInfoCell : PBaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotPart;
@property (weak, nonatomic) IBOutlet UITextField *notPartPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end
