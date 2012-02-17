//
//  GeocodingResponse.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "GeocodingResponse.h"
#import "QPlacemarkInternal.h"
#import "JSONKit.h"

static NSString * kGeocodingResults    = @"results";
static NSString * kGeocodingStatusCode = @"status";

const NSString * kGeocodeStatusCodeOk               = @"OK";
const NSString * kGeocodeStatusCodeZeroResults      = @"ZERO_RESULTS";
const NSString * kGeocodeStatusCodeOverQueryLimit   = @"OVER_QUERY_LIMIT";
const NSString * kGeocodeStatusCodeRequestDenied    = @"REQUEST_DENIED";
const NSString * kGeocodeStatusCodeInvalidRequest   = @"INVALID_REQUEST";

@implementation GeocodingResponse

@synthesize placemarks   = _placemarks;
@synthesize statusCode   = _statusCode;

- (NSInteger)codeForString:(NSString *)statusString {

    if ([kGeocodeStatusCodeOk isEqualToString:statusString]) {
        return GeocodeStatusCodeOk;
    }
    else if ([kGeocodeStatusCodeZeroResults isEqualToString:statusString]) {
        return GeocodeStatusCodeZeroResults;
    }
    else if ([kGeocodeStatusCodeOverQueryLimit isEqualToString:statusString]) {
        return GeocodeStatusCodeOverQueryLimit;
    }
    else if ([kGeocodeStatusCodeRequestDenied isEqualToString:statusString]) {
        return GeocodeStatusCodeRequestDenied;
    }
    else if ([kGeocodeStatusCodeInvalidRequest isEqualToString:statusString]) {
        return GeocodeStatusCodeInvalidRequest;
    }
    
    return -1;
}

- (id)initWithData:(NSData *)data {
    if ((self = [super init])) {
        NSDictionary * JSON = [data objectFromJSONData];
        NSMutableArray * placemarks = [NSMutableArray array];
        NSArray * results = [JSON objectForKey:kGeocodingResults];
        for (id dictionary in results)
        {
            QPlacemark * placemark = [[QPlacemark alloc] initWithDictionary:dictionary];
            [placemarks addObject:placemark];
            [placemark release];
        }
        
        _placemarks = [placemarks copy];
        _statusCode = [self codeForString:[JSON valueForKey:kGeocodingStatusCode]];
    }
    return self;
}

- (void)dealloc {
    [_placemarks release], _placemarks = nil;
    [super dealloc];
}

@end


