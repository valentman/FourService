//
//  LoadingFailedAlertView.h
//  FourService
//
//  Created by Joe.Pen on 3/23/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingFailedAlertView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;
@property (copy, nonatomic) GeneralBlockHandler reloadHandle;
- (void)setRoloadHandle:(GeneralBlockHandler)reloadHandle;
@end
