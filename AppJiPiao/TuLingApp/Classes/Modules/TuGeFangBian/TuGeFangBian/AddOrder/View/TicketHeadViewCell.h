//
//  TicketHeadViewCell.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TicketHeadModel.h"

@protocol TicketHeadViewCellDelegate <NSObject>

@optional

- (void)delegteItemAtIndex:(NSIndexPath *)index;

@end

@interface TicketHeadViewCell : UITableViewCell

+ (TicketHeadViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)TicketHeadModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *selectIconView;

@property (nonatomic, weak)id<TicketHeadViewCellDelegate> headCellDelegate;

@property (nonatomic, strong)NSIndexPath * index;


@end
