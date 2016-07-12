//
//  BadgeButton.h
//  FourService
//
//  Created by Joe.Pen on 12/12/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIButton
- (void)setBadgeNum:(NSInteger)badgeNum;
- (void)setBadgeLabelPosition:(CGPoint)pt;     //提供个性化的位置设置
@end
