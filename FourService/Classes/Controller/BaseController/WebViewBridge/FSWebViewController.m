//
//  FSWebViewController.m
//  FourService
//
//  Created by Joe.Pen on 2/27/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "FSWebViewController.h"
#import "FSWebViewJSI.h"
#import "UIScrollView+EmptyDataSet.h"
#import "IMYWebView.h"
#import "ShareMessage.h"
#import <WebKit/WebKit.h>

@interface FSWebViewController ()
<
IMYWebViewDelegate,
jsActionDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
{
}
@property (strong, nonatomic)FSWebViewJSI* webViewJSI;
@property (strong, nonatomic)IMYWebView* myWebView;
@property (nonatomic) UIProgressView *progressView;
@property (nonatomic, getter=didFailLoading) BOOL failedLoading;

@end

@implementation FSWebViewController
@synthesize cur_url = _cur_url;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews
{
    //导航栏
    [self addCZJNaviBarView:CZJNaviBarViewTypeGeneral];
    self.naviBarView.btnMore.hidden = NO;
    [self.naviBarView.btnMore setBackgroundImage:IMAGENAMED(@"") forState:UIControlStateNormal];
    [self.naviBarView.btnMore setTitle:@"关闭" forState:UIControlStateNormal];
    [self.naviBarView.btnMore setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    self.naviBarView.mainTitleLabel.text = self.webTitle;
    
    //WebView定义
    self.myWebView.scrollView.emptyDataSetDelegate = self;
    self.myWebView.scrollView.emptyDataSetSource = self;
    self.myWebView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - 64)];
    [self.myWebView setDelegate:self];
    [self.view addSubview:self.myWebView];
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 64, PJ_SCREEN_WIDTH, 2);
    [self.progressView setProgressTintColor:FSBLUECOLOR];
    [self.view addSubview:self.progressView];
    
    //URLRequest
    if (_cur_url)
    {
        if (![_cur_url hasPrefix:@"http://"])
        {
            _cur_url = [NSString stringWithFormat:@"%@%@",@"http://",_cur_url];
        }
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_cur_url]]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.myWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.myWebView.estimatedProgress animated:YES];
        
        if(self.myWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)dealloc {
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - PBaseNaviagtionBarViewDelegate(自定义导航栏按钮回调)
- (void)clickEventCallBack:(nullable id)sender
{
    UIButton* barButton = (UIButton*)sender;
    switch (barButton.tag) {
        case CZJButtonTypeNaviBarMore:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case CZJButtonTypeNaviBarBack:
            if ([self.myWebView canGoBack])
            {
                [self.myWebView goBack];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            break;
    }
}


#pragma mark- IMYWebViewDelegate
- (void)webViewDidStartLoad:(IMYWebView *)webView
{
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id json, NSError * error) {
        weakSelf.naviBarView.mainTitleLabel.text = json;
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.failedLoading = NO;
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.failedLoading = YES;
    [self.myWebView.scrollView reloadEmptyDataSet];
    
}



#pragma mark - jsActionDelegate （JS网页交互代理）
- (void)showGoodsOrServiceInfo:(NSDictionary*)dict
{
    NSLog(@"%@",dict);
    CZJDetailType detaitype = [[dict valueForKey:@"itemType"] integerValue] == 0 ? CZJDetailTypeGoods : CZJDetailTypeService;
    CZJGoodsPromotionType promotionType = [[dict valueForKey:@"promotionType"] integerValue];
    NSString* promotionPrice = [dict valueForKey:@"promotionPrice"];
    NSString* storeItemPid = [dict valueForKey:@"storeItemPid"];
    [PUtils showGoodsServiceDetailView:self.navigationController andItemPid:storeItemPid detailType:detaitype promotionType:promotionType promotionPrice:promotionPrice];
}

- (void)showStoreInfo:(NSString*)storeId
{
    [PUtils showStoreDetailView:self.navigationController andStoreId:storeId];
}

- (void)toSettleOrder:(NSArray*)_settleOrderAry andCouponUsable:(BOOL)couponUseable
{
    if ([PUtils isLoginIn:self andNaviBar:self.naviBarView])
    {
    }
}

-(void)showToast:(NSString*)msg
{
    [PUtils tipWithText:msg andView:self.navigationController.view];
}

- (void)toShare:(NSArray*)json
{
    NSString* desc = json.firstObject;
    NSString* imgUrl = json[1];
    NSString* title = json[3];
    NSString* shareUrl = json[2];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PUtils downloadImageWithURL:imgUrl andFileName:@"storeShare_icon.png" withSuccess:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSData* imageData =[NSData dataWithContentsOfFile:[DocumentsDirectory stringByAppendingPathComponent:@"storeShare_icon.png"]];
        [[ShareMessage shareMessage] showPanel:self.view
                                          type:1
                                         title:title
                                          body:desc
                                          link:shareUrl
                                         image:imageData];
    } andFail:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSData* imageData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_icon" ofType:@"png"]];
        [[ShareMessage shareMessage] showPanel:self.view
                                          type:1
                                         title:title
                                          body:desc
                                          link:shareUrl
                                         image:imageData];
    }];
}

@end
