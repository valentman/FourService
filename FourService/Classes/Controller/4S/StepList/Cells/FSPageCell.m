//
//  FSPageCell.m
//  FourService
//
//  Created by Joe.Pen on 9/6/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSPageCell.h"

@implementation FSSegmentView

- (instancetype)init
{
    if (self = [super init])
    {
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        return self;
    }
    return nil;
}

- (void)initLabels:(NSDictionary*)dict
{
    BOOL justOneLabel = dict.count == 1 ? YES : NO;
    CGRect selfBounds = self.bounds;
    _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (justOneLabel ? selfBounds.size.height * 0.25 : 0), selfBounds.size.width , selfBounds.size.height * 0.5)];
    _mainTitleLabel.text = dict[kSegmentViewMainTitleKey];
    //清空背景颜色
    _mainTitleLabel.backgroundColor = [UIColor clearColor];
    _mainTitleLabel.font =SYSTEMFONT(15);
    //设置字体颜色为白色
    _mainTitleLabel.textColor = RGB(50, 50, 50);;
    //文字居中显示
    _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    _mainTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _mainTitleLabel.numberOfLines = 0;
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, selfBounds.size.height * 0.5, selfBounds.size.width , selfBounds.size.height * 0.5)];
    
    //清空背景颜色
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    _subTitleLabel.font = SYSTEMFONT(12);
    //设置字体颜色为白色
    _subTitleLabel.textColor = RGB(100, 100, 100);
    //文字居中显示
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    _subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _subTitleLabel.numberOfLines = 0;
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(selfBounds.size.width, 5, 0.5, selfBounds.size.height - 10)];
    _lineView.backgroundColor = CZJGRAYCOLOR;
    [self addSubview:_lineView];
    
    [self addSubview:_mainTitleLabel];
    if (!justOneLabel)
        _subTitleLabel.text = dict[kSegmentViewSubTitleKey];
        [self addSubview:_subTitleLabel];
}

@end


@interface FSPageCell ()
@property (strong, nonatomic) __block UIView* underLineView;
@property (assign, nonatomic) NSInteger segmentWidth;
@end

@implementation FSPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _underLineView = [[UIView alloc] init];
    _underLineView.backgroundColor = RGB(46, 159, 226);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurrentTouchIndex:(NSInteger)currentTouchIndex
{
    _underLineView.frame = CGRectMake(currentTouchIndex * _segmentWidth, self.bounds.size.height, _segmentWidth, 1);
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    //获取数量
    NSInteger titleCount = _titleArray.count;
    _segmentWidth = PJ_SCREEN_WIDTH/titleCount;
    CGSize setmentViewSize = CGSizeMake(_segmentWidth, self.bounds.size.height);
    for (int i = 0; i < titleCount; i++)
    {
        CGRect segFrame = [PUtils viewFramFromDynamic:CZJMarginMake(0, 0) size:setmentViewSize index:i divide:3];
        FSSegmentView* segview = [[FSSegmentView alloc]initWithFrame:segFrame];
        segview.tag = i;
        [segview initLabels:_titleArray[i]];
        [segview addTarget:self action:@selector(segmentButtonTouche:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:segview];
    }
    _underLineView.frame = CGRectMake(0, self.bounds.size.height - 2, _segmentWidth, 2);
    [self addSubview:_underLineView];
}

- (void)segmentButtonTouche:(UIButton*)sender
{
    [self moveButtomLine:sender.tag];
}

- (void)moveButtomLine:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        _underLineView.frame = CGRectMake(index * _segmentWidth, self.bounds.size.height, _segmentWidth, 1);
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(segmentButtonTouchHandle:)]) {
            [_delegate segmentButtonTouchHandle:index];
        }
    }];
}

@end
