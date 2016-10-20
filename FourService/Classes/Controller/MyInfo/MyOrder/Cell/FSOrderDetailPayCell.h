//
//  FSOrderDetailPayCell.h
//  FourService
//
//  Created by Joe.Pen on 10/4/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSOrderDetailPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *couponPrice;
@property (weak, nonatomic) IBOutlet UILabel *payPrice;

@end
