//
//  PJBrowserView.m
//  FourService
//
//  Created by Joe.Pen on 8/21/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import "PJBrowserView.h"

#define kBaseTag 100
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kItemSpacing 50.0
#define kItemWidth  60.0
#define kItemHeight 85.0
#define kItemSelectedWidth  80.0
#define kItemSelectedHeight 108.0
#define kScrollViewContentOffset (kScreenWidth / 2.0 - (kItemWidth / 2.0 + kItemSpacing))

@interface PJBrowserView () <UIScrollViewDelegate>
@property (nonatomic, assign, readwrite) NSInteger      currentIndex;
@property (nonatomic, strong, readwrite) NSMutableArray *items;
@property (nonatomic, assign, readwrite) CGPoint        scrollViewContentOffset;
@property (nonatomic, strong, readwrite) UIScrollView   *scrollView;
@property (nonatomic, assign, readwrite) BOOL           isTapDetected;
@end

@implementation PJBrowserView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)_viewItems
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [_viewItems mutableCopy];
        [self setupScrollView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)_viewItems currentIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [_viewItems mutableCopy];
        [self setupScrollView];
        [self setCurrentItemIndex:index];
    }
    
    return self;
}

- (void)setCurrentItemIndex:(NSInteger)index
{
    if (index >= 0 && index < self.items.count) {
        self.currentIndex = index;
        CGPoint point = CGPointMake((kItemSpacing + kItemWidth) * index - kScrollViewContentOffset, 0);
        [self.scrollView setContentOffset:point animated:NO];
    }
}

#pragma mark - Setup

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset);
    _scrollView.contentSize = CGSizeMake((kItemWidth + kItemSpacing) * self.items.count + kItemSpacing, kMovieBrowserHeight);
    
    NSInteger i = 0;
    for (UIView* movie in self.items) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake((kItemSpacing + kItemWidth) * i + kItemSpacing, kMovieBrowserHeight - kItemHeight, kItemWidth, kItemHeight)];
        [_scrollView addSubview:itemView];

        [itemView addSubview:movie];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        [movie addGestureRecognizer:tapGesture];
        
        i++;
    }
}

- (void)adjustSubviews:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + kScrollViewContentOffset) / (kItemWidth + kItemSpacing);
    index = MIN(self.items.count - 1, MAX(0, index));
    
    CGFloat scale = (scrollView.contentOffset.x + kScrollViewContentOffset - (kItemWidth + kItemSpacing) * index) / (kItemWidth + kItemSpacing);
    if (self.items.count > 0) {
        CGFloat height;
        CGFloat width;
        
        if (scale < 0.0) {
            scale = 1 - MIN(1.0, ABS(scale));
            
            UIView *leftView = self.items[index];
            leftView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scale].CGColor;
            height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale;
            width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale;
            leftView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
            
            if (index + 1 < self.items.count) {
                UIView *rightView = self.items[index + 1];
                rightView.frame = CGRectMake(0, 0, kItemWidth, kItemHeight);
                rightView.layer.borderColor = [UIColor clearColor].CGColor;
            }
            
        } else if (scale <= 1.0) {
            if (index + 1 >= self.items.count) {
                
                scale = 1 - MIN(1.0, ABS(scale));
                
                UIView *imgView = self.items[self.items.count - 1];
                imgView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scale].CGColor;
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale;
                imgView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
                
            } else {
                CGFloat scaleLeft = 1 - MIN(1.0, ABS(scale));
                UIView *leftView = self.items[index];
                leftView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scaleLeft].CGColor;
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scaleLeft;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scaleLeft;
                leftView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
                
                CGFloat scaleRight = MIN(1.0, ABS(scale));
                UIView *rightView = self.items[index + 1];
                rightView.layer.borderColor = [UIColor colorWithWhite:1 alpha:scaleRight].CGColor;
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scaleRight;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scaleRight;
                rightView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
            }
        }
        
        for (UIView *imgView in self.items) {
            if (imgView.tag != index + kBaseTag && imgView.tag != (index + kBaseTag + 1)) {
                imgView.frame = CGRectMake(0, 0, kItemWidth, kItemHeight);
                imgView.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    index = MIN(self.items.count - 1, MAX(0, index));
    
    if (self.currentIndex != index) {
        self.currentIndex = index;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(browserDidEndScrolling) object:nil];
    
    [self adjustSubviews:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger index = (targetContentOffset->x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    targetContentOffset->x = (kItemSpacing + kItemWidth) * index - kScrollViewContentOffset;
}


#pragma mark - Tap Detection

- (void)tapDetected:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == self.currentIndex + kBaseTag) {
        if ([self.delegate respondsToSelector:@selector(browser:didSelectItemAtIndex:)]) {
            [self.delegate browser:self didSelectItemAtIndex:self.currentIndex];
            return;
        }
    }
    
    CGPoint point = [tapGesture.view.superview convertPoint:tapGesture.view.center toView:self.scrollView];
    point = CGPointMake(point.x - kScrollViewContentOffset - ((kItemWidth / 2 + kItemSpacing)), 0);
    self.scrollViewContentOffset = point;
    
    self.isTapDetected = YES;
    
    [self.scrollView setContentOffset:point animated:YES];
}

#pragma mark - end scrolling handling

- (void)browserDidEndScrolling
{
    if ([self.delegate respondsToSelector:@selector(browser:didEndScrollingAtIndex:)]) {
        [self.delegate browser:self didEndScrollingAtIndex: self.currentIndex];
    }
}


#pragma mark - setters

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if ([self.delegate respondsToSelector:@selector(browser:didChangeItemAtIndex:)]) {
        [self.delegate browser:self didChangeItemAtIndex:_currentIndex];
    }
}

@end
