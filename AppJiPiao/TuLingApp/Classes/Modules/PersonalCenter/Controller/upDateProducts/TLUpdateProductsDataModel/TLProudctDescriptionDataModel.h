//
//  TLProudctDescriptionDataModel.h
//  TuLingApp
//
//  Created by gyc on 2017/5/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface TLProudctDescriptionDataModel : JSONModel
@property (nonatomic)BOOL isText;
@property (nonatomic) CGFloat totalHeight;
@property (nonatomic,copy) NSString * textString;
@property (nonatomic,strong) UIImage * image;
@end
