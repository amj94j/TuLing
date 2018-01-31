#import "gerenzhongxinTableViewCell.h"

@implementation gerenzhongxinTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
//    if (isIPHONE6P) {
//        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 14, 30, 30)];
//        _tltleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(_iconImageView.frame)+50, 20, WIDTH, 15)];
//    }else{
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 30, 30)];
        _tltleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.size.width+_iconImageView.frame.origin.x+15, _iconImageView.frame.origin.y+5, WIDTH, 20)];
//    }
    _tltleLabel.textAlignment = NSTextAlignmentLeft;
    _tltleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_tltleLabel];
}
- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
