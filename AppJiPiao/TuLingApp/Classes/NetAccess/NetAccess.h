

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetAccess : NSObject

/**检测网路状态**/
+ (void)netWorkStatus;

/**
 *  GET-JSON加密获取数据
 *
 *  @param url           获取数据的url地址
 *  @param isLoadingView bool 是否有加载等待框
 *  @param success       success block
 *  @param fail          fail block
 */

+ (void)getForEncryptJSONDataWithUrl:(NSString *)url parameters:(NSArray *)array WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id json))success fail:(void (^)())fail;

/**
 *  GET-JSON方式获取数据
 *
 *  @param url           获取数据的url地址
 *  @param isLoadingView bool 是否有加载等待框
 *  @param success       success block
 *  @param fail          fail block
 */
+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary *)dic WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id json))success fail:(void (^)())fail;

/**
 *  GET-JSON方式获取数据
 *  没有提示功能
 *  @param url           获取数据的url地址
 *  @param success       success block
 *  @param fail          fail block
 */
+ (void)getJSONDataWithUrl:(NSString *)url parameters:(NSDictionary *)dic success:(void (^)(id json))success fail:(void (^)())fail;


/**
 *xml方式获取数据
 *urlStr:获取数据的url地址
 *
 */
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail;

/**
 *JSON方式post提交加密数据
 *urlStr:服务器地址
 *parameters:提交的内容参数
 *
 */
+ (void)postForEncryptJSONWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *JSON方式post提交数据
 *urlStr:服务器地址
 *parameters:提交的内容参数
 *
 */
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *Session下载文件
 *urlStr :下载文件的url地址
 *
 */
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;

/*
 * 上传图片
 */
+ (void)postUploadImageWithURL:(NSString *)URLString params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *) mimeType loadingView:(BOOL)isLoadingView loadingViewStr:(NSString *)loadStr progress:(void(^)(NSProgress *))progress success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

/**
 *文件上传,自己定义文件名
 *urlStr:    需要上传的服务器url
 *fileURL:   需要上传的本地文件URL
 *fileName:  文件在服务器上以什么名字保存
 *fileTye:   文件类型
 *
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *文件上传,文件名由服务器端决定
 *urlStr:    需要上传的服务器url
 *fileURL:   需要上传的本地文件URL
 *
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *
 *
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)uploadWithURL:(NSString *)URLString
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
             success:(void (^)(id responseObject))success
                fail:(void (^)(NSError *error))fail;

#pragma mark --多图上传--
+(void)commentUploadWithURL:(NSString *)URLString
                     params:(NSDictionary *)params
                        arr:(NSMutableArray *)imageDataArray
                   mimeType:(NSString *) mimeType
                    success:(void (^)(id responseObject))success
                       fail:(void (^)(NSError *error))fail;



+ (void)uploadFileWithMediaData:(NSData *)data url:(NSString *)url params:(id)params success:(void (^)(id responseObject))success
                           fail:(void (^)(NSError *error))fail;


#pragma mark - POST上传崩溃日志
+ (void)postUploadCrashWithUrl:(NSString *)urlStr Data:(NSData *)data
                          path:(NSString *)path parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)())fail;

/*
 * 获取验证码接口专用(暂定)，用于添加 [request addValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
 **/
+ (void)getJSONHeaderWithUrl:(NSString *)urlStr parameters:(id)parameters WithLoadingView:(BOOL)isLoadingView andLoadingViewStr:(NSString *)loadStr success:(void (^)(id responseObject))success fail:(void (^)())fail;

+ (NSString*)md532BitLower:(NSString *)str;
@end
