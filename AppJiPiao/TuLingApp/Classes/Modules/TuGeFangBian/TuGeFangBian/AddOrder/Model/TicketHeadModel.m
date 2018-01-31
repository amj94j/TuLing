//
//  TicketHeadModel.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketHeadModel.h"

@implementation TicketHeadModel

- (TicketHeadModel *)initTicketHeadModelWithDic:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        //如果不是0，则是公司
        NSString * isPersonStr = dict[@"isPersonal"];
        if ([isPersonStr integerValue]) {
            self.isPersonal = @"企业";
        } else {
            self.isPersonal = @"个人";
        }
        
        self.invoiceHead = [NSString stringWithFormat:@"%@",dict[@"invoiceHead"]];
        
        self.isPersonal = [NSString stringWithFormat:@"%@",dict[@"isPersonal"]];
        
        self.createTime = [NSString stringWithFormat:@"%@",dict[@"createTime"]];
        
        self.lookedUpId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        
        self.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        
        self.voucherCode = dict[@"voucherCode"];
        self.versionNum = dict[@"versionNum"];
    }
    return self;
}

+(void)ticketHeadWithParam:(NSMutableDictionary *)param WithFlog:(TicketHeadFlogType)flogType success:(void (^)(id))success faild:(void (^)(id))faild
{
    NSString * urlStr = [kDomainName stringByAppendingString:@"basics/queryInvoiceLookedUpList"];
    
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"flag"] = [NSString stringWithFormat:@"%d",flogType];
    
    param[@"token"] = kToken;
    
    [NetAccess postJSONWithUrl:urlStr parameters:param WithLoadingView:YES andLoadingViewStr:@"加载中..." success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",responseObject);
            
            success(responseObject);
            
        }
        
        
    } fail:^{
        NSLog(@"报错");
        faild(@"未知错误");
    }];
}

@end
