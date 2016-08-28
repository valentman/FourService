//
//  PBaseNaviagtionBarView.h
//  FourService
//
//  Created by Joe.Pen on 11/20/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PBaseNaviagtionBarViewDelegate <NSObject>

@optional
- (void)clickEventCallBack:(nullable id)sender;
- (void)removeShoppingOrLoginView:(nullable id)sender;

@end

@interface PBaseNaviagtionBarView : UIView<UISearchBarDelegate, FSViewControllerDelegate>
@property(nullable, strong, nonatomic)BadgeButton* btnBack;                            //返回按钮
@property(nullable, strong, nonatomic)BadgeButton* btnScan;                            //扫一扫按钮
@property(nullable, strong, nonatomic)BadgeButton* btnShop;                            //购物车
@property(nullable, strong, nonatomic)BadgeButton* btnMore;                            //更多按钮
@property(nullable, strong, nonatomic)BadgeButton* btnArrange;                         //列表排列样式按钮
@property(nullable, strong, nonatomic)UILabel* btnShopBadgeLabel;
@property(nullable, strong, nonatomic)UISearchBar* customSearchBar;                 //搜索栏
@property(nullable, strong, nonatomic)UILabel* mainTitleLabel;                      //正中标题
@property(nullable, strong, nonatomic)UIView* buttomSeparator;                      //底部分割线
@property(nullable, strong, nonatomic)UIImageView* backgroundImageView;
@property (nonatomic, assign) CZJDetailType detailType;


@property(nullable,nonatomic,weak) id<PBaseNaviagtionBarViewDelegate> delegate;
- (nullable instancetype)initWithFrame:(CGRect)bounds AndType:(CZJNaviBarViewType)type;
- (void)refreshShopBadgeLabel;
- (void)setBackgroundColor:(nullable UIColor *)backgroundColor;
@end
