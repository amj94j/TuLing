//
//  BillingDetailCell.h
//  TuLingApp
//
//  Created by hua on 17/4/18.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "baseCell.h"
#import "BillModel.h"
typedef void(^myBtnClick)();
@interface BillingDetailCell : baseCell



@property (nonatomic, copy) myBtnClick BtnClick1;
/**
 账单编号
 */
@property(nonatomic,strong)UILabel *BillingNumber;

/**
 账单周期
 */
@property(nonatomic,strong)UILabel *BillingTime;

/**
 账单生成时间
 */
@property(nonatomic,strong)UILabel *BillingSetTime;


/**
 账单确认时间
 */
@property(nonatomic,strong)UILabel *BillingYesTime;


/**
 账单金额
 */
@property(nonatomic,strong)UILabel *BillingMoney;


/**
 账单值
 */
@property(nonatomic,strong)UILabel *BillingMoneyValue;



/**
 查看结算凭证
 */
@property(nonatomic,strong)UIView *buttonView;

/**
 账单结算时间
 */
@property(nonatomic,strong)UILabel *Billing;


@property(nonatomic,strong)BillModel *myModel;

@property(nonatomic,strong)UIImageView *iconImg;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//-(void)addValue:(NSMutableDictionary *)dic type:(NSString *)str;
@end
