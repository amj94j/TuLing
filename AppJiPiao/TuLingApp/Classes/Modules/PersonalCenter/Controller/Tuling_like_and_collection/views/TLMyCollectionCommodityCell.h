//
//  TLMyCollectionCommodityCell.h
//  TuLingApp
//
//  Created by gyc on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLMyCollectionCommodityCell;

@protocol TLMyCollectionCommodityCellDelegate <NSObject>
/*
 *  event = 1:分享赚
 *  event = 2:立即购买
 */
-(void)myCollectionCommodityCellEvent:(int)event cell:(TLMyCollectionCommodityCell*)cell;

@end

@interface TLMyCollectionCommodityCell : UITableViewCell

@property (nonatomic,weak) id <TLMyCollectionCommodityCellDelegate> delegate;
-(void)loadData:(NSDictionary*)dic;
@end
