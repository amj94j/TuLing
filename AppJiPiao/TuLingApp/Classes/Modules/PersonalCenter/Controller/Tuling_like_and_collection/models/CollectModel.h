//
//  CollectModel.h
//  TuLingApp
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

@property(nonatomic,copy)NSString *scenic_spot_id;
@property(nonatomic,copy)NSString *spot_address;
@property(nonatomic,copy)NSString *spot_image;
@property(nonatomic,copy)NSString *spot_title;
@property(nonatomic,copy)NSString *spot_name;
@property(nonatomic,strong)NSNumber *consumption;

- initWithDictionary:(NSDictionary *)dict;
@end
