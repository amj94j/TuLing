//
//  EndorseBackRulesModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseBackRulesModel.h"

@implementation EndorseBackRulesModel
+(EndorseBackRulesModel *)getRuleModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    EndorseBackRulesModel *model = [[EndorseBackRulesModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.IsAllowedToSign = [dataDic int64ValueForKey:@"isAllowedToSign"];
    if (model.IsAllowedToSign == 0) {
        model.IsAllowedToSignInfo = @"可以签转";
    } else if (model.IsAllowedToSign == 1) {
        model.IsAllowedToSignInfo = @"不可以签转";
    } else {
        model.IsAllowedToSignInfo = @"以航空公司规定为准";
    }
    
//    model.OrderID = [dataDic int64ValueForKey:@"OrderID"];
    model.RefundTicketRuleInfo = [dataDic objectOrNilForKey:@"refundTicketRuleInfo"];
    model.ChangeTicketRuleInfo = [dataDic objectOrNilForKey:@"changeTicketRuleInfo"];
    model.Remark = [dataDic objectOrNilForKey:@"Remark"];
    return model;
}

+ (void)asyncPostPlaneTicketRuleProDic:(NSDictionary *)Dic SuccessBlock:(void(^)(EndorseBackRulesModel *model))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[Untils convertToJsonData:Dic] forKey:@"queryResultInfo"];
        
        NSString *cityListURL = [kDomainName stringByAppendingString:kPlaneTicketRulePro];
        NSLog(@"-----kPlaneTicketRulePro---dic-%@",dic);
        [NetAccess postJSONWithUrl:cityListURL parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"-----kPlaneTicketRulePro----%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = responseObject;
                EndorseBackRulesModel *model = nil;
                model = [self getRuleModel:data];
                if (successBlock) successBlock(model);
            }
        } fail:^{
        }];
    }
}
@end
