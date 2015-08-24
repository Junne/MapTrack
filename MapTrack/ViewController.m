//
//  ViewController.m
//  MapTrack
//
//  Created by Junne on 8/20/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import "ViewController.h"
#import "MTCLLocationManager.h"
#import "Realm/Realm.h"
#import "Location.h"
#import <MapKit/MapKit.h>


@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *MapTrackView;
@property (nonatomic, strong) RLMNotificationToken *rlmNotificationToken;
@property (nonatomic, strong) RLMResults *locations;

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
    [self updateMapTrack];
}

- (void)updateMapTrack {
    
    __weak ViewController *weakSelf = self;
    self.rlmNotificationToken = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        
        weakSelf.locations = [[Location allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
        
        CLLocationCoordinate2D coord[self.locations.count];
        
        for (int i = 0; i < self.locations.count; i ++) {
            
            Location *newLocation = self.locations[i];
            coord[i].latitude = newLocation.latitude;
            coord[i].longitude = newLocation.longtitude;
        }
        
        if (weakSelf.locations.count > 1) {
            
            
            [weakSelf.MapTrackView addOverlay:[MKPolyline polylineWithCoordinates:coord count:self.locations.count]];
        }

        
    } ];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
