//
//  QGeocoder.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QGeocoder : CLGeocoder
@property (nonatomic, readonly, getter = isGeocoding) BOOL geocoding;

// Optional parameters
@property (strong, nonatomic) NSDictionary *components;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *region;

// reverse geocode requests
- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler;

// forward geocoder requests
- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler;

- (void)cancelGeocode;

+ (void)setGoogleClientID:(NSString *)clientID;
+ (void)setGooglePrivateKey:(NSString *)privateKey;

@end