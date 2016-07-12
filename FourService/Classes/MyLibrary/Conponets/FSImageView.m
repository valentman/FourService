//
//  FSImageView.m
//  FourService
//
//  Created by Joe.Pen on 4/19/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "FSImageView.h"

@implementation FSImageView
- (id)initWithFrame:(CGRect)imageRect
{
    if (self == [super initWithFrame:imageRect])
    {
        self.userInteractionEnabled = YES;
        return self;
    }
    return nil;
}
@end
