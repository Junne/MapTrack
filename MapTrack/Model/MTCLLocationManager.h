//
//  MTCLLocationManager.h
//  MapTrack
//
//  Created by Junne on 8/21/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface MTCLLocationManager : CLLocationManager <CLLocationManagerDelegate>

+ (instancetype)shareManager;

@end
