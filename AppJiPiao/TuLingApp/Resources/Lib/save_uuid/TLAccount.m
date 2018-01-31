

#import "TLAccount.h"

@implementation TLAccount


+ (instancetype) accountWithUUID:(NSString *)uuid
{
    return [[self alloc]initWithUUID:uuid];
    
}

- (instancetype)initWithUUID : (NSString*) uuid
{
    self = [super init];
    if (self) {
        
        
        //self.uuid = uuid;
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSSet *set1 = [NSSet setWithObjects:uuid, nil];
   
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTLLoginedNotification object:nil];
    }
    return self;
}
@end
