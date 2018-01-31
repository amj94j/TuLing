
#import "BSRelayoutButton.h"

@interface BSRelayoutButton ()

@property (nonatomic, assign) CGSize  imageSize;

@end

@implementation BSRelayoutButton

- (void)setType:(BSRelayoutButtonAlignment)type
{
    _type = type;
    if (_type == BSRelayoutButtonAlignmentImageTop) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    _imageSize = image.size;
    [super setImage:image forState:state];
}

// 重写父类方法,改变标题和image的坐标
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    if (_type == BSRelayoutButtonAlignmentImageRight)
    {
        CGFloat x = contentRect.size.width - self.offset - self.imageSize.width ;
        CGFloat y = contentRect.size.height -  self.imageSize.height;
        y = y / 2;
        
        
        CGRect rect = CGRectMake(x,y,self.imageSize.width,self.imageSize.height);
        return rect;
    }
    else if (_type == BSRelayoutButtonAlignmentImageTop)
    {
        CGFloat x = contentRect.size.width - self.imageSize.width;
        
        x = x / 2;
        
        CGRect rect = CGRectMake(x, 0, self.imageSize.width, self.imageSize.height);
        
        return rect;
    }
    else
    {
        return [super imageRectForContentRect:contentRect];
    }
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    if (_type == BSRelayoutButtonAlignmentImageRight) {
        
        return CGRectMake(0, 0, contentRect.size.width - self.offset - self.imageSize.width , contentRect.size.height);
        
        
    } else if (_type == BSRelayoutButtonAlignmentImageTop) {
        
        return CGRectMake(0, self.offset + self.imageSize.height , contentRect.size.width , contentRect.size.height - self.offset - self.imageSize.height );
        
    } else {
        return [super titleRectForContentRect:contentRect];
    }
}

@end
