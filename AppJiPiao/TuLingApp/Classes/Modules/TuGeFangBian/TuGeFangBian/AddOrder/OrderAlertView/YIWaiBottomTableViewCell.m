//
//  YIWaiBottomTableViewCell.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "YIWaiBottomTableViewCell.h"

#import "YIWaiBottomView.h"
#import "TicketInsuranceModel.h"

static NSString * yiwaiCellID = @"yiwaiCellID";

@interface YIWaiBottomTableViewCell()

#define kBaoXianViewHeight 30

@end

@implementation YIWaiBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+ (instancetype)yiwaiBottomCellWithArray:(NSMutableArray *)baoXianArray tableView:(UITableView *)tableView
{
    YIWaiBottomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:yiwaiCellID];
    
    if (!cell) {
        cell = [[YIWaiBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiwaiCellID];
    }
    
    UIView * bgView =[[UIView alloc]initWithFrame:cell.bounds];
    
    cell.height = 15 + baoXianArray.count * kBaoXianViewHeight;
    
        for (int i = 0; i< baoXianArray.count; i++) {
            
            CGFloat baoxianX = 15;
            
            CGFloat baoxianY = 15 + i * kBaoXianViewHeight;
            
            CGFloat baoxianWidth = TLScreenWidth - 30;
            
            CGFloat baoxianHeight = kBaoXianViewHeight;
            
            YIWaiBottomView * yiWaiView = [YIWaiBottomView yiwaiBottomView];
            
            yiWaiView.baoXianModel = baoXianArray[i];
            
            yiWaiView.frame = CGRectMake(baoxianX, baoxianY, baoxianWidth, baoxianHeight);
            
            [bgView addSubview:yiWaiView];
            
    }
    
    [cell addSubview:bgView];
    
    return cell;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
