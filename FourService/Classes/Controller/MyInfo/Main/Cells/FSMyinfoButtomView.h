//
//  FSMyinfoButtomView.h
//  FourService
//
//  Created by Joe.Pen on 8/13/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSMyInfoButtomViewDelegate <NSObject>

- (void)clickButtomBtnCallBack:(id)sender;

@end

@interface FSMyinfoButtomView : UITableViewCell
- (IBAction)btnAction:(id)sender;

@property (weak, nonatomic) id<FSMyInfoButtomViewDelegate> delegate;
@end
