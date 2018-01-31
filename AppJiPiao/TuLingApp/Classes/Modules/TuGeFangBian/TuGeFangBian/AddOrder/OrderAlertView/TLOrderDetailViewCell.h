//
//  TLOrderDetailViewCell.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFlightsModel.h"

@interface TLOrderDetailViewCell : UITableViewCell


/**
 是否成人票等
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;


@property (weak, nonatomic) IBOutlet UILabel *goOrBackLabel;

@property (weak, nonatomic) IBOutlet UILabel *jiJianPricelabel;
@property (weak, nonatomic) IBOutlet UILabel *jiJianPersonCountLabel;

+ (TLOrderDetailViewCell *)orderDetailCellWithTableView:(UITableView *)tableView;

/** 乘机人类型、成人、儿童 **/
@property (nonatomic,copy)NSString * personType;

/** 成人个数 **/
@property (nonatomic,assign)NSInteger adultCount;

/** 儿童个数 **/
@property (nonatomic,assign)NSInteger childCount;

/** 婴儿个数 **/
@property (nonatomic,assign)NSInteger babyCount;

@property (nonatomic, strong)SearchFlightsModel * searchFlightModel;

@end
