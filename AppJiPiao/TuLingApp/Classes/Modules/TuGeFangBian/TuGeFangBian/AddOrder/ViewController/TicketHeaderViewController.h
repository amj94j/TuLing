//
//  TicketHeaderViewController.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketHeadModel.h"

typedef enum {
    HeadFlogTypeAdd,
    HeadFlogTypeAll,
    HeadFlogTypeDele = 3
}HeadFlogType;
typedef void (^TicketHeaderBlock)(TicketHeadModel *model);

@interface TicketHeaderViewController : TicketBaseVC

@property (nonatomic, strong) TicketHeadModel *selectedModel;
@property (nonatomic, copy) TicketHeaderBlock ticketHeaderBlock;
@end
