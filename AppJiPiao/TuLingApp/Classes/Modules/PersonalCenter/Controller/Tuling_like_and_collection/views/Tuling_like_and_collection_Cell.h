#define CELL_WIDTH [[UIScreen mainScreen]bounds].size.width

#define CELL_HEIGHT CELL_WIDTH*441/750

#import <UIKit/UIKit.h>

@interface Tuling_like_and_collection_Cell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageViewBackground;
+ (instancetype) build_cell_with_tableview : (UITableView*) tableView;
@end
