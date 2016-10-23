//
//  CALayer+UIColor.m
//  FourService
//
//  Created by Joe.Pen on 1/30/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (Color)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

- (void)removeAllSubLayer
{
    NSArray<CALayer *> *sublayers = [self sublayers];
    for (CALayer *subLayer in sublayers)
    {
        [subLayer removeFromSuperlayer];
    }
}

- (void)removeShapeSubLayer
{
    NSArray<CALayer *> *sublayers = [self sublayers];
    for (CALayer *subLayer in sublayers)
    {
        if ([subLayer isKindOfClass:[CAShapeLayer class]])
        {
            [subLayer removeFromSuperlayer];
        }
    }
}
@end
