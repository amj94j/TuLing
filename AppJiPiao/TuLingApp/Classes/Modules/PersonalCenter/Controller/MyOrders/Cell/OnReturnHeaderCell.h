//
//  OnReturnHeaderCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnDetailModel.h"

#define onReturnStr1 @"如果商家同意：按商家提供的退货地址将退货寄回\n如果商家拒绝：退款关闭，您可联系平台进行协调"
#define onReturnStr3 @"如果商家同意：等待平台在三天内退款给买家\n如果商家发货：退款关闭，您可在收到货后再次提交申请"
#define onReturnStr2 @"如果商家同意：等待平台退回买家原支付渠道\n如果商家拒绝：退款关闭"
//#define onReturnStr6 @"商家拒绝退款，理由：商品已经影响二次销售\n如不同意商家观点请联系平台进行维权"


typedef void(^RepealBtnClick)(void);
typedef void(^CheckLogisBtnClick)(void);
typedef void(^PhoneNumBtnClick)(void);

@interface OnReturnHeaderCell : UITableViewCell

@property (nonatomic, strong) ReturnDetailModel *model;
@property (nonatomic, copy) RepealBtnClick repealBtnCLick;
@property (nonatomic, copy) CheckLogisBtnClick checkLogisBtnClick;
@property (nonatomic, copy) PhoneNumBtnClick phoneNumBtnClick;

@end
