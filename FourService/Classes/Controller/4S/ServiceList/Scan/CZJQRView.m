//
//  CZJQRView.m
//  CZJShop
//
//  Created by Joe.Pen on 3/10/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "CZJQRView.h"

static NSTimeInterval kQrLineanimateDuration = 0.02;

@implementation CZJQRView
{
    UIImageView *qrLine;
    CGFloat qrLineY;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (!qrLine) {
        [self initQRLine];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kQrLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)initQRLine {
    CGRect qrLineFrame = CGRectMake((PJ_SCREEN_WIDTH - self.transparentArea.width) / 2, (PJ_SCREEN_HEIGHT - self.transparentArea.height) / 2 - 50, self.transparentArea.width, 2);
    qrLine  = [[UIImageView alloc] initWithFrame:qrLineFrame];
    [qrLine setTintColor:FSBLUECOLOR];
    qrLine.image = [[UIImage imageNamed:@"scan_img_line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    qrLine.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)show {
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
        qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 54;
        if (qrLineY > maxBorder) {
            qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2 - 50;
        }
        qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =PJ_SCREEN_BOUNDS.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2 - 50,
                                      self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
    
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 0.8);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 52 /255.0, 169/255.0, 229/255.0, 1);//红色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

@end
