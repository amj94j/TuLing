#define system_font [UIFont systemFontOfSize:14]
/**
 * label宽度追加宽度
 */
#define add_label_width 10
/**
 * 电话label追加宽度
 */
#define add_phone_label_width 20
/**
 * 计算的字段长度追加比例
 */
#define bi_li_string 1.2
#import "Tuling_user_setting_frame_model.h"

@implementation Tuling_user_setting_frame_model

- (void)setModel:(Tuling_user_setting_model *)model
{

    _model = model;
// 设置右侧label的宽度
   
    CGSize user_name_size = [model.user_name sizeWithFont:system_font];
    CGFloat user_name_x = WIDTH - (user_name_size.width)* bi_li_string - arrow_width - add_label_width;
    CGFloat height = CELL_HEIGHT-1;
    
    CGFloat do_not_overflow_width = (user_name_size.width) * bi_li_string + add_label_width;
    CGFloat overflow_width = WIDTH*0.541;
    
    _user_name_frame = CGRectMake(user_name_x > WIDTH/3 ? user_name_x: WIDTH/3, 0, user_name_x > WIDTH/3 ? do_not_overflow_width  : overflow_width, height);
    
    
    
    
    CGSize sex_size = [model.sex sizeWithFont:system_font];
    
    CGFloat sex_x = WIDTH - (sex_size.width)*bi_li_string - arrow_width - add_label_width;
    CGFloat sex_width = sex_size.width + add_label_width;
     _sex_frame = CGRectMake(sex_x, 0, sex_width, height);
    
    

    CGSize phone_size = [model.phone sizeWithFont:system_font];
    
    CGFloat phone_x = WIDTH - phone_size.width - arrow_width - add_phone_label_width;
    CGFloat phone_width = phone_size.width + add_phone_label_width;
     _phone_frame = CGRectMake(phone_x, 0, phone_width, height);

    
}
@end
