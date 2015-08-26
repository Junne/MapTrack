//
//  MapTrackViewController.m
//  MapTrack
//
//  Created by baijf on 8/26/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import "MapTrackViewController.h"
#import <Realm/Realm.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface MapTrackViewController () <MKMapViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapTrackView;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation MapTrackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];    
    [self addMapTrack];
    [self.mapTrackView setRegion:[self mapRegion]];
}


- (IBAction)showInfoAction:(id)sender {
    
    RLMResults *locations = [[Location allObjects] sortedResultsUsingProperty:@"timestamp" ascending:YES];
    int  timeLong         = [((Location *)locations.lastObject).timestamp timeIntervalSinceDate: ((Location *)locations.firstObject).timestamp];
    NSString *time        = [NSString stringWithFormat:@"%d Hour %d min", timeLong/3600, timeLong / 60];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"时间: %@ 坐标数: %lu", time, (unsigned long)locations.count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addMapTrack {
    
    RLMResults *locations = [[Location allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    CLLocationCoordinate2D coord[locations.count];
    
    for (int i = 0; i < locations.count; i ++) {
        
        Location *newLocation = locations[i];
        coord[i].latitude = newLocation.latitude;
        coord[i].longitude = newLocation.longtitude;
    }
    
    if (locations.count > 1) {
        [self.mapTrackView addOverlay:[MKPolyline polylineWithCoordinates:coord count:locations.count]];
    }
}


- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    RLMResults *locations = [[Location allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    Location *initialLoc = locations.firstObject;
    
    float minLat = initialLoc.latitude;
    float minLng = initialLoc.longtitude;
    float maxLat = initialLoc.latitude;
    float maxLng = initialLoc.longtitude;
    
    for (Location *location in locations) {
        if (location.latitude < minLat) {
            minLat = location.latitude;
        }
        if (location.longtitude < minLng) {
            minLng = location.longtitude;
        }
        if (location.latitude > maxLat) {
            maxLat = location.latitude;
        }
        if (location.longtitude > maxLng) {
            maxLng = location.longtitude;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f;
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f;
    
    return region;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor greenColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
