//
//  Location.h
//  MapTrack
//
//  Created by Junne on 8/21/15.
//  Copyright (c) 2015 Junne. All rights reserved.
//

#import <Realm/Realm.h>

@class Run;

@interface Location : RLMObject

@property NSNumber *latitude;
@property NSNumber *longtitude;
@property NSDate   *timestamp;
//@property Run      *run;

@end
RLM_ARRAY_TYPE(Location) // define RLMArray<Location>

@interface Run : RLMObject

@property NSNumber *distance;
@property NSNumber *duration;
@property NSDate   *timestamp;
@property NSOrderedSet *locations;

@end
RLM_ARRAY_TYPE(Run)

