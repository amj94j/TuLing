//
//  PassageSelectInsuraCell.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketPassengerModel;

@interface PassageSelectInsuraCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectIconView;

+ (instancetype)passageSelectInsureCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)TicketPassengerModel * model;

@end
