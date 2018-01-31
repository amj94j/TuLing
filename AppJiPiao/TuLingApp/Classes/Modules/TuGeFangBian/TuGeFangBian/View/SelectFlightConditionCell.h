//
//  SelectFlightConditionCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFlightConditionCell : UITableViewCell
@property (strong, nonatomic) UILabel *topTextLabel;
@property (strong, nonatomic) UIImageView *tailImage;
@property (nonatomic) BOOL isSelect;

- (void)hiddenIconImageWith:(NSString *)airlineCode hidden:(BOOL)hidden;
@end
