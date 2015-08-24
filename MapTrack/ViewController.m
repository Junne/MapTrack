//
//  ViewController.m
//  MapTrack
//
//  Created by Junne on 8/20/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import "ViewController.h"
#import "MTCLLocationManager.h"
#import <Realm/Realm.h>
#import "AwesomeMenu.h"
#import "Location.h"
#import <MapKit/MapKit.h>
#import <Masonry/Masonry.h>



@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate, AwesomeMenuDelegate>

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
    
    [self addChooseButton];
}

- (void)addChooseButton {
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    
//    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
//                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
//                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
//                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];

    menu.delegate = self;
    menu.menuWholeAngle = M_PI_2;
    menu.farRadius = 110.0f;
    menu.endRadius = 100.0f;
    menu.nearRadius = 90.0f;
//    menu.animationDuration = 0.3f;
    
    menu.startPoint = CGPointMake(50.0, 410.0);
    [self.view addSubview:menu];
    
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
