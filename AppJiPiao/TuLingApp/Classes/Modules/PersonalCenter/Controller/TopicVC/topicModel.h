//
//  topicModel.h
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface topicModel : JSONModel

@property (nonatomic,copy) NSString * goodsComment;

/**
 感受
 */
@property(nonatomic,copy)NSString *goodsFell;

/**
 印象
 */
@property(nonatomic,copy)NSString *goodsImpression;


/**
 判断是否显示驳回原因cell字段 ，2为显示，其他不显示
 */
@property(nonatomic,copy)NSString *auditStatus;



/**
 驳回原因
 */
@property(nonatomic,copy)NSString *auditCause;

/**
 商品id
 */
@property(nonatomic,copy)NSString *productsId;

/**
 商品名称
 */
@property(nonatomic,copy)NSString *goodsName;


/**
 商品图片
 */
@property(nonatomic,copy)NSString *shoppingImage;



/**
 商品上传的网络图片
 */
@property(nonatomic,copy)NSArray *images;

@end
