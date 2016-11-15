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
@property (strong, nonatomic) UIScrollView *contentScroll;
@end

@implementation FSPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIScrollView *)contentScroll
{
    if (!_contentScroll) {
        _contentScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, self.bounds.size.height)];
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        [self addSubview:_contentScroll];
    }
    return _contentScroll;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleArray = [titleArray mutableCopy];
    //获取数量
    NSInteger titleCount = _titleArray.count;
    _segmentWidth = PJ_SCREEN_WIDTH/3;
//    [self.contentScroll setContentSize:CGSizeMake(_segmentWidth * titleCount, self.bounds.size.height - 2)];
    self.underLineView.frame = CGRectMake(0, self.bounds.size.height - 2, _segmentWidth, 2);
    
    for (int i = 0; i < titleCount; i++)
    {
        CGRect segFrame = CGRectMake(i * _segmentWidth, 0, _segmentWidth, self.bounds.size.height - 4);
        FSSegmentView* segview = [[FSSegmentView alloc]initWithFrame:segFrame];
        segview.tag = i;
        [segview initLabels:_titleArray[i]];
        [segview addTarget:self action:@selector(segmentButtonTouche:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:segview];
    }
}

- (UIView *)underLineView
{
    if (!_underLineView)
    {
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = RGB(46, 159, 226);
        [self addSubview:_underLineView];
    }
    return _underLineView;
}

- (void)segmentButtonTouche:(UIButton*)sender
{
    [self moveButtomLine:sender.tag];
}

- (void)moveButtomLine:(NSInteger)index
{
    [UIScrollView animateWithDuration:0.2 animations:^{
        _underLineView.frame = CGRectMake(index * _segmentWidth, self.bounds.size.height - 2, _segmentWidth, 2);
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(segmentButtonTouchHandle:)]) {
            [_delegate segmentButtonTouchHandle:index];
        }
    }];
}

@end
