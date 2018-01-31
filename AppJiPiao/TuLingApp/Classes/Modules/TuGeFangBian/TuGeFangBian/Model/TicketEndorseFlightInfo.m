//
//  TicketEndorseFlightInfo.m
//  TuLingApp
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketEndorseFlightInfo.h"

@implementation TicketEndorseFlightInfo


/*
 fromCity     出发城市       出发城市
 toCity     到达城市         到达城市
 takeoffDate     起飞日期         格式yyyy-MM-dd HH:mm:ss
 reasonId     理由ID          理由ID
 passagerName     乘机人姓名          多个姓名格式（姓名1,姓名2）
 token     token        token
 carrier     航司       航司
 cabin     原舱位        原舱位
 discount     原折扣        原折扣
 orderId     出票订单号       出票订单号（原订单号）
 */
// 改签新接口
+ (void)asyncPostNewEndorseModel:(TLTicketModel *)ticketModel dataDic:(TicketEndorseInfo *)dataDic backState:(NSString *)backState isOrderType:(NSString *)isOrderType SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:isOrderType forKey:@"isOrderType"];
        [dic setObject:dataDic.orderId forKey:@"orderId"];
        
        // 理由ID
        [dic setObject:dataDic.selectedReasonResult[@"keyID"] forKey:@"reasonId"];
        
        if (ticketModel.orderType == 2) {
            if (([backState isEqualToString:@"2"] && !ticketModel.isGo)) {
                
                [dic setObject:ticketModel.backBeginTime forKey:@"takeoffDate"];
                NSLog(@"---------kPlaneQuerySatisfyBackTicketOrder---dic---------\n%@",dic);
                NSMutableArray *passagerNames = [NSMutableArray new];
                for (NSDictionary *dic in dataDic.selectPersons) {
                    if ([[NSString stringWithFormat:@"%@",dic[@"backState"]] isEqualToString:@"1"]) {
                        [passagerNames addObject:dic[@"personName"]];
                    }
                }
                [dic setObject:[passagerNames componentsJoinedByString:@","] forKey:@"passagerName"];
                
            } else {
                
                [dic setObject:ticketModel.beginTime forKey:@"takeoffDate"];
                NSMutableArray *passagerNames = [NSMutableArray new];
                for (NSDictionary *dic in dataDic.selectPersons) {
                    if ([[NSString stringWithFormat:@"%@",dic[@"backState"]] isEqualToString:@"0"]) {
                        [passagerNames addObject:dic[@"personName"]];
                    }
                }
                [dic setObject:[passagerNames componentsJoinedByString:@","] forKey:@"passagerName"];
                
            }
                
        } else {
            // 名字
            NSMutableArray *passagerNames = [NSMutableArray new];
            for (NSDictionary *dic in dataDic.selectPersons) {
                [passagerNames addObject:dic[@"personName"]];
            }
            [dic setObject:[passagerNames componentsJoinedByString:@","] forKey:@"passagerName"];
            [dic setObject:ticketModel.beginTime forKey:@"takeoffDate"];
        }
        NSString *url = [kDomainName stringByAppendingString:kPlaneQuerySatisfyBackTicketOrder];
        NSLog(@"---------kPlaneQuerySatisfyBackTicketOrder---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"---------kPlaneQuerySatisfyBackTicketOrder------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
                NSArray *datalist = [responseObject objectForKey:@"result"];
                NSMutableArray *cityListArray = [NSMutableArray array];
                SearchFlightsModel *model = nil;
                for (NSDictionary *dic in datalist) {
                    model = [SearchFlightsModel getNewEndorseModel:dic];
                    [cityListArray addObject:model];
                }
                if (successBlock) successBlock([cityListArray copy]);
            }
            
//            if (!ticketModel.isGo) {
//                ticketModel.isGo = YES;
//            }
        } fail:^{
            if (!ticketModel.isGo) {
                ticketModel.isGo = YES;
            }
        }];
        
    }
}
@end
