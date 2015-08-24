//
//  Location.h
//  MapTrack
//
//  Created by Junne on 8/21/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import <Realm/Realm.h>
#import <MapKit/MapKit.h>

//@class Run;

@interface Location : RLMObject

@property double latitude;
@property double longtitude;
@property NSDate   *timestamp;
//@property CLLocationCoordinate2D coord;
//@property Run      *run;

@end
RLM_ARRAY_TYPE(Location) // define RLMArray<Location>

//@interface Run : RLMObject
//
//@property long *distance;
//@property long *duration;
//@property NSDate   *timestamp;
//@property NSOrderedSet *locations;
//
//@end
//RLM_ARRAY_TYPE(Run)

