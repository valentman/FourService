//
//  FSServiceStepGoodsCell.m
//  FourService
//
//  Created by Joe.Pen on 8/16/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSServiceStepGoodsCell.h"

@implementation FSServiceStepGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self addGestureRecognizer:_swipeLeft];
    self.swipeLeft.delegate = self;
    self.operateViewLeading.constant = PJ_SCREEN_WIDTH;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.swipeLeft == gestureRecognizer) {
        if (self.swipeLeft.direction == UISwipeGestureRecognizerDirectionLeft) {
            DLog(@"左滑");
            return YES;
        }
        else if (self.swipeLeft.direction == UISwipeGestureRecognizerDirectionRight) {
            DLog(@"右滑");
            return YES;
        }
        return NO;
        
    } else {
        return NO;
    }
}

/* 识别侧滑 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        DLog(@"左滑");
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        DLog(@"右滑");
    }
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    DLog();
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
//{
//    DLog();
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
//{
//    DLog();
//}
@end
