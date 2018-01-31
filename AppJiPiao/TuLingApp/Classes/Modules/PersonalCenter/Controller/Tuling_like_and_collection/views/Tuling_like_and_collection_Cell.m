#import "Tuling_like_and_collection_Cell.h"

@implementation Tuling_like_and_collection_Cell

+ (instancetype) build_cell_with_tableview : (UITableView*) tableView
{
    static NSString *ID = @"status";
    Tuling_like_and_collection_Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[Tuling_like_and_collection_Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self set_up_controlls];
    }
    return self;
}

- (void) set_up_controlls
{
    UIImageView * imageViewBackground = [[UIImageView alloc]init];
    [self addSubview:imageViewBackground];
    imageViewBackground.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.imageViewBackground = imageViewBackground;
    
}




@end
