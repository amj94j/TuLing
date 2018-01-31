//
//  messageModel.h
//  TuLingApp
//
//  Created by hua on 17/3/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface messageModel : JSONModel
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *operation;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *mobileUserId;
@property(nonatomic,copy)NSString *type0;
@property(nonatomic,copy)NSString *type1;
@property(nonatomic,copy)NSString *type2;
@property(nonatomic,copy)NSString *type3;
@property(nonatomic,copy)NSString *type4;
@property(nonatomic,copy)NSString *status;
@end
