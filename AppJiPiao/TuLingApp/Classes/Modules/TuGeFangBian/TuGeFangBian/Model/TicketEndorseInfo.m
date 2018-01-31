//
//  TicketEndorseInfo.m
//  TuLingApp
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketEndorseInfo.h"

@implementation TicketEndorseInfo
+ (TicketEndorseInfo *)getTicketEndorseInfo:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketEndorseInfo *model = [[TicketEndorseInfo alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.selectPersons = [dataDic objectOrNilForKey:@"selectPersons"];
    model.selectedReasonResult = [dataDic objectOrNilForKey:@"selectedReasonResult"];
    model.order = [dataDic objectOrNilForKey:@"order"];
    model.beginTime = [model.order objectOrNilForKey:@"btime"];
    model.reasonResult = [dataDic objectOrNilForKey:@"reasonResult"];
    EndorseBackRulesModel *oldRuleResult = [dataDic objectOrNilForKey:@"ruleResult"];
    model.ruleResult = oldRuleResult;
    
    return model;
}

- (NSArray *)selectPersons {
    if (!_selectPersons) {
        _selectPersons = [NSArray new];
    }
    return _selectPersons;
}

- (NSDictionary *)selectedReasonResult {
    if (!_selectedReasonResult) {
        _selectedReasonResult = [NSDictionary new];
    }
    return _selectedReasonResult;
}

- (NSArray *)reasonResult {
    if (!_reasonResult) {
        _reasonResult = [NSArray new];
    }
    return _reasonResult;
}
// 创建改签订单 提交申请的时候
+ (void)asyncPostPlaneQueryAPPChangeTicketDetailDic:(NSDictionary *)Dic SuccessBlock:(void(^)(NSDictionary *dataDic))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[Untils convertToJsonData:Dic] forKey:@"params"];
        NSString *cityListURL = [kDomainName stringByAppendingString:kPlaneQueryAPPChangeTicketDetail];
        [NetAccess postJSONWithUrl:cityListURL parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"-----kPlaneQueryAPPChangeTicketDetail----%@",responseObject);
            if ([[responseObject[@"content"] firstObject] isKindOfClass:[NSDictionary class]]) {
                if (successBlock) successBlock([responseObject[@"content"] firstObject]);
            }
        } fail:^{
        }];
    }
}
@end
