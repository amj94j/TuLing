//
//  EndorseModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseModel.h"

@implementation EndorseModel

- (NSDictionary *)oldEndorseDic {
    if (!_oldEndorseDic) {
        _oldEndorseDic = [NSDictionary new];
    }
    return _oldEndorseDic;
}

- (NSArray *)detailList {
    if (!_detailList) {
        _detailList = [NSArray new];
    }
    return _detailList;
}

- (NSArray *)personId {
    if (!_personId) {
        _personId = [NSArray new];
    }
    return _personId;
}
+(EndorseModel *)getEndorseModel:(NSDictionary*)netDic {
    EndorseModel *model = [[EndorseModel alloc] init];
    model.oldEndorseDic = netDic;
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    NSDictionary *allDic = netDic[@"param"];
    model.backState = [allDic objectOrNilForKey:@"backState"];
    model.orderType = [allDic objectOrNilForKey:@"orderType"];
    if ([model.orderType isEqualToString:@"2"]) {
        model.returnBeginTime = [allDic objectOrNilForKey:@"returnBeginTime"];
        model.goBeginTime = [allDic objectOrNilForKey:@"goBeginTime"];
    }
    
    NSMutableArray *personArr = [NSMutableArray new];
    if (([model.orderType isEqualToString:@"2"] && [model.backState isEqualToString:@"0"]) || [model.backState isEqualToString:@"3"] || [model.orderType isEqualToString:@"1"]) {
        // 去
        [personArr addObjectsFromArray:[allDic objectOrNilForKey:@"personId"]];
    } else if ([model.orderType isEqualToString:@"2"] && [model.backState isEqualToString:@"1"]) {
        // 返
        [personArr addObjectsFromArray:[allDic objectOrNilForKey:@"personIdReturn"]];
    } else if ([model.orderType isEqualToString:@"2"] && [model.backState isEqualToString:@"2"]) {
        // 往返
        [personArr addObjectsFromArray:[allDic objectOrNilForKey:@"personId"]];
        [personArr addObjectsFromArray:[allDic objectOrNilForKey:@"personIdReturn"]];
    }

    if ([personArr isKindOfClass:[NSArray class]]) {
        model.personId = [personArr copy];
        if ([allDic[@"detailListArr"] isKindOfClass:[NSArray class]]) {
            NSArray *detailListOldArr = allDic[@"detailListArr"];
            NSMutableArray *arr = [NSMutableArray new];
            for (NSDictionary *personDic in model.personId) {
                NSNumber *perID = personDic[@"flightPersonId"];
                NSString *perStr = [NSString stringWithFormat:@"%@",perID];
                for (NSDictionary *detailDic in detailListOldArr) {
                    NSString *detailStr = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"flightPersonId"]];
                    if (perStr == detailStr || [perStr isEqualToString:detailStr]) {
                        [arr addObject:detailDic];
                    }
                }
            }
            model.detailList = [arr copy];
        }
    }
    return model;
}

// 获取改签申请理由能否改签
+ (void)asyncPostTicketCheckChangeTicketWithOrderDic:(NSDictionary *)orderDic SuccessBlock:(void(^)(NSDictionary *data))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *url = [kDomainName stringByAppendingString:kPlaneCheckChangeTicket];
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:orderDic];
        [mDic setObject:kToken forKey:@"token"];
//        NSString *str = [Untils convertToJsonData:orderDic];
        NSLog(@"---------kPlaneCheckChangeTicket---dic---------\n%@",mDic);
        [NetAccess postJSONWithUrl:url parameters:mDic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneCheckChangeTicket------%@",responseObject);
            NSDictionary *contentDic = [NSDictionary new];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                contentDic = [[responseObject objectForKey:@"content"] firstObject];
            }
            if (successBlock) successBlock(contentDic);
        } fail:^{
        }];
    }
}

@end
