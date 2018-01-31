 #import "NetAccess.h"
#import "HzTools.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
//#import "UIProgressView+AFNetworking.h"
@implementation NetAccess
#define isLoadingStr  @"加载中..."

#define kTimeoutInterval 45.f

/*
   AFNetworking是一款在OS X和iOS下都令人喜爱的网络库。为了迎合iOS新版本的升级,AFNetworking在3.0版本中删除了基于 NSURLConnection API的所有支持。如果你的项目以前使用过这些API，建议您立即升级到基于 NSURLSession 的API的
*/
// 检测网路状态
+ (void)netWorkStatus
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
        NSLog(@"网络状态：%ld", (long)status);
        if(status==0)
        {
            [HzTools showHudWithOnlySting:@"当前网络不可用或不稳定" withTime:3];
        }
    }];
}

#pragma mark ------ 上传那图片
+(void)postUploadImageWithURL:(NSString *)URLString params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimeType loadingView:(BOOL)isLoadingView loadingViewStr:(NSString *)loadStr progress:(void(^)(NSProgress *))progress success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if ([NSString isBlankString:loadStr])
        {
            sttr = loadStr;
        }
        else
        {
            sttr =@"上传中...";
        }
        [HzTools showLoadingViewWithString:sttr];
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.operationQueue.maxConcurrentOperationCount = 1;
    manager.requestSerializer.timeoutInterval = 60.f;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //https验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            [HzTools hiddenLoadingView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
            [HzTools hiddenLoadingView];
        }
    }];
    
}

#pragma mark - GET---JSON方式获取数据

+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary *)dic WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id json))success fail:(void (^)())fail
{
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if (loadStr!=nil&loadStr.length!=0)
        {
            sttr = loadStr;
        }
        else
        {
            sttr =isLoadingStr;
        }
        [HzTools showLoadingViewWithString:sttr];
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    //如果报接受类型不一致请替换一致text/html或别的
    
    // 加上这行代码，https ssl 验证。
    [sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    // Get请求
    [sessionManager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress)
    {
        // 这里可以获取到目前的数据请求的进度
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (success)
        {
            success(responseObject);
            [HzTools hiddenLoadingView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (fail)
        {
            fail(error);
            [HzTools hiddenLoadingView];
            
        }
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"error ---%@",error);
    }];
}

+ (void)getForEncryptJSONDataWithUrl:(NSString *)url parameters:(NSArray *)array WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id json))success fail:(void (^)())fail
{
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if (loadStr!=nil&loadStr.length!=0)
        {
            sttr = loadStr;
        }
        else
        {
            sttr =isLoadingStr;
        }
        [HzTools showLoadingViewWithString:sttr];
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = 60.f;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    //如果报接受类型不一致请替换一致text/html或别的
    
    // 加上这行代码，https ssl 验证。
    [sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    // Get请求
    
    __block NSString *urlString = [NSString string];
    if(array)
    {
       
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx==0)
            {
                urlString = [urlString stringByAppendingFormat:@"%@", obj];
            }else
            {
                 urlString = [urlString stringByAppendingFormat:@"&%@", obj];
            }
        }];
    }
//    NSString *sign = [[NetAccess md5_32bit:[NSString stringWithFormat:@"%@app_interface",urlString]] lowercaseString];
        NSString *sign = [NetAccess md532BitLower:[NSString stringWithFormat:@"%@app_interface",urlString]];
    urlString = [urlString stringByAppendingFormat:@"&sign=%@",sign];
    url = [url stringByAppendingFormat:@"?%@", urlString];
    [sessionManager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
         // 这里可以获取到目前的数据请求的进度
     }
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
             [HzTools hiddenLoadingView];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
         if (fail)
         {
             fail(error);
             [HzTools hiddenLoadingView];
             
         }
         // 请求失败
         NSLog(@"%@", [error localizedDescription]);
         NSLog(@"error ---%@",error);
     }];
}


+(void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary *)dic success:(void (^)(id))success fail:(void (^)())fail{

    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    //如果报接受类型不一致请替换一致text/html或别的
    
    // 加上这行代码，https ssl 验证。
    [sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    // Get请求
    [sessionManager GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress)
     {
         // 这里可以获取到目前的数据请求的进度
     }
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
         if (fail)
         {
             fail(error);
         }
         // 请求失败
         NSLog(@"%@", [error localizedDescription]);
         NSLog(@"error ---%@",error);
     }];
    
}


#pragma mark - xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict progress:^(NSProgress *_Nonnull downloadProgress)
    {
    } success:^(NSURLSessionDataTask *_Nullable task,id _Nonnull responseObject)
    {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
         if (fail) {
             fail();
         }

     }];
    
}
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 网络请求加载等待框
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if (loadStr!=nil&loadStr.length!=0)
        {
            sttr = loadStr;
        }
        else
        {
            sttr =isLoadingStr;
        }
        [HzTools showLoadingViewWithString:sttr];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    // 设置请求格式默认为二进制
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式为json
    //  manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的
    
    //responseSerializer 使用 AFHTTPResponseSerializer，这样就不能享受 AFNetworking 自带的JSON解析功能了，拿到 responseObject 就是一个　Data 对象，需要自己根据需要进行反序列化。
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlStr parameters:parameters progress:^(NSProgress *progress)
     {
     } success:^(NSURLSessionDataTask *_Nullable task,id _Nonnull responseObject)
     {
         if (success)
         {
             [HzTools hiddenLoadingView];
             // 自己进行数据解析
             NSError *myError;
             
             NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&myError];
             if(dic == nil ||
                [[[dic valueForKey:@"data"] class] isSubclassOfClass:[NSNull class]])
             {
                 NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                 dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&myError];
             }
             
             NSInteger status = [dic int64ValueForKey:@"status"];
             if (status == 0) {
                 success(dic);
             } else {
                 [HzTools showHudWithOnlySting:[dic objectOrNilForKey:@"msg"] withTime:2];
             }
         }
     }failure:^(NSURLSessionDataTask*_Nullable task,NSError *error)
     {
         [HzTools showHudWithOnlySting:@"连接失败,请重试" withTime:1];
         if (fail)
         {
             fail();
             [HzTools hiddenLoadingView];
         }
     }];
}

+ (void)getJSONHeaderWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 网络请求加载等待框
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if (loadStr!=nil&loadStr.length!=0)
        {
            sttr = loadStr;
        }
        else
        {
            sttr =isLoadingStr;
        }
        [HzTools showLoadingViewWithString:sttr];
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = kTimeoutInterval;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    [sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlStr parameters:parameters error:nil];
    request.timeoutInterval= kTimeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    __block NSString *urlString = [NSString string];
    NSData *body  =[urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error==nil)
        {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if(dic == nil ||
               [[[dic valueForKey:@"data"] class] isSubclassOfClass:[NSNull class]])
            {
                NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            }
            [HzTools hiddenLoadingView];
            success(dic);
            
        }else
        {
            if (fail)
            {
                [HzTools hiddenLoadingView];
                fail();
                
            }
        }
        
    }]resume];
    
}

#pragma mark - JSON方式post提交数据
+ (void)postForEncryptJSONWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 网络请求加载等待框
    if (isLoadingView)
    {
        NSString * sttr = nil;
        if (loadStr!=nil&loadStr.length!=0)
        {
            sttr = loadStr;
        }
        else
        {
            sttr =isLoadingStr;
        }
        [HzTools showLoadingViewWithString:sttr];
    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    // 设置超时时间

//    
//    // 加上这行代码，https ssl 验证。
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    request.timeoutInterval= 60.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    __block NSString *urlString = [NSString string];
    if([parameters isKindOfClass:[NSArray class]])
    {
        
        [parameters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx==0)
            {
                urlString = [urlString stringByAppendingFormat:@"%@", obj];
            }else
            {
                urlString = [urlString stringByAppendingFormat:@"&%@", obj];
            }
        }];
    }
    //    NSString *sign = [[NetAccess md5_32bit:[NSString stringWithFormat:@"%@app_interface",urlString]] lowercaseString];
    NSString *sign = [NetAccess md532BitLower:[NSString stringWithFormat:@"%@app_interface",urlString]];
    urlString = [urlString stringByAppendingFormat:@"&sign=%@",sign];
    NSData *body  =[urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                 @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error==nil)
        {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if(dic == nil ||
               [[[dic valueForKey:@"data"] class] isSubclassOfClass:[NSNull class]])
            {
                NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            }
            
            success(dic);
        }else
        {
            [HzTools showHudWithOnlySting:@"连接失败,请重试" withTime:1];
            if (fail)
            {
                fail();
                [HzTools hiddenLoadingView];
            }
        }
        
    }]resume];
    
}


#pragma mark - Session 下载下载文件
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress *_Nonnull downloadProgress)
                                      {
                                          
                                      } destination:^NSURL *(NSURL *targetPath,NSURLResponse*response){
                                          // 指定下载文件保存的路径
                                          // NSLog(@"%@ %@", targetPath, response.suggestedFilename);
                                          // 将下载文件保存在缓存路径中
                                          NSString *cacheDir = [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()];
                                          NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                                          
                                          // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
                                          //         NSURL *fileURL = [NSURL URLWithString:path];
                                          NSURL *fileURL = [NSURL fileURLWithPath:path];
                                          return fileURL;
                                          
                                          
                                          
                                          
                                      } completionHandler:^(NSURLResponse *response,NSURL *filePath,NSError *error){
                                          // 用error判断是否下载完成
                                          if (!error)
                                          {
                                              success(filePath);
                                          }
                                          if (error)
                                          {
                                              fail();
                                          }
                                          
                                      }];
    
    [task resume];
}

#pragma mark - 文件上传 自己定义文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    TLAccount * account = [TLAccountSave account];
    NSDictionary *upLoadDic =[[NSDictionary alloc] initWithObjectsAndKeys:account.uuid,@"uuid", nil];
    [manager POST:urlStr parameters:upLoadDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     
     {
         
         //  NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
         // 要上传保存在服务器中的名称
         // 使用时间来作为文件名
         // 让不同的用户信息,保存在不同目录中
         //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         //        // 设置日期格式
         //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
         
         //@"image/png"
         [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
         
     } progress:^(NSProgress *gress)
     {
         // 进度
     } success:^(NSURLSessionDataTask *_Nullable task,id responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask *_Nullable task,NSError *error)
     {
         if (fail)
         {
             NSLog(@"失败:%@",error);
             fail();
         }
     }];
}

#pragma mark - POST上传文件
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
        
        
    } progress:^(NSProgress *progerss){
    } success:^(NSURLSessionDataTask *task,id responseObject){
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task,NSError *error){
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }
        
    }];
    
}
#pragma mark --上传头像--
+(void)uploadWithURL:(NSString *)URLString
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
             success:(void (^)(id responseObject))success
                fail:(void (^)(NSError *error))fail
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  设置请求格式
     */
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
        manager.requestSerializer.timeoutInterval = 60.f;
    /**
     *  设置返回格式
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];

    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }

    }];
}



+ (void)uploadFileWithMediaData:(NSData *)data url:(NSString *)url params:(id)params success:(void (^)(id responseObject))success
                           fail:(void (^)(NSError *error))fail
{
    
    //    __weak typeof(self)weakSelf = self;
    // AFNetWorking 上传视频
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                         @"text/plain",
                                                         @"application/json",nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 120.f;
    
    /**
     *  设置返回格式
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:@"file.mp4"
                                mimeType:@"video/quicktime"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 上传失败
        if (fail) {
            fail(error);
        }
        
    }];
}


#pragma mark --多图上传--
+(void)commentUploadWithURL:(NSString *)URLString
              params:(NSDictionary *)params
                arr:(NSMutableArray *)imageDataArray
            mimeType:(NSString *) mimeType
             success:(void (^)(id responseObject))success
                fail:(void (^)(NSError *error))fail
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  设置请求格式
     */
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    manager.operationQueue.maxConcurrentOperationCount = 6;
    /**
     *  请求超时的时间
     */
        manager.requestSerializer.timeoutInterval = 60.f;
    /**
     *  设置返回格式
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[self customSecurityPolicy]];

    [manager POST:[NSString stringWithFormat:@"%@%@",testHost,URLString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        for(NSInteger i = 0; i <imageDataArray.count; i++)
        {
            NSData * imageData = [imageDataArray objectAtIndex: i];
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"%zi", i+1];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"%@.png", Name];
            
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:mimeType];
        }

        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
        
    }];
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    return securityPolicy;
}

#pragma mark - POST上传崩溃日志
+ (void)postUploadCrashWithUrl:(NSString *)urlStr Data:(NSData *)data
                     path:(NSString *)path parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 实际上就是AFN没有对响应数据做任何处理的情况
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /**
     *  设置请求格式
     */
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 60.f;
    /**
     *  设置返回格式
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
         [formData appendPartWithFileData:data name:@"file" fileName:@"file.txt" mimeType:@"txt"];
        
        
    } progress:^(NSProgress *progerss){
    } success:^(NSURLSessionDataTask *task,id responseObject){
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task,NSError *error){
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }
        
    }];
    
}
+ (NSString *)md5_32bit:(NSString *)input {
         //传入参数,转化成char
         const char * str = [input UTF8String];
         //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
         unsigned char md[CC_MD5_DIGEST_LENGTH];
        /*
           7      extern unsigned char * CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
           8      把str字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了md这个空间中
           9      */
         CC_MD5(str, (int)strlen(str), md);
         //创建一个可变字符串收集结果
         NSMutableString * ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
                 /**
                    15          X 表示以十六进制形式输入/输出
                    16          02 表示不足两位，前面补0输出；出过两位不影响
                    17          printf("%02X", 0x123); //打印出：123
                    18          printf("%02X", 0x1); //打印出：01
                    19          */
                [ret appendFormat:@"%02X",md[i]];
            }
         //返回一个长度为32的字符串
        return ret;
    }
+ (NSString*)md532BitLower:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
@end
