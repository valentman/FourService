//
//  FSNetworkManager.m
//  FourService
//
//  Created by Joe.Pen on 11/18/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "FSNetworkManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation FSNetworkManager

singleton_implementation(FSNetworkManager)
-(id)init{
    if (self = [super init]) {
        
        return self;
    }
    
    return nil;
}

//检测网络状态
- (void)checkNetWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    }];
}



//上传图片
- (void)uploadImageWithUrl:(NSString *)urlStr
                     Image:(UIImage *)image
                Parameters:(id)parameters
                   success:(SuccessBlockHandler)success
                   failure:(FailureBlockHandler)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* path =  [self getPath:urlStr];
    
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        //        NSString *str = [formatter stringFromDate:[NSDate date]];
        //        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}



- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(SuccessBlockHandler)success
                   fail:(FailureBlockHandler)fail
{
    NSString* path =  [self getPath:urlStr];
    DLog(@"\nServerAPI:%@, \nParameter:%@",path,[parameters description]);
    
    //这里暂时设置成Get方式。
    [self postJSONWithUrl:path withRequestType:AFRequestTypeGet parameters:AFRequestTypePost success:success fail:fail];
}

- (void)postJSONWithUrl:(NSString *)urlStr
        withRequestType:(AFRequestType)requestType
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(FailureBlockHandler)fail
{
    if (AFRequestTypePost == requestType)
    {
        [self postJSONWithNoServerAPI:urlStr parameters:parameters success:success fail:fail];
    }
    else if (AFRequestTypeGet == requestType)
    {
        [self GetJSONDataWithUrl:urlStr parameter:parameters success:success fail:fail];
    }
}


//Post请求网络数据
- (void)postJSONWithNoServerAPI:(NSString *)urlStr
                     parameters:(id)parameters
                        success:(SuccessBlockHandler)success
                           fail:(FailureBlockHandler)fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 设置返回格式
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager POST:urlStr
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              DLog();
              if (success)
              {
                  success(responseObject);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              if (fail) {
                  fail();
              }
          }
     ];
}



//Get请求网络数据
- (void)GetJSONDataWithUrl:(NSString *)url
                 parameter:(id)parameter
                   success:(SuccessBlockHandler) success
                      fail:(FailureBlockHandler)fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    parameter = @{@"format": @"json"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url
      parameters:parameter
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 DLog(@"%@",[responseObject description]);
                 success(responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
             if (fail) {
                 fail();
             }
         }];
    
    
}

- (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        /**    URLWithString返回的是网络的URL,如果使用本地URL,需要注意
         * @eg NSURL *fileURL1 = [NSURL URLWithString:path];
         */
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    [task resume];
}


- (NSString*)getPath:(NSString*)cmd{
    return [NSString stringWithFormat:@"%@%@",kCZJServerAddr,cmd];
}

- (void)postJSONWithParameters:(id)parameters
                       success:(void (^)(id))success
                          fail:(void (^)())fail{
    
    [self postJSONWithUrl:@"http://192.168.0.148:8080/appserver/chezhu/register.do" parameters:parameters success:success fail:fail];
}


- (void)loadImagePath:(NSString*)path callback:(void (^)(id responseObject))callfun{
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        callfun(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}


- (void)saveImage:(UIImage *)image withFilename:(NSString *)filename
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"HTTPClientImages/"];
	   
    BOOL isDir;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if(!isDir) {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            
            NSLog(@"%@",error);
        }
    }
    
    path = [path stringByAppendingPathComponent:filename];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSLog(@"Written: %d",[imageData writeToFile:path atomically:YES]);
}



@end
