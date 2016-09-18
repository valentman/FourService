//
//  PJBrowserView.h
//  FourService
//
//  Created by Joe.Pen on 8/21/16.
//  Copyright © 2016 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMovieBrowserHeight 165

@class PJBrowserView;

@protocol PJBrowserDelegate <NSObject>
- (void)browser:(PJBrowserView *)movieBrowser didSelectItemAtIndex:(NSInteger)index;
- (void)browser:(PJBrowserView *)movieBrowser didEndScrollingAtIndex:(NSInteger)index;
- (void)browser:(PJBrowserView *)movieBrowser didChangeItemAtIndex:(NSInteger)index;

@end


@interface PJBrowserView : UIView
@property (nonatomic, assign, readwrite) id<PJBrowserDelegate> delegate;
@property (nonatomic, assign, readonly)  NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)_viewItems;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)_viewItems currentIndex:(NSInteger)index;
- (void)setCurrentItemIndex:(NSInteger)index;
@end
