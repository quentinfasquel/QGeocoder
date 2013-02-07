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
@interface GeocodingRequest : NSObject {

    NSURL *                 _URL;
    NSString *              _address;
    CLLocationCoordinate2D  _coordinate;
    CLLocationCoordinate2D  _southwest, _northeast;
    NSString *              _region;
    NSString *              _language;
    BOOL                    _executing;
    BOOL                    _finished;
    BOOL                    _secure;
}

@property (nonatomic, readonly) NSURL *                 URL;
@property (nonatomic, copy)     NSString *              address;
@property (nonatomic)           CLLocationCoordinate2D  coordinate;
@property (nonatomic)           CLLocationCoordinate2D  southwest;
@property (nonatomic)           CLLocationCoordinate2D  northeast;
@property (nonatomic, copy)     NSString *              region;
@property (nonatomic, copy)     NSString *              language;
@property (nonatomic, assign)   BOOL                    secure;

- (id)initWithAddress:(NSString *)address;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
