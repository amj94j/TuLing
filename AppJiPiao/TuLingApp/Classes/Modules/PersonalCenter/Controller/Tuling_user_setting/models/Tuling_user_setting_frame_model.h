/**
 *  每个cell的高度
 */
#define CELL_HEIGHT 44
#define arrow_width WIDTH*0.11
#import <Foundation/Foundation.h>
#import "Tuling_user_setting_model.h"

@interface Tuling_user_setting_frame_model : NSObject
/**
 *  用户昵称frame
 */
@property (nonatomic, assign) CGRect user_name_frame;
/**
 *  用户性别
 */
@property (nonatomic, assign) CGRect sex_frame;
/**
 *  用户手机号码
 */
@property (nonatomic, assign) CGRect phone_frame;
/**
 *  途铃model
 */
@property (nonatomic, strong) Tuling_user_setting_model * model;

@end
