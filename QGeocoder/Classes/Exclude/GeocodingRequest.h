//
//  GeocodingRequest.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

extern NSString * const GeocodingRequestOutputJSON;
extern NSString * const GeocodingRequestOutputXML;

/**
 * Google Geocoding Request
 * http://code.google.com/apis/maps/documentation/geocoding/#GeocodingRequests
 *
 * You may have either an address (Geocoding) or a coordinate (Reverse Geocoding), never both.
 *
 */
@interface GeocodingRequest : NSObject
@property (copy, nonatomic, readonly) NSString *address;
@property (strong, nonatomic, readonly) NSURL *URL;
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic, readonly) CLLocationCoordinate2D southwest;
@property (assign, nonatomic, readonly) CLLocationCoordinate2D northeast;

// Optional parameters
@property (strong, nonatomic) NSDictionary *components;
@property (copy, nonatomic) NSString *language;
@property (copy, nonatomic) NSString *region;
@property (assign, nonatomic) BOOL secure;

- (id)initWithAddress:(NSString *)address;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

+ (void)setGoogleClientID:(NSString *)clientID;
+ (void)setGooglePrivateKey:(NSString *)privateKey;

@end
