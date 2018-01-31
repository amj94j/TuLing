//
//  AlipayRequestConfig.h
//  AliSDKDemo
//
//  Created by hua on 17/1/4.
//  Copyright © 2017年 Alipay.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayHeader.h"
typedef void (^ReturnpayResultBlock)(NSString *resultCode);

@interface AlipayRequestConfig : NSObject
//{
//    ReturnpayResultBlock payResultBlock;
//}
@property(strong,nonatomic)ReturnpayResultBlock payResultBlock;//申明block
/**
  配置请求信息，仅有变化且必要的参数

 @param productName        产品名字
 @param productDescription 产品描述
 @param tradeNO            订单号
 @param itBPay             超时时间
 @param amount             价格@“30m”
 */
+ (void)alipayWithproductName:(NSString *)productName productDescription:(NSString *)productDescription tradeNO:(NSString *)tradeNO  itBPay:(NSString *)itBPay  amount:(NSString *)amount;



/**
 服务器端签名支付调用方法
 
 @param appScheme        回调Scheme
 @param signedString     签名
 @param orderInfoEncoded 订单字符串
 */
+(void)payServerWithAppScheme:(NSString *)appScheme  signedString:(NSString *)signedString orderInfoEncoded:(NSString *)orderInfoEncoded payBlock:(ReturnpayResultBlock) block;

+(void)request:(NSMutableDictionary *)dic;

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
