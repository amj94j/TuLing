//
//  JZZManager.h
//  JZZLocationSample
//
//  Created by Jzzhou on 16/5/15.
//  Copyright © 2016年 Jzzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JZZManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) NSString *currentCity;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (instancetype)sharedManager;
- (void)findCurrentLocation;

@end
