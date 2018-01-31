//
//  PassageSelectInsurView.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketPassengerModel;
@class TicketInsuranceModel;
@class TicketInsuranceTradeModel;
@protocol PassageSelectInsurViewDelegate <NSObject>

@optional

- (void)pasageSelectinsureClickSureWithArray:(NSMutableArray<TicketPassengerModel *> *)passageArray;

@end


@interface PassageSelectInsurView : UIView

//- (instancetype)initSlectInsurViewWithArray:(NSMutableArray <TicketPassengerModel *> *)passageArray;

- (PassageSelectInsurView *)initPassageSelectInsureWithTicketInsuranceModel:(TicketInsuranceTradeModel *)model;

@property (nonatomic, weak)id<PassageSelectInsurViewDelegate>delegate;

@end
