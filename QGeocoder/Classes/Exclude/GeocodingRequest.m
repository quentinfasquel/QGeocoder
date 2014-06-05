//
//  GeocodingRequest.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "GeocodingRequest.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

static NSString * GeocodingURL          = @"http://maps.googleapis.com/maps/api/geocode/%@?%@";
static NSString * GeocodingSecureURL    = @"https://maps.googleapis.com/maps/api/geocode/%@?%@";

NSString * const GeocodingRequestOutputJSON = @"json";
NSString * const GeocodingRequestOutputXML  = @"xml";

@interface GeocodingRequest () {
    BOOL _coordinateIsSet;
}
@end

@implementation GeocodingRequest
static NSString *_googleApiClientID;
static NSString *_googleApiPrivateKey;

+ (void)setGoogleClientID:(NSString *)clientID {
    _googleApiClientID = [clientID copy];
}

+ (void)setGooglePrivateKey:(NSString *)privateKey {
    _googleApiPrivateKey = [privateKey copy];
}


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
        _northeast = kCLLocationCoordinate2DInvalid;
        _southwest = kCLLocationCoordinate2DInvalid;
        self.coordinate = coordinate;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        _coordinateIsSet = YES;
    }

    _coordinate = coordinate;
}

#pragma mark - Sign Helper

- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

#pragma mark - Accessing Request Attributes

- (NSString *)parameters {
    if (!_address && !_coordinateIsSet) {
        @throw [NSException exceptionWithName:@"GeocodingRequest Exception" reason:@"Geocoding requests need either an address or a valid coordinate." userInfo:nil];
    }

    NSMutableString * parameters = [NSMutableString string];
    
    if (_address) {
        [parameters appendFormat:@"address=%@", _address];
    } else {
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
    
    if (_components.count) {
        NSMutableString *components = [NSMutableString string];
        [self.components enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [components appendFormat:@"%@:%@|", key, obj];
        }];

        [components deleteCharactersInRange:NSMakeRange(components.length-1, 1)];
        [parameters appendFormat:@"&components=%@", components];
    }
    
    // sensor because iPhone is a device
    [parameters appendString:@"&sensor=false"];

    return parameters;
}

- (NSURL *)URL {
    NSString *URLString = [NSString stringWithFormat:(_secure ? GeocodingSecureURL : GeocodingURL), GeocodingRequestOutputJSON, [self parameters]];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *URL = [NSURL URLWithString:URLString];
    
    if (_googleApiClientID && _googleApiPrivateKey) { // Sign url if possible
        // Base64 decode private key
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:_googleApiPrivateKey options:0];
        NSString *key = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        NSString *toSign = [URL.path stringByAppendingFormat:@"?%@&client=%@", URL.query, _googleApiClientID];
        NSString *signature = [self hmacsha1:toSign secret:key];
        // Add signature
        URLString = [URLString stringByAppendingFormat:@"&signature=%@", signature];
        URL = [NSURL URLWithString:URLString];
    }

    return URL;
}

@end
