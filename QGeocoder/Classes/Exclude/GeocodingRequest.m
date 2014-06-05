//
//  GeocodingRequest.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "GeocodingRequest.h"

static NSString * GeocodingURL          = @"http://maps.googleapis.com/maps/api/geocode/%@?%@";
static NSString * GeocodingSecureURL    = @"https://maps.googleapis.com/maps/api/geocode/%@?%@";

NSString * const GeocodingRequestOutputJSON = @"json";
NSString * const GeocodingRequestOutputXML  = @"xml";

@interface GeocodingRequest ()
@end

@implementation GeocodingRequest

#pragma mark - Geocoding or Reverse Geocoding

- (id)initWithAddress:(NSString *)address {
    if (self = [super init]) {
        _address = [address copy];
        _northeast = kCLLocationCoordinate2DInvalid;
        _southwest = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _address = nil;
        _coordinate = coordinate;
        _northeast = kCLLocationCoordinate2DInvalid;
        _southwest = kCLLocationCoordinate2DInvalid;        
    }
    return self;
}

#pragma mark - Accessing Request Attributes

- (NSString *)parameters {
    // Exception : Needs address or coordinate !
    NSMutableString * parameters = [NSMutableString string];
    
    if (_address) {
        [parameters appendFormat:@"address=%@", _address];
    }
    else {
        [parameters appendFormat:@"latlng=%f,%f", _coordinate.latitude, _coordinate.longitude];
    }
    
    if (CLLocationCoordinate2DIsValid(_northeast) && CLLocationCoordinate2DIsValid(_southwest)) {
        [parameters appendFormat:@"&bounds=%f,%f|%f,%f", _southwest.latitude, _southwest.longitude, _northeast.latitude, _northeast.longitude];
    }
    if (_region) {
        [parameters appendFormat:@"&region=%@", _region];
    }
    
    if (_language) {
        [parameters appendFormat:@"&language=%@", _language];
    }
    
    // sensor because iPhone is a device
    [parameters appendString:@"&sensor=false"];
    
    return parameters;
}

- (NSURL *)URL {
    NSString *URLString = [NSString stringWithFormat:(_secure ? GeocodingSecureURL : GeocodingURL), GeocodingRequestOutputJSON, [self parameters]];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:URLString];
}

@end
