//
//  FSBaseAlertViewController.h
//  FourService
//
//  Created by Joe.Pen on 2/24/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAlertView.h"

@interface FSBaseAlertViewController : UIViewController
@property (nonatomic, strong)FSAlertView* popView;
- (void)setConfirmItemHandle:(GeneralBlockHandler)basicBlock;
@end
