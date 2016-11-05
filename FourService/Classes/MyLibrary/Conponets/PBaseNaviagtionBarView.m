//
//  PBaseNaviagtionBarView.m
//  FourService
//
//  Created by Joe.Pen on 11/20/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "PBaseNaviagtionBarView.h"
//#import "CZJLoginController.h"
//#import "FourServicepingCartController.h"
//#import "CZJSearchController.h"
#import "CZJScanQRController.h"


@interface PBaseNaviagtionBarView ()<UISearchBarDelegate>
{
    CGRect _selfBounds;
}
@property (assign, nonatomic)CGRect selfBounds;
- (void)initWithButtonsWithType:(CZJNaviBarViewType)type;
@end

@implementation PBaseNaviagtionBarView
@synthesize btnHead = _btnHead;
@synthesize btnBack = _btnBack;
@synthesize btnScan = _btnScan;
@synthesize btnShop = _btnShop;
@synthesize btnArrange = _btnArrange;
@synthesize btnMore = _btnMore;
@synthesize btnShopBadgeLabel = _btnShopBadgeLabel;
@synthesize customSearchBar = _customSearchBar;

- (instancetype)initWithFrame:(CGRect)bounds AndType:(CZJNaviBarViewType)type
{
    if (self == [super initWithFrame:bounds]) {
        self.selfBounds = bounds;
        
        [self initWithButtonsWithType:type];
        [self setTag:type];
        return self;
    }
    return nil;
}

- (void)refreshShopBadgeLabel
{
    NSString* shoppingCartCount = [USER_DEFAULT valueForKey:kUserDefaultShoppingCartCount];
    if ([shoppingCartCount intValue]<= 0)
    {
        _btnShopBadgeLabel.text = @"";
        _btnShopBadgeLabel.hidden = YES;
    }
    else
    {
        _btnShopBadgeLabel.text = [NSString stringWithFormat:@"%@",shoppingCartCount];
        _btnShopBadgeLabel.hidden = NO;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [VIEWWITHTAG(self, 2001) setBackgroundColor:backgroundColor];
    [super setBackgroundColor:backgroundColor];
}

- (void)initWithButtonsWithType:(CZJNaviBarViewType)type
{
    _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [_backgroundImageView setImage:IMAGENAMED(@"home_topBg")];
    [self addSubview:_backgroundImageView];
    
    //状态栏颜色
    CGRect statusviewbound = CGRectMake(0, -20, _selfBounds.size.width, 20);
    UIView* _statusBarBgView = [[UIView alloc]initWithFrame:statusviewbound];
    [_statusBarBgView setTag:2001];
    [self addSubview:_statusBarBgView];
    [self setBackgroundColor:CZJNAVIBARBGCOLOR];
    
    //初始化数据
    NSString* shopBtnImageName = @"all_btn_shopping";
    NSString* saoyisaoBtnImageName = @"btn_saoyisao";
    NSString* arrangeBtnImageName = @"pro_btn_large";
    
    //------------------------------------初始化按钮组------------------------------------
    //1.搜索栏按钮
    CGRect searchaBarRect = CGRectMake(CGRectGetMinX(_selfBounds) + 44, 22 ,
                                       _selfBounds.size.width - (44 * 2), 40);
    _customSearchBar = [[UISearchBar alloc] initWithFrame:searchaBarRect];
    _customSearchBar.delegate = self;
    _customSearchBar.backgroundColor = CLEARCOLOR;
    _customSearchBar.backgroundImage = [UIImage imageNamed:@"nav_bargound"];
    _customSearchBar.placeholder = @"搜索服务、商品、门店";
    [_customSearchBar setTag:CZJButtonTypeSearchBar];
    _customSearchBar.hidden = NO;
    _customSearchBar.alpha = 0.9;
    for (UIView *subView in self.customSearchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                //set font color here
                searchBarTextField.textColor = [UIColor grayColor];
                break;
            }
        }
    }
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blueColor]];
    
    //2.扫一扫按钮
    CGRect btnScanRect = CGRectMake(0, 20, 44, 44);
    _btnScan = [[BadgeButton alloc]initWithFrame:btnScanRect];
    [_btnScan setBackgroundImage:[UIImage imageNamed:saoyisaoBtnImageName] forState:UIControlStateNormal];
    [_btnScan addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnScan setTag:CZJButtonTypeHomeScan];
    [_btnScan setHidden:YES];
    
    //3.返回按钮
    CGRect btnBackRect = CGRectMake(0, 20, 44, 44);
    _btnBack = [[ BadgeButton alloc ]initWithFrame:btnBackRect];
    [_btnBack setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack setTag:CZJButtonTypeNaviBarBack];
    [_btnBack setHidden:YES];
    
    //头像按钮
    _btnHead = [PUtils getXibViewByName:@"HeadInfoButtonView"];
    [_btnHead setFrame:btnBackRect];
    [_btnHead setTag:CZJButtonTypeNaviHead];
    [_btnHead.headBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnHead setHidden:YES];
    
    //4.更多按钮
    CGRect btnMoreRect = CGRectMake(CGRectGetMaxX(_selfBounds) - 58, 20, 44, 44);
    _btnMore = [[ BadgeButton alloc ]initWithFrame:btnMoreRect];
    [_btnMore setBackgroundImage:[UIImage imageNamed:@"prodetail_btn_more"] forState:UIControlStateNormal];
    [_btnMore addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnMore setTag:CZJButtonTypeNaviBarMore];
    [_btnMore setHidden:YES];

    
    //5.购物车按钮
    CGRect btnShopRect = CGRectMake(CGRectGetMaxX(_selfBounds) - 44, 20, 44, 44);
    _btnShop = [[BadgeButton alloc]initWithFrame:btnShopRect];
    [_btnShop setBackgroundImage:[UIImage imageNamed:shopBtnImageName] forState:UIControlStateNormal];
    [_btnShop addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnShop setTag:CZJButtonTypeHomeShopping];
    [_btnShop setHidden:YES];
    //购物车右上角数量角标
    _btnShopBadgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 16, 16)];
    _btnShopBadgeLabel.textColor = [UIColor whiteColor];
    NSString* shoppingCartCount = [USER_DEFAULT valueForKey:kUserDefaultShoppingCartCount];
    if ([shoppingCartCount intValue]<= 0)
    {
        _btnShopBadgeLabel.text = @"";
        _btnShopBadgeLabel.hidden = YES;
    }
    else
    {
        _btnShopBadgeLabel.text = [NSString stringWithFormat:@"%@",shoppingCartCount];
        _btnShopBadgeLabel.hidden = NO;
    }
    _btnShopBadgeLabel.font = [UIFont boldSystemFontOfSize:10];
    _btnShopBadgeLabel.textAlignment = NSTextAlignmentCenter;
    _btnShopBadgeLabel.layer.backgroundColor = CZJREDCOLOR.CGColor;
    _btnShopBadgeLabel.layer.cornerRadius = 8;
    [_btnShop addSubview:_btnShopBadgeLabel];
    
    //6.列表分类按钮
    CGRect btnArrangeRect = CGRectMake(CGRectGetMaxX(_selfBounds) - 44, 10, 24, 24);
    _btnArrange = [[BadgeButton alloc]initWithFrame:btnArrangeRect];
    [_btnArrange setBackgroundImage:[UIImage imageNamed:arrangeBtnImageName] forState:UIControlStateNormal];
    [_btnArrange addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btnArrange setTag:CZJButtonTypeNaviArrange];
    [_btnArrange setHidden:YES];

    //标题
    _mainTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, PJ_SCREEN_WIDTH - 120, 44)];
    _mainTitleLabel.font = BOLDSYSTEMFONT(20);
    _mainTitleLabel.hidden = YES;
    _mainTitleLabel.textColor = WHITECOLOR;
    _mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _buttomSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, 63, PJ_SCREEN_WIDTH, 0.5)];
    _buttomSeparator.backgroundColor = CZJNAVIBARBGCOLOR;
    _buttomSeparator.hidden = YES;
    
    switch (type) {
        case CZJNaviBarViewTypeHome:
            //导航栏添加扫一扫
            [self setBackgroundColor:CLEARCOLOR];
            [_btnScan setHidden:NO];
            break;
            
        case CZJNaviBarViewTypeBack:
            //导航栏返回按钮
            [_buttomSeparator setHidden:NO];
            [_btnBack setHidden:NO];
            shopBtnImageName = @"btn_shopping";
            break;
            
        case CZJNaviBarViewTypeStoreDetail:
            [self setBackgroundColor:CLEARCOLOR];
            [_btnBack setHidden:NO];
            [_btnMore setHidden:NO];
            
            btnBackRect =  CGRectMake(14, 2, 40, 40);
            _btnBack.frame = btnBackRect;
            _btnBack.backgroundColor = RGB(230, 230, 230);
            _btnBack.layer.cornerRadius = 20;
            
            btnMoreRect = CGRectMake(CGRectGetMaxX(_selfBounds) - 54, 2, 40, 40);
            _btnMore.frame = btnMoreRect;
            _btnMore.backgroundColor = RGB(230, 230, 230);
            _btnMore.layer.cornerRadius = 20;
            [_btnMore setBackgroundImage:[UIImage imageNamed:@"prodetail_btn_morenor"] forState:UIControlStateNormal];
            
            searchaBarRect = CGRectMake(CGRectGetMinX(_selfBounds) + 54,
                                        2,
                                        _selfBounds.size.width - (54 * 2),
                                        40);
            _customSearchBar.frame = searchaBarRect;
            break;
            
        case CZJNaviBarViewTypeDetail:
            //详情界面返回按钮，购物车，更多按钮，且图片和位置都不同
            //只有详情界面不需要导航栏
            [self setBackgroundColor:CLEARCOLOR];
            [_btnBack setHidden:NO];
            [_btnMore setHidden:NO];
            [_customSearchBar setHidden:YES];
            
            btnBackRect =  CGRectMake(14, 2, 40, 40);
             _btnBack.frame = btnBackRect;
            _btnBack.backgroundColor = RGB(230, 230, 230);
            _btnBack.layer.cornerRadius = 20;
           
            btnMoreRect = CGRectMake(CGRectGetMaxX(_selfBounds) - 54, 2, 40, 40);
            _btnMore.frame = btnMoreRect;
            _btnMore.layer.cornerRadius = 20;
            _btnMore.backgroundColor = RGB(230, 230, 230);
            [_btnMore setBackgroundImage:[UIImage imageNamed:@"prodetail_btn_morenor"] forState:UIControlStateNormal];
            break;
            
        case CZJNaviBarViewTypeGoodsList:
            //商品列表界面
            [_btnBack setHidden:NO];
            [_btnArrange setHidden:NO];
            break;
            
        case CZJNaviBarViewTypeMain:
            _customSearchBar.hidden = YES;
            _mainTitleLabel.hidden = NO;
            _buttomSeparator.hidden = NO;
            _btnMore.hidden = NO;
            [_btnMore setBackgroundImage:IMAGENAMED(@"shop_btn_map") forState:UIControlStateNormal];
            [_btnMore setTag:CZJButtonTypeMap];
            break;
            
        case CZJNaviBarViewTypeGeneral:
            _customSearchBar.hidden = YES;
            _mainTitleLabel.hidden = NO;
            _mainTitleLabel.font = BOLDSYSTEMFONT(18);
            _btnBack.hidden = NO;
            _buttomSeparator.hidden = NO;
            break;
            
        case CZJNaviBarViewTypeScan:
            _customSearchBar.hidden = YES;
            _mainTitleLabel.hidden = NO;
            _mainTitleLabel.font = BOLDSYSTEMFONT(18);
            _mainTitleLabel.textColor = WHITECOLOR;
            _btnBack.hidden = NO;
            break;
            
        case CZJNaviBarViewTypeSearch:
            _customSearchBar.frame = CGRectMake(10, 2, PJ_SCREEN_WIDTH - 20, 40);
            break;
            
        case CZJNaviBarViewTypeFourservice:
        {
            _customSearchBar.hidden = YES;
            _mainTitleLabel.hidden = NO;
            _btnHead.frame = CGRectMake(15, 20, 44, 44);
            [_btnMore setSize:CGSizeMake(50, 44)];
            _btnMore.hidden = NO;
            _btnMore.titleLabel.font = SYSTEMFONT(15);
            [_btnMore setBackgroundImage:NULL forState:UIControlStateNormal];
            [_btnMore setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        }
            break;
            
        default:
            break;
    }

    [self addSubview:_btnHead];
    [self addSubview:_customSearchBar];
    [self addSubview:_btnScan];
    [self addSubview:_btnBack];
    [self addSubview:_btnMore];
    [self addSubview:_btnArrange];
    [self addSubview:_mainTitleLabel];
    [self addSubview:_buttomSeparator];
}




#pragma mark- UISearchBarDelegate
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //跳转到搜索页面
    [PUtils showSearchView:(UIViewController*)_delegate andNaviBar:self];
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)clickButton:(id)sender
{
    __block UIButton* touchBt = (UIButton*)sender;
    [touchBt setEnabled:NO];
    
    switch (touchBt.tag) {
        case CZJButtonTypeHomeShopping:
            if ([PUtils isLoginIn:(UIViewController*)_delegate andNaviBar:self])
            {
//                FourServicepingCartController* shoppingCart = (FourServicepingCartController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"SBIDShoppingCart"];
//                [((UIViewController*)_delegate).navigationController pushViewController:shoppingCart animated:YES];
            }
            break;
            
        case CZJButtonTypeHomeScan:
        {
            if ([PUtils isCameraAvailable:((UIViewController*)_delegate)])
            {
                CZJScanQRController* scanVC = (CZJScanQRController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:kCZJStoryBoardIDScanQR];
                [((UIViewController*)_delegate).navigationController pushViewController:scanVC animated:YES];
            }
        }
            
            break;
            
        default:
            if ([_delegate respondsToSelector:@selector(clickEventCallBack:)])
            {
                [_delegate clickEventCallBack:sender];
            }
            break;
    }
    
    GeneralBlockHandler generBlock = ^()
    {
        [touchBt setEnabled:YES];
    };
    [PUtils performBlock:generBlock afterDelay:0.5];
}

- (void)didCancel:(id)controller
{
//    if ([controller isKindOfClass: [CZJLoginController class]] )
//    {
//        [PUtils removeLoginViewFromCurrent:(UIViewController*)_delegate];
//        [self refreshShopBadgeLabel];
//    }
//    else if ([controller isKindOfClass:[CZJSearchController class]])
//    {
//        [PUtils removeSearchVCFromCurrent:(UIViewController*)_delegate];
//    }
    
    if ([self.delegate respondsToSelector:@selector(removeShoppingOrLoginView:)])
    {
        [self.delegate removeShoppingOrLoginView:self];
    }
}


@end
