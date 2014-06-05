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

@interface GeocodingRequest ()
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

- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:key options:0];
    key = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

- (NSURL *)URL {
    NSString *URLString = [NSString stringWithFormat:(_secure ? GeocodingSecureURL : GeocodingURL), GeocodingRequestOutputJSON, [self parameters]];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *URL = [NSURL URLWithString:URLString];
    
    // Sign URL if needed
    if (_googleApiClientID && _googleApiPrivateKey) {
        NSString *toSign = [URL.path stringByAppendingFormat:@"?%@&client=%@", URL.query, _googleApiClientID];
        NSString *signature = [self hmacsha1:toSign secret:_googleApiPrivateKey];
        URLString = [URLString stringByAppendingFormat:@"&signature=%@", signature];
        URL = [NSURL URLWithString:URLString];
    }

    return URL;
}

@end
