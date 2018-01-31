//
//  AlipayRequestConfig.m
//  AliSDKDemo
//
//  Created by hua on 17/1/4.
//  Copyright © 2017年 Alipay.com. All rights reserved.
//

#import "AlipayRequestConfig.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation AlipayRequestConfig
+ (void)alipayWithproductName:(NSString *)productName productDescription:(NSString *)productDescription tradeNO:(NSString *)tradeNO  itBPay:(NSString *)itBPay  amount:(NSString *)amount
{
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"123";
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = @"123";;
    
    order.notify_url = @"123";
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = productDescription;
    order.biz_content.subject = productName;
    order.biz_content.out_trade_no = tradeNO; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = itBPay; //超时时间设置
    order.biz_content.total_amount = amount; //商品价格
    
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
  
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
     
   
// 调用支付接口
    [self payWithAppScheme:@"123" orderSpec:orderInfo orderInfoEncoded:orderInfoEncoded signedString:signedString];
    
}

/**
 服务器端签名支付调用方法

 @param appScheme        回调Scheme
 @param signedString     签名
 @param orderInfoEncoded 订单字符串
 */
+(void)payServerWithAppScheme:(NSString *)appScheme  signedString:(NSString *)signedString orderInfoEncoded:(NSString *)orderInfoEncoded payBlock:(ReturnpayResultBlock) block
{
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        orderString = [NSString stringWithFormat:@"%@&sign=%@",
                       orderInfoEncoded, signedString];;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
           
            NSString *resultStatus=resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                
                NSString *allString=resultDic[@"result"];
                
                // NSMutableDictionary *Mydic =[resultDic[@"result"] objectForKey:@"alipay_trade_app_pay_response"];
               
                // [self request:Mydic];
                
                
                
                
                NSDictionary *dic = [self dictionaryWithJsonString:allString];
                
                NSMutableDictionary *Mydic = [[NSMutableDictionary alloc]init];
                Mydic =dic[@"alipay_trade_app_pay_response"];
                
               // block(@"0");
                //NSLog(@"%@",Mydic);
                
                [MBProgressHUD showSuccess:@"支付成功"];
                NSDictionary *resDic = @{@"result":@"0"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
//                [self request:Mydic];
                
                
            }
            else
            {
                block(@"1");
                NSDictionary *resDic = @{@"result":@"1"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //NSLog(@"支付失败");
            }
            
        }];
    }


}


// 支付
+ (void)payWithAppScheme:(NSString *)appScheme orderSpec:(NSString *)orderSpec orderInfoEncoded:(NSString *)orderInfoEncoded signedString:(NSString *)signedString {
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *resultStatus=resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                
                
               // NSLog(@"支付成功");
                
            }
            else
            {
               // NSLog(@"支付失败");
            }
            
        }];
    }
    
}

+(void)request:(NSMutableDictionary *)dic
{
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid!=nil) {
        params = @{@"out_trade_no":dic[@"out_trade_no"],@"uuid":account.uuid,@"total_amount":dic[@"total_amount" ],@"seller_id":dic[@"seller_id"],@"app_id":dic[@"app_id"],};
        
    }
    [NetAccess postJSONWithUrl:kalipayResult parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        
        //NSMutableArray *Arr3 ;
        int code = [[[responseObject objectForKey:@"header"]objectForKey:@"code"] intValue];
        //  BOOL res =[[responseObject objectForKey:@"date"] boolValue] ;
        if (code==0) {
            
            // [MBProgressHUD showSuccess:@"支付成功"];
            //创建通知
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:dic];
             [MBProgressHUD showSuccess:@"支付成功"];
            NSDictionary *resDic = @{@"result":@"0"};
            NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }
    } fail:^{
        [MBProgressHUD showError:@"网络错误"];
        
    }];}
/**
 
 *  支付宝返回字段解析
 
 
 
 *  @return 返回字典
 
 */

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
//        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

@end
