//
//  privateLetterModel.h
//  TuLingApp
//
//  Created by hua on 17/5/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface privateLetterModel : JSONModel
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *sendIcon;
@property(nonatomic,copy)NSString *sendName;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,assign)BOOL isSend;
@end
