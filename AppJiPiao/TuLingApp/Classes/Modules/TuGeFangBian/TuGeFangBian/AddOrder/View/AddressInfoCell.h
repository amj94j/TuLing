//
//  AddressInfoCell.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketAddressModel;

@interface AddressInfoCell : UITableViewCell

@property (nonatomic, strong) TicketAddressModel *model;
@property (nonatomic, copy) void (^userAction)(BOOL isDelete);

@end
