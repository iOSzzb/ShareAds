//
//  SALocationManager.m
//  ShareAds
//
//  Created by 张振波 on 2017/7/12.
//  Copyright © 2017年 张振波. All rights reserved.
//

#import "SALocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "Province.h"
#import "City.h"
#import "District.h"
@interface SALocationManager()<CLLocationManagerDelegate>
@end
@implementation SALocationManager
{
    CLLocationManager *_locationManager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [CLLocationManager authorizationStatus];
    }
    return self;
}

- (void)getCurrentLoaction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ) {
            [_locationManager startUpdatingLocation];
        }
        else {
            [_locationManager requestWhenInUseAuthorization];
        }
    });
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status== kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse ) {
        [manager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"latitude = %f longtude = %f",coordinate.latitude,coordinate.longitude);
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull mark, NSUInteger idx, BOOL * _Nonnull stop) {
           NSLog(@"mark.name = %@\n  mark.thoroughfare=%@\n  mark.subThoroughfare=%@\n  mark.locality=%@\n  mark.subLocality=%@\n  mark.administrativeArea=%@\n  mark.subAdministrativeArea=%@\n  mark.postalCode=%@\n mark.ISOcountryCode=%@\n mark.country=%@\n mark.inlandWater=%@\n mark.ocean=%@\n",mark.name,mark.thoroughfare,mark.subThoroughfare,mark.locality,mark.subLocality,mark.administrativeArea,mark.subAdministrativeArea,mark.postalCode,mark.ISOcountryCode,mark.country,mark.inlandWater,mark.ocean);
//           mark.locality=深圳市
//           mark.subLocality=龙岗区
//           mark.administrativeArea=广东省
           NSString *provId;
           NSString *cityId;
           NSString *areaId;
           Province *province = [Province objectsWhere:@"desc like %@",mark.administrativeArea].firstObject;
           provId = province.provId;
           if (provId) {
               City *city = [[City objectsWhere:@"desc like %@",mark.locality] objectsWhere:@"provId = %@",provId].firstObject;
               cityId = city.cityId;
               if (cityId) {
                   District *district = [[District objectsWhere:@"desc like %@",mark.subLocality] objectsWhere:@"cityId = %@",cityId].firstObject;
                   areaId = district.areaId;
               }

           }
           Location *location = [Location new];
           location.provId = provId;
           location.cityId = cityId;
           location.areaId = areaId;
           [NetworkInterface reportLoction:location success:^(NSDictionary *response) {
               [manager stopUpdatingLocation];
           } failure:^(NSString *message, NSInteger errorCode) {
               [manager stopUpdatingLocation];
           }];
       }];
    }];
}
@end
