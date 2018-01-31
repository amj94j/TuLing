//
//  TLUploadSystemInfo.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLUploadSystemInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>          //获取网络运营商
#import <sys/utsname.h>                      //获取手机型号
#import "AFNetworkReachabilityManager.h"     //获取网络状态
#import "TLAccount.h"
#import "Reachability.h"

@implementation TLUploadSystemInfo

+(instancetype)shareIntens
{
    static TLUploadSystemInfo *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[TLUploadSystemInfo alloc]init];
    });
    return share;
}
-(void)uploadSystemBaseDatatoServer
{
 
    [self requestuploadData];
    
}
-(void)requestuploadData
{

    UIDevice *device = [UIDevice currentDevice];
    NSString *identifier = [[device identifierForVendor] UUIDString];
    NSString *name = device.name;       //获取设备所有者的名称
    NSString *systemName = device.systemName;   //获取当前运行的系统
    NSString *systemVersion = device.systemVersion;
//    NSString *currentName = [self getcarrierName];
    NSString *modelPhone = [self iphoneType];
    
//    NSString *NetWorkingtype = [self networktype];
    NSString *NetWorkingtype;
    Reachability  *reach =[Reachability reachabilityForInternetConnection];
    NSInteger type = [reach currentReachabilityStatus];
    if(type != 0)
    {
        if(type == 1)
        {
            NetWorkingtype = [NSString stringWithFormat:@"%@",@(2)];
        }else
        {
            NetWorkingtype = [NSString stringWithFormat:@"%@",@(1)];
        }
    }
    NSMutableDictionary *params = [@{@"systemName":systemName,@"systemVersion":systemVersion,@"deviceName":name,@"deviceUuid":identifier,@"phoneModel":modelPhone}mutableCopy];
    
    if(NetWorkingtype)
    {
        [params addEntriesFromDictionary:@{@"networkType":NetWorkingtype}];
    }
    TLAccount * account = [TLAccountSave account];
    if(account.uuid!=nil)
    {
        [params addEntriesFromDictionary:@{@"uuid":account.uuid}];
    }
    [NetAccess getJSONDataWithUrl:KuploadSystemInfo parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSInteger type = [responseObject[@"header"][@"code"]integerValue];
        if(type == 0)
        {
            NSLog(@"%@",responseObject[@"header"][@"message"]);
        }else
        {
             NSLog(@"%@",responseObject[@"header"][@"message"]);
        }
    } fail:^{
        
    }];
}
-(NSString *)getcarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    return currentCountry;
}
- (NSString *)iphoneType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    return platform;
}


-(NSString *)networktype{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *type;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 1:
        case 2:
        case 3:
        case 4:
            type = @"1";
            break;
        case 5:
            NSLog(@"Wifi");
            type = @"2";
            break;
        default:
            break;
            
    }
    return type;
}

@end
