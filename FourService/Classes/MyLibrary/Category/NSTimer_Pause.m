//
//  NSTimer_Pause.m
//  Lottery
//
//  Created by Joe.Pen on 7/11/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "NSTimer_Pause.h"

@implementation NSTimer (Pause)

-(void)pauseTimer{
    
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是4001-01-01 00:00:00 +0000
    
    
}


-(void)resumeTimer{
    
    if (![self isValid]) {
        return ;
    }
    
    //[self setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self setFireDate:[NSDate date]];
    
}

@end
