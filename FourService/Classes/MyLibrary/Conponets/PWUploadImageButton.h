//
//  PWUploadImageButton.h
//  ParallelWorld
//
//  Created by Joe.Pen on 7/26/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWUploadImageButton : UIView
@property (strong, nonatomic) UIButton* touchBtn;
@property (strong, nonatomic) UIImageView* bgImageView;
@property (weak, nonatomic) UIViewController* targetController;
@property (weak, nonatomic) SuccessBlockHandler successBlock;
@end
