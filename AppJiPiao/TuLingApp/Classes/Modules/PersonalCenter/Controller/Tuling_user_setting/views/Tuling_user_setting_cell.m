/**
 *  cell距离tableview边缘宽度
 */
#define TLCellBorder 0
/**
 *  每个label的宽度(整个cell宽度的一半)
 */
#define LABEL_WIDTH self.frame.size.width/2
/**
 *  每个label的高度(整个cell的高度)
 */
#define LABEL_HEIGHT self.frame.size.height
/**
 *  字体大小
 */
#define FONT_SIZE [UIFont systemFontOfSize:17]
/**
 *  label距离左边的距离
 */
#define LABEL_LEFT_MARGIN 15

#import "Tuling_user_setting_cell.h"

@interface Tuling_user_setting_cell ()

@property(nonatomic, strong) UILabel * left_label;
@property(nonatomic, strong) UILabel * right_label;
@property(nonatomic, strong) UIImageView * icon;

@end

@implementation Tuling_user_setting_cell

static int row = 1;

- (void)setFrame:(CGRect)frame
{
//    //左右 （还有frame的cellW也要改）
//    frame.origin.x += TLCellBorder;
//    frame.size.width -= TLCellBorder * 2;
//    //每个Cell之间的间距 （还要在frame的最终高度上修改一下）
//    frame.size.height -= TLCellBorder;
//    //令所有cell的Y值加上一个数就出现上方的区域
//    frame.origin.y += TLCellBorder;
//    //修改cell距离最下面在tableviewController里使用contentEdgeInset,调整下面的内边距
    [super setFrame:frame];
    
}
- (void)setUser_icon_url_string:(NSString *)user_icon_url_string
{
    _user_icon_url_string = user_icon_url_string;
    
    NSURL * image_url = [NSURL URLWithString:user_icon_url_string];
    UIImage * icon_image = [UIImage imageWithData:[NSData dataWithContentsOfURL:image_url]];
    self.icon.image = icon_image;
    
}

- (void)setLeft_content:(NSString *)left_content
{
    _left_content = left_content;
    self.left_label.text = left_content;

}

- (void)setRight_content:(NSString *)right_content
{
    _right_content = right_content;
    self.right_label.text = right_content;

}
- (void)setCell_frame:(CGRect)cell_frame
{
    _cell_frame = cell_frame;
    self.right_label.frame = cell_frame;

}

+ (instancetype) build_cell_with_tableview : (UITableView*) tableView and_indexpath : (NSIndexPath*) indexPath
{
    
    static NSString *ID = @"status";
    Tuling_user_setting_cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[Tuling_user_setting_cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentMode = UIViewContentModeCenter;
        [self set_up_controlls];
    }
    return self;
}
/**
 *  创建控件,设置控件位置
 */
- (void) set_up_controlls
{
    //1、左边文字label
    UILabel * left_label = [[UILabel alloc] init];
    left_label.textColor = RGBCOLOR(67, 67, 67);
    //left_label.backgroundColor = [UIColor redColor];
    left_label.font = FONT_SIZE;
    left_label.frame = CGRectMake(LABEL_LEFT_MARGIN, 29, LABEL_WIDTH, row == 1 ? ICON_CELL_HEIGHT :LABEL_HEIGHT);
    row ++;
    row = row == 5 ? 1 : row;

    [self addSubview:left_label];
    self.left_label = left_label;
    
    //2、右边显示，有图片显示图片
    UIImageView * icon = [[UIImageView alloc]init];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = USER_ICON_HEIGHT/2.0;
    //icon.backgroundColor = [UIColor redColor];
    icon.frame = CGRectMake(WIDTH - (USER_ICON_HEIGHT + 40) , USER_ICON_Y, USER_ICON_HEIGHT, USER_ICON_HEIGHT);
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:icon];
    self.icon = icon;
    
    //3、右边的文字label
    UILabel * right_label = [[UILabel alloc] init];
    right_label.textColor = RGBCOLOR(145, 145, 145); 
    //right_label.backgroundColor = [UIColor redColor];
    right_label.font = FONT_SIZE;
    [self addSubview:right_label];
    self.right_label = right_label;
    
}

@end
