#import "Tuling_user_setting_model.h"

@implementation Tuling_user_setting_model
+ (instancetype) user_built_with_dictionary:(NSDictionary*)params
{
    return [[self alloc]initWithParams_Dictionary:params];

}

- (instancetype)initWithParams_Dictionary:(NSDictionary*)params
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:params];
        
    }
    return self;
}

@end
