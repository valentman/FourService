//
//  WLZ_ChangeCountView.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ChangeCountView.h"
#import "UIColor+WLZ_HexRGB.h"
@implementation WLZ_ChangeCountView


- (instancetype)initWithFrame:(CGRect)frame totalCount:(NSInteger)totalCount {
    self = [super initWithFrame:frame];
    _selfBounds = frame;
    if (self) {
        [self setUpViews];
        self.totalCount = totalCount;
    }
    return self;
}

- (void)setChoosedCount:(NSInteger)choosedCount
{
    _numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    if (self.choosedCount <= 1) {
        _subButton.enabled = NO;
        _subButton.titleLabel.alpha = 0.5f;
    }else{
        _subButton.enabled = YES;
        _subButton.titleLabel.alpha = 1.0f;
    }
    if (self.choosedCount >= self.totalCount) {
        _addButton.enabled = NO;
        _addButton.titleLabel.alpha = 0.5f;
    }else{
        _addButton.enabled = YES;
        _addButton.titleLabel.alpha = 1.0f;
    }
}

- (void)setUpViews
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 3;
    self.backgroundColor = WHITECOLOR;
    self.clipsToBounds = YES;
    
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, _selfBounds.size.height, _selfBounds.size.height);
    [_subButton setTitle:@"-" forState:UIControlStateNormal];
    [_subButton setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    _subButton.titleLabel.font = SYSTEMFONT(20);
    _subButton.exclusiveTouch = YES;

    _subButton.backgroundColor=CLEARCOLOR;
    [self addSubview:_subButton];
    
    
    _numberFD = [[UITextField alloc]initWithFrame:CGRectMake(_selfBounds.size.height - 1, 0, _selfBounds.size.width - 2 * _selfBounds.size.height + 2, _subButton.frame.size.height)];
    _numberFD.textAlignment=NSTextAlignmentCenter;
    _numberFD.keyboardType=UIKeyboardTypeNumberPad;
    _numberFD.clipsToBounds = YES;
    _numberFD.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _numberFD.layer.borderWidth = 0.5;
    _numberFD.textColor = [UIColor colorFromHexRGB:@"333333"];
    _numberFD.font=[UIFont systemFontOfSize:13];
    _numberFD.backgroundColor = CLEARCOLOR;
    
    _numberFD.enabled = NO;
    [self addSubview:_numberFD];
    
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(_selfBounds.size.width - _selfBounds.size.height, 0, _selfBounds.size.height, _selfBounds.size.height);
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    _addButton.titleLabel.font = SYSTEMFONT(18);
    
    _addButton.exclusiveTouch = YES;

    _addButton.backgroundColor=CLEARCOLOR;
    [self addSubview:_addButton];
}

@end
