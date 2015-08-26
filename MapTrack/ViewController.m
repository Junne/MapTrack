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

@interface ViewController () <MKMapViewDelegate, AwesomeMenuDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *MapTrackView;
@property (nonatomic, strong) RLMNotificationToken *rlmNotificationToken;
@property (nonatomic, strong) RLMResults *locations;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.MapTrackView.showsUserLocation = YES;
    self.MapTrackView.userTrackingMode = MKUserTrackingModeFollow;
    [self addChooseButton];
}

- (void)addChooseButton {
    
    UIImage *storyMenuItemImage        = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    UIImage *starImage                 = [UIImage imageNamed:@"icon-star.png"];
    
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
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];

    menu.delegate       = self;
    menu.menuWholeAngle = M_PI_2;
    menu.farRadius      = 110.0f;
    menu.endRadius      = 100.0f;
    menu.nearRadius     = 90.0f;
    menu.startPoint     = CGPointMake(50.0, self.view.bounds.size.height - 50);
    
    [self.view addSubview:menu];
    
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
        {
            [self performSegueWithIdentifier:@"MapTrack" sender:nil];
        }
            break;
            
        case 2:
        {
            [self showDeleteAlert];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"hello world");
            NSLog(@"%@",[RLMRealm defaultRealm].path);
            RLMRealm *realm = [RLMRealm defaultRealm];
            RLMResults *locations = [[Location allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
            [realm transactionWithBlock:^{
                [realm deleteObjects:locations];
            }];
            
        }
            break;
            
        case 1:
        {
            NSLog(@"world hello");
        }
            break;
            
        default:
            break;
    }
    
}

- (void)deleteLocations {
    
    
}


- (void)showDeleteAlert {
    
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要清除坐标数据?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [deleteAlertView show];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
