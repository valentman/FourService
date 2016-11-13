//
//  CZJScanQRController.m
//  CZJShop
//
//  Created by Joe.Pen on 11/19/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "CZJScanQRController.h"
#import "CZJQRView.h"
#import "FSWebViewController.h"
#import "FSBaseDataManager.h"
#import "FSConfirmInfoController.h"


@interface CZJScanQRController ()
<
AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate
>
{
    AVCaptureSession * _AVSession;
    CGSize transparentArea;
    BOOL isHomeview;
    
    __block CZJSCanQRForm* scanForm;
}
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIView *operatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *readyLabel;

@property (strong, nonatomic) UIButton* btnTorch;
@property (strong, nonatomic) UILabel* hintLabel;
@property (strong, nonatomic) UIView* boxView;
@property (strong, nonatomic) CZJQRView* qrView;
@property (strong, nonatomic) CALayer* scanLayer;
@property (strong, nonatomic) AVCaptureSession * AVSession;
@property (strong, nonatomic) AVCaptureSession* captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* videoPreviewLayer;
@property (nonatomic) BOOL isReading;
@property (nonatomic) BOOL isLighting;
@property (nonatomic) BOOL dragDown;

- (void)openTorch:(id)sender;
- (void)stopReading;
- (BOOL)startReading;
@end

@implementation CZJScanQRController

#pragma mark- Init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScanData];
    [self initViews];
}

- (void)initScanData
{
    _captureSession = nil;
    _isReading = NO;
    _isLighting = NO;
    _dragDown = YES;
    
    transparentArea = CGSizeMake(PJ_SCREEN_WIDTH * 0.6, PJ_SCREEN_WIDTH * 0.6);
    scanForm = [[CZJSCanQRForm alloc]init];
}

- (void)initViews
{
    [_operatorView addSubview:self.qrView];
    
    //导航栏初始
    [PUtils hideSearchBarViewForTarget:self];
    [self addCZJNaviBarView:CZJNaviBarViewTypeScan];
    self.naviBarView.mainTitleLabel.text = @"二维码";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //打开/关闭闪光灯按钮
    _btnTorch = [[ UIButton alloc ]initWithFrame:CGRectMake((PJ_SCREEN_WIDTH - 100)*0.5, PJ_SCREEN_HEIGHT - 150, 100, 100)];
    [_btnTorch setImage:IMAGENAMED(@"scan_icon_light") forState:UIControlStateNormal];
    [_btnTorch setImage:IMAGENAMED(@"scan_icon_light_sel") forState:UIControlStateSelected];
    [_btnTorch addTarget:self action:@selector(openTorch:) forControlEvents:UIControlEventTouchUpInside];
    [_btnTorch setSelected:NO];
    [_operatorView addSubview:_btnTorch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_operatorView setHidden:YES];
    _indicator.hidden = NO;
    [_indicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([PUtils isCameraAvailable])
    {
        [self startReading];
    }
    else
    {
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        _isLighting = NO;
        [_btnTorch setSelected:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(CZJQRView *)qrView {
    
    if (!_qrView) {
        
        CGRect screenRect = PJ_SCREEN_BOUNDS;
        _qrView = [[CZJQRView alloc] initWithFrame:screenRect];
        _qrView.transparentArea = transparentArea;
        _qrView.backgroundColor = CLEARCOLOR;
    }
    return _qrView;
}

#pragma mark- 开关闪光灯
- (void)openTorch:(UIButton*)sender {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        if (!_isLighting)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            _isLighting = YES;
            [sender setSelected:YES];
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            _isLighting = NO;
            [sender setSelected:NO];
        }
    }
}


- (BOOL)startReading
{
    NSError* error;
    _readyLabel.hidden = NO;
    //1.初始化捕捉设备，类型为AVMediaTypeVideo
    AVCaptureDevice* captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用caputureDevice创建输入流
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput* captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    
    //4.实例化捕捉回话
    _captureSession = [[AVCaptureSession alloc]init];
    //4.1将输入流添加到会话
    [_captureSession addInput:input];
    //4.2将媒体输出流添加到会话
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流到队列当中
    dispatch_queue_t _dispatchQueue;
    _dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:_dispatchQueue];
    //5.2设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_preView.layer.bounds]; //全屏
    
    //9.将图层添加到预览view的图层上
    [_preView.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);

    //11开始扫描
    [_captureSession startRunning];
    [_indicator stopAnimating];
    [_operatorView setHidden:NO];
    _readyLabel.hidden = YES;
    
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.font = [UIFont systemFontOfSize:12];
    _hintLabel.text = @"对准二维码到框内，即可自动扫描";
    _hintLabel.textColor = LIGHTGRAYCOLOR;
    [_operatorView addSubview:_hintLabel];
    [_hintLabel setFrame:CGRectMake(PJ_SCREEN_WIDTH*0.5 - 95, (PJ_SCREEN_HEIGHT  + _preView.bounds.size.height*0.7*PJ_SCREEN_ASPECTRATIO)*0.5 - 30, 190, 15)];
    return YES;
}



#pragma mark- AVCaptureMetadataOutputObjectsDelegate
#pragma mark 二维码信息读取成功返回后处理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type]isEqualToString:AVMetadataObjectTypeQRCode])
        {
            [_captureSession stopRunning];
            NSString* scanStr = metadataObj.stringValue;
            [self performSelectorOnMainThread:@selector(dealWithQRScanData:) withObject:scanStr waitUntilDone:NO];
        }
    }
}


#pragma mark- 开始扫描

- (void)dealWithQRScanData:(NSString*)scanStr
{
    __block BOOL isOver = YES;
    
    if ([scanStr containsString:@"www.carnettech.com"])
    {
        scanForm.operationType = @"0";
        _isReading = NO;
        scanForm.storeType = @"4";
        scanForm.content = scanStr;
    }
    else if ([scanStr hasPrefix:@"http://"] || [scanStr hasPrefix:@"https://"])
    {//判断此二维码是网址链接
        FSWebViewController* webView = (FSWebViewController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"webViewSBID"];
        webView.cur_url = scanStr;
        [self stopReading];
        [self.navigationController pushViewController:webView animated:YES];
        return;
    }
    else
    {//判断此二维码是预设信息
        NSDictionary* dict = [PUtils dictionaryFromJsonString:scanStr];
        scanForm = [CZJSCanQRForm objectWithKeyValues:dict];
        _isReading = NO;
    }
    
    if ([scanForm.operationType isEqualToString:@"0"])
    {//付款二维码
        switch ([scanForm.storeType integerValue]) {// 0-加油站 1-4S 2-快修店 3-洗车店
            case 0:// 0-加油站
            {
                FSConfirmInfoController* detailVC = (FSConfirmInfoController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:kCZJStoryBoardIDConfirmPay];
                detailVC.scanQRForm = scanForm;
                [self.navigationController pushViewController:detailVC animated:YES];
                isOver = YES;
            }
                break;
                
            case 1:// 1-4S
            {
                
            }
                break;
                
            case 2://快修店
            {
            }
                break;
                
            case 3://洗车店
                break;
                
            case 4://链接
            {
                FSConfirmInfoController* detailVC = (FSConfirmInfoController*)[PUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:kCZJStoryBoardIDConfirmPay];
                detailVC.payMentUrl = scanForm.content;
                [self.navigationController pushViewController:detailVC animated:YES];
                isOver = YES;
            }
                break;
                
            default:
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"无效二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                isOver = NO;
            }
                break;
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"无效二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        isOver = NO;
    }
    
    
    
    if (isOver)
    {
        [self stopReading];
    }
}

- (void)stopReading
{
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    _indicator.hidden = YES;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_captureSession startRunning];
}
@end
