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

@property (strong, nonatomic, readonly) NSURL *URL;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *language;
@property (strong, nonatomic) NSDictionary *components;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) CLLocationCoordinate2D southwest;
@property (assign, nonatomic) CLLocationCoordinate2D northeast;
@property (assign, nonatomic) BOOL secure;

+ (void)setGoogleClientID:(NSString *)clientID;
+ (void)setGooglePrivateKey:(NSString *)privateKey;

- (id)initWithAddress:(NSString *)address;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
