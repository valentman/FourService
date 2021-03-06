//
//  FSActivityCell.m
//  FourService
//
//  Created by Joe.Pen on 7/5/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "FSActivityCell.h"

@implementation FSActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageArray = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)someMethodNeedUse:(NSIndexPath *)indexPath DataModel:(NSArray*)array
{
    self.isInit = YES;
    [_imageArray removeAllObjects];
    _imageArray = [array mutableCopy];
    [self loadImageData];
}

- (void)loadImageData
{
    if (!_adScrollerView)
    {
        _adScrollerView = [[FZADScrollerView alloc] initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, 210)];
        _adScrollerView.delegate = self;
        [self addSubview:_adScrollerView];
    }
    [_adScrollerView setImages:_imageArray];
}

- (void)didSelectImageAtIndexPath:(NSInteger)indexPath
{
    NSLog(@"didSelectImageIndexPath = %ld", indexPath);
    FSHomeActivityForm* tmp = [_activeties objectAtIndex:indexPath];
    [self.delegate showActivityHtmlWithUrl:tmp.url];
}

@end
