
#import <Foundation/Foundation.h>


#define kTLLoginedNotification @"TLLoginedNotification"

@interface TLAccount : NSObject
/**
 *  用户uuid
 */
@property (nonatomic ,strong) NSString* uuid;


+ (instancetype) accountWithUUID : (NSString*) uuid ;

@end
