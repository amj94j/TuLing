//
//  topicCell4.m
//  TuLingApp
//
//  Created by hua on 17/4/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicCell4.h"
#import "UIImage+Addition.h"
@implementation topicCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"ddgggd";
    // 1.缓存中取
    topicCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    // 2.创建
    if (cell == nil) {
        
        cell = [[topicCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelname =[LXTControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, 20) Font:15 Text:@"添加图片"];
        _labelname.textColor =[UIColor colorWithHexString:@"#434343"];
        _labelname.font =[UIFont systemFontOfSize:15];
        [self addSubview:_labelname];
        
        
        _lineLabel =[createControl createLineWithFrame:CGRectMake(15, CGRectGetMaxY(_labelname.frame)+15, WIDTH-30, 0.5) labelLineColor:nil];
        [self addSubview:_lineLabel];
       
    }
    return self;
}

-(void)addValueNetWork:(NSMutableArray *)netWorkArr local:(NSMutableArray *)localArr
{
    
    //本地图片
    static UIImageView *recordImage =nil;
    for (int i=0; i<localArr.count; i++) {
        _localPhoto  = [[UIImageView alloc]init];
        _localPhoto.userInteractionEnabled=YES;
        _localPhoto.tag = 50000+i;
        
        
        UIImage *a= [UIImage imageWithData: localArr[i]];
        CGFloat fixelW = CGImageGetWidth(a.CGImage);
        CGFloat fixelH = CGImageGetHeight(a.CGImage);
        UIImage *resizedImage;
        if (fixelW>=fixelH) {
            resizedImage = [UIImage scaleToSize:a size:CGSizeMake(fixelH, fixelH)];
        }else
        {
            resizedImage = [UIImage scaleToSize:a size:CGSizeMake(fixelW, fixelW)];
        }

        [_localPhoto setImage:resizedImage];
        UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletetap:)];
        tapg1.numberOfTapsRequired = 1;
        [_localPhoto addGestureRecognizer:tapg1];
        
        CGFloat imageWidth = 97;
        CGFloat spaceWidth = 11;
        
        
        if (i==0) {
            _localPhoto.frame = CGRectMake(15, CGRectGetMaxY(_lineLabel.frame)+15, imageWidth, imageWidth);
        }else
        {
            CGFloat yuWidth = WIDTH - 15-recordImage.frame.origin.x -recordImage.frame.size.width-spaceWidth;
            
             if (yuWidth >= 97) {
             _localPhoto.frame =CGRectMake(recordImage.frame.origin.x +recordImage.frame.size.width + spaceWidth, recordImage.frame.origin.y, imageWidth,imageWidth);
             }else
             {
             //换行
                 _localPhoto.frame = CGRectMake(15, recordImage.frame.origin.y+recordImage.frame.size.height+spaceWidth, imageWidth,imageWidth);
             
             }
         
        
        
        }
        recordImage = _localPhoto;
        [self.contentView addSubview:_localPhoto];
    }
    //网络图片
    static UIImageView *recordNetWorkImage =nil;
    for (int i=0; i<netWorkArr.count; i++) {
        _netWorkPhoto  = [[UIImageView alloc]init];
        _netWorkPhoto.userInteractionEnabled=YES;
        _netWorkPhoto.tag = 50000+i+localArr.count;
        
        [_netWorkPhoto sd_setImageWithURL:[NSURL URLWithString:netWorkArr[i]]];
        UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletetap:)];
        tapg1.numberOfTapsRequired = 1;
        [_netWorkPhoto addGestureRecognizer:tapg1];
        
        CGFloat imageWidth = 97;
        CGFloat spaceWidth = 11;
        
        
        if (i==0) {
            if (localArr.count!=0) {
                
                CGFloat yuWidth = WIDTH - 15-recordImage.frame.origin.x -recordImage.frame.size.width-spaceWidth;
                
                if (yuWidth >= 97) {
                    _netWorkPhoto.frame = CGRectMake(recordImage.frame.origin.x +recordImage.frame.size.width + spaceWidth, recordImage.frame.origin.y, imageWidth, imageWidth);
                }else
                {
                 _netWorkPhoto.frame = CGRectMake(15, recordImage.frame.origin.y+recordImage.frame.size.height+spaceWidth, imageWidth, imageWidth);
                
                }
            
                
            }else
            {
            
            _netWorkPhoto.frame = CGRectMake(15, CGRectGetMaxY(_lineLabel.frame)+15, imageWidth, imageWidth);
            
            
            }
            
        }else
        {
            
            
            CGFloat yuWidth = WIDTH - 15-recordNetWorkImage.frame.origin.x -recordNetWorkImage.frame.size.width-spaceWidth;
            
            if (yuWidth >= 97) {
                _netWorkPhoto.frame =CGRectMake(recordNetWorkImage.frame.origin.x +recordNetWorkImage.frame.size.width + spaceWidth, recordNetWorkImage.frame.origin.y, imageWidth,imageWidth);
            }else
            {
                //换行
                _netWorkPhoto.frame = CGRectMake(15, recordNetWorkImage.frame.origin.y+recordNetWorkImage.frame.size.height+spaceWidth, imageWidth,imageWidth);
                
            }
            
            
            
        }
        recordNetWorkImage = _netWorkPhoto;
        [self.contentView addSubview:_netWorkPhoto];
        
        
    }
    
    
    

    _myView = [[UIView alloc]init];
 
    _myView.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    _myView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creamtap)];
    tapg1.numberOfTapsRequired = 1;
    [_myView addGestureRecognizer:tapg1];
    
    if (localArr.count!=0) {
    
        CGFloat imageWidth = 97;
        CGFloat spaceWidth = 11;
        
        if (netWorkArr.count!=0) {
            
            CGFloat yuWidth = WIDTH - 15-recordNetWorkImage.frame.origin.x -recordNetWorkImage.frame.size.width-spaceWidth;
            
            if (yuWidth >= 97) {
                _myView.frame =CGRectMake(recordNetWorkImage.frame.origin.x +recordNetWorkImage.frame.size.width + spaceWidth, recordNetWorkImage.frame.origin.y, imageWidth,imageWidth);
            }else
            {
                //换行
                _myView.frame = CGRectMake(15, recordNetWorkImage.frame.origin.y+recordNetWorkImage.frame.size.height+spaceWidth, imageWidth,imageWidth);
                
            }

            
            
            
            
        }else
        {
            
            
            CGFloat yuWidth = WIDTH - 15-recordImage.frame.origin.x -recordImage.frame.size.width-spaceWidth;
            
            if (yuWidth>=imageWidth) {
                _myView.frame = CGRectMake(recordImage.frame.origin.x +recordImage.frame.size.width + spaceWidth, recordImage.frame.origin.y, imageWidth, imageWidth);
            }else
            {
                
                _myView.frame = CGRectMake(15, recordImage.frame.origin.y+recordImage.frame.size.height+spaceWidth, imageWidth, imageWidth);
                
                
            }

        
        
        }
        
        
        
        
    
        
    }else
    {
        
        CGFloat imageWidth = 97;
        CGFloat spaceWidth = 11;
        
        
        if (netWorkArr.count!=0) {
            
            
            
            
            CGFloat yuWidth = WIDTH - 15-recordNetWorkImage.frame.origin.x -recordNetWorkImage.frame.size.width-spaceWidth;
            
            if (yuWidth >= 97) {
                _myView.frame =CGRectMake(recordNetWorkImage.frame.origin.x +recordNetWorkImage.frame.size.width + spaceWidth, recordNetWorkImage.frame.origin.y, imageWidth,imageWidth);
            }else
            {
                //换行
                _myView.frame = CGRectMake(15, recordNetWorkImage.frame.origin.y+recordNetWorkImage.frame.size.height+spaceWidth, imageWidth,imageWidth);
                
            }
        }else
        {
         _myView.frame = CGRectMake(15, 65, imageWidth, imageWidth);
        
        }
        
       
    
    
    
    }
    
    
    
    
    
    
    
    [self.contentView addSubview:_myView];
    
    UIImageView *imagePhoto = [LXTControl createImageViewWithFrame:CGRectMake(29, 20, _myView.frame.size.width-29-25, 44) ImageName:@"tu1.png"];
   
    [_myView addSubview:imagePhoto];
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.frame = CGRectMake(0, CGRectGetMaxY(imagePhoto.frame), _myView.frame.size.width, 20);
    titleLabel1.font = [UIFont systemFontOfSize:13];
    titleLabel1.textColor = [UIColor colorWithHexString:@"919191"];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.text = @"不超过5张";
    [_myView addSubview:titleLabel1];
    
    
    
    
    
    
    
    






}



/**
 删除图片方法

 @param sender <#sender description#>
 */
-(void)deletetap:(UILongPressGestureRecognizer *)sender{
    
    [self.delegate deleteImage:sender.view.tag-50000];
}


/**
 添加图片点击
 */
-(void)creamtap
{
    
    [self.delegate addImage];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
