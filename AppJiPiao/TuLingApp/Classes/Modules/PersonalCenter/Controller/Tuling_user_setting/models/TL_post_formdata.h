#import <Foundation/Foundation.h>

@interface TL_post_formdata : NSObject

@property (nonatomic,strong) NSData * data ;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * filename;
@property (nonatomic,strong) NSString * mimeType;

@end
