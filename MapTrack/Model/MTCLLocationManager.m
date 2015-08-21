//
//  MTCLLocationManager.m
//  MapTrack
//
//  Created by Junne on 8/21/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import "MTCLLocationManager.h"
#import "Location.h"

@implementation MTCLLocationManager

+ (instancetype)shareManager {
    
    static MTCLLocationManager *shareMTManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMTManager = [[self alloc] init];
    });
    
    return shareMTManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = locations.lastObject;
    NSLog(@"location = %@", location);
    
    
}

- (void)saveLocation:(CLLocation *)location {
    
    Location *locationObject  = [Location new];
    locationObject.timestamp  = location.timestamp;
    locationObject.latitude   = [NSNumber numberWithDouble:location.coordinate.latitude];
    locationObject.longtitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm addObject:locationObject];
    }];
}

@end
