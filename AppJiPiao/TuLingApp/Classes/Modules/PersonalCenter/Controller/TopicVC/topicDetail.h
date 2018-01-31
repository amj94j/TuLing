//
//  topicDetail.h
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"
#import "searchModel.h"
@interface topicDetail : BaseVC
@property(nonatomic,strong)NSString *ID;

@property(nonatomic,strong)NSString *productID;

@property(nonatomic,assign)BOOL isModel;

@property(nonatomic,assign)NSString  *backInt;

@property(nonatomic,strong)searchModel *myModel;
@end
