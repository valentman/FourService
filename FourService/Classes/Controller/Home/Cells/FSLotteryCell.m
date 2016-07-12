//
//  FSLotteryCell.m
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSLotteryCell.h"
#import "NSTimer_Pause.h"

@interface FSLotteryCell ()
{
    NSMutableArray* imageAry;
    NSInteger imageIndex;
    BOOL isBegin;
    BOOL isTouch;
    NSTimer* timer2;
}
@end

@implementation FSLotteryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    imageAry  = [NSMutableArray array];
    self.lotteryButtonLeading.constant = PJ_SCREEN_WIDTH*0.25;
    self.lotteryButtonTrailing.constant = PJ_SCREEN_WIDTH*0.25;
    NSArray* subview = [self.contentView subviews];
    for (id obj in subview)
    {
        if ([obj tag] >= 1000)
        {
            [imageAry addObject:obj];
        }
    }
    [imageAry sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 tag] > [obj2 tag])
            return NSOrderedDescending;
        return NSOrderedAscending;
        
    }];
    
    imageIndex = 0;
    isBegin = NO;
    isTouch = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)beginLotteryAnimation:(id)sender
{
    
    if (isTouch) {
        [timer2 pauseTimer];
    }
    else
    {
        [timer2 resumeTimer];
        [self beginTimer:0.1];
    }
    isTouch = !isTouch;
    
}

- (void)beginTimer:(NSTimeInterval)_timer
{
    if (!timer2)
    {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:_timer target:self selector:@selector(lotteryImageAnimate) userInfo:nil repeats:YES];
        [timer2 fire];
    }
    else
    {
        [timer2 invalidate];
        timer2 = [NSTimer scheduledTimerWithTimeInterval:_timer target:self selector:@selector(lotteryImageAnimate) userInfo:nil repeats:YES];
        [timer2 fire];
    }
    
    
}

- (void)lotteryImageAnimate
{
    NSLog(@"image animate");
    UIImageView* imageView = imageAry[imageIndex];
    
    [self shakeToShow:imageView];
    
    imageIndex++;
    if (imageIndex >= imageAry.count) {
        imageIndex = 0;
        if (!isBegin)
        {
            [self beginTimer:0.05];
            isBegin = YES;
        }
    }
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
