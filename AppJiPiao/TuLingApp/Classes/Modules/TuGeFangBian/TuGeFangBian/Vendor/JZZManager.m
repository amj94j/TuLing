//
//  JZZManager.m
//  JZZLocationSample
//
//  Created by Jzzhou on 16/5/15.
//  Copyright © 2016年 Jzzhou. All rights reserved.
//

#import "JZZManager.h"
#import <TSMessages/TSMessage.h>

@interface JZZManager ()
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSString *currentCity;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@end

@implementation JZZManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [self findCurrentLocation];
    }
    return self;
}

- (void)findCurrentLocation {
    self.isFirstUpdate = YES;
    // 1
    if (![CLLocationManager locationServicesEnabled]) {
        [TSMessage showNotificationWithTitle:@"未开启定位服务"
                                    subtitle:@"请开启定位服务定位您所在城市."
                                        type:TSMessageNotificationTypeError];
    }
    // 2
    else if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    // 3
    else {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.isFirstUpdate) {
        // 4
        self.isFirstUpdate = NO;
        return;
    }
    
    // 5
    CLLocation *newLocation = [locations lastObject];
    
    self.currentLocation = newLocation;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                
                // 获取城市
                NSString *city = placemark.locality;
                if (! city) {
                    // 6
                    city = placemark.administrativeArea;
                }
                
                self.currentCity = city;
            } else if ([placemarks count] == 0) {
                [TSMessage showNotificationWithTitle:@"GPS故障"
                                            subtitle:@"定位城市失败"
                                                type:TSMessageNotificationTypeError];
                
            }  
        } else {
//            [TSMessage showNotificationWithTitle:@"网络错误"
//                                        subtitle:@"请检查您的网络"
//                                            type:TSMessageNotificationTypeError];
        }
    }];
    [self.locationManager stopUpdatingLocation];
}
@end


