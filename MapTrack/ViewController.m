//
//  ViewController.m
//  MapTrack
//
//  Created by Junne on 8/20/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import "ViewController.h"
#import "MTCLLocationManager.h"
#import <MapKit/MapKit.h>


@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapTrackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.MapTrackView.showsUserLocation = YES;
    self.MapTrackView.userTrackingMode = MKUserTrackingModeFollow;
    
    if ([self respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [[MTCLLocationManager  shareManager] requestAlwaysAuthorization];
    }
    
    [[MTCLLocationManager  shareManager] startMonitoringSignificantLocationChanges];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
