//
//  FSLoginController.h
//  CZJShop
//
//  Created by Joe.Pen on 12/21/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLoginController : PBaseViewController
@property (nonatomic, weak) id <FSViewControllerDelegate> delegate;

- (IBAction)exitOutAction:(id)sender;
@end
