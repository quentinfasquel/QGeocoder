//
//  GeocodingRequest.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Soleil Noir. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+GeocodingRequest.h"

extern NSString * const GeocodingRequestOutputJSON;
extern NSString * const GeocodingRequestOutputXML;

/**
 * Google Geocoding Request
 * http://code.google.com/apis/maps/documentation/geocoding/#GeocodingRequests
 *
 * You may have either an address (Geocoding) or a coordinate (Reverse Geocoding), never both.
 *
 */
@interface GeocodingRequest : NSOperation {

//    id                      _delegate;
    NSURL *                 _URL;
    NSURLConnection *       _connection;
    NSMutableData *         _responseData;
    NSString *              _address;
    CLLocationCoordinate2D  _coordinate;
    CLLocationCoordinate2D  _southwest, _northeast;
    NSString *              _region;
    NSString *              _language;
    BOOL                    _executing;
    BOOL                    _finished;
    BOOL                    _secure;
}

@property (nonatomic, retain)   id                      delegate;
@property (nonatomic, readonly) NSURL *                 URL;
@property (nonatomic, readonly) NSMutableData *         responseData;
@property (nonatomic, copy)     NSString *              address;
@property (nonatomic)           CLLocationCoordinate2D  coordinate;
@property (nonatomic)           CLLocationCoordinate2D  southwest;
@property (nonatomic)           CLLocationCoordinate2D  northeast;
@property (nonatomic, copy)     NSString *              region;
@property (nonatomic, copy)     NSString *              language;

@property (nonatomic, assign)   BOOL                    secure;

- (id)initWithAddress:(NSString *)address delegate:(id)aDelegate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id)aDelegate;

@end
