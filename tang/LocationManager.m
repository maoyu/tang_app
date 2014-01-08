//
//  LocationManager.m
//  Basketballer
//
//  Created by maoyu on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"

static LocationManager * sLocationManager;

@interface LocationManager() {
}
@end

@implementation LocationManager
@synthesize locationManager = _locationManager;
@synthesize reverseGeocoder = _reverseGeocoder;
@synthesize delegate = _delegate;

+ (LocationManager *)defaultManager{
    if (nil == sLocationManager) {
        sLocationManager = [[LocationManager alloc] init];
    }
    
    return sLocationManager;
}

- (id)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 10;
        
        self.reverseGeocoder = [[CLGeocoder alloc] init];
    }
    
    return self;
}

- (void)startStandardLocationServcie{
    if ([CLLocationManager locationServicesEnabled]) {
         [self.locationManager startUpdatingLocation];
    }
}

- (void)stopStandardLocationService{
    [self.locationManager stopUpdatingLocation];
}

- (void)getPlacemarks:(CLLocation *)location {
    CLLocation * changeLocation = [[CLLocation alloc] initWithLatitude:[location coordinate].latitude - 0.0011 longitude:[location coordinate].longitude + 0.006 ];

    [_reverseGeocoder reverseGeocodeLocation:changeLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSMutableDictionary * locations = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        [locations setValue:location forKey:@"location"];
        [locations setValue:placemarks forKey:@"placemarks"];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(receivedLocation:)]) {
            [_delegate performSelector:@selector(receivedLocation:) withObject:locations];
        }
        
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSDate * date = newLocation.timestamp;
    NSTimeInterval howRecent = [date timeIntervalSinceNow];
    if (abs(howRecent) < 5) {
        [self getPlacemarks:newLocation];
        [self stopStandardLocationService];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString * message = [error description];
    NSLog(@"locationManager error: %@", message);
    /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"定位" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];*/
    
    [self stopStandardLocationService];
}

@end
