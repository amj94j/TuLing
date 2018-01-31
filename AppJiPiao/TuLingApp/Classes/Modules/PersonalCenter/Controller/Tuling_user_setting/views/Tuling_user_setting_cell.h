/**
 *  用户头像的所在cell高度
 */
#define ICON_CELL_HEIGHT 80

/**
 *  用户头像的高度
 */
#define USER_ICON_HEIGHT (ICON_CELL_HEIGHT - USER_ICON_Y*2)
/**
 *  用户头像的Y
 */
#define USER_ICON_Y 12.5

#import <UIKit/UIKit.h>
#import "Tuling_user_setting_frame_model.h"

@interface Tuling_user_setting_cell : UITableViewCell
/**
 *  用户头像url的字符串
 */
@property(nonatomic, strong) NSString * user_icon_url_string;
/**
 *  单元格左侧标识
 */
@property(nonatomic, strong) NSString * left_content;
/**
 *  单元格右侧的内容(头像勿填)
 */
@property(nonatomic, strong) NSString * right_content;
/**
 *  cell_frame
 */
@property(nonatomic, assign) CGRect  cell_frame;


+(instancetype) build_cell_with_tableview : (UITableView*) tableView and_indexpath : (NSIndexPath*) indexPath;
@end
