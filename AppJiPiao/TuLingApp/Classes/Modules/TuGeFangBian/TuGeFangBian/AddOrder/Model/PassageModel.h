//
//  PassageModel.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    PassageStyleAdd,
    PassageStyleGetList,
    PassageStyleChange,
    PassageStyleDele
    
}PassageStyle;

@interface PassageModel : NSObject

/** 是否成年 **/
@property (nonatomic,assign)BOOL  isAudlt;

/** 是否儿童 **/
@property (nonatomic,assign)BOOL isChild;

/** 是否婴儿 **/
@property (nonatomic,assign)BOOL isBaby;

//+ (void)getPassageWithParam:(NSMutableDictionary *)param passageStyle:(PassageStyle)passageStyle success:(void(^)(id respond))success failure:(void(^)(id error))failed;

@end
