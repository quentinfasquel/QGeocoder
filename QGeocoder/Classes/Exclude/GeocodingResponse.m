//
//  GeocodingResponse.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "GeocodingResponse.h"
#import "QPlacemarkInternal.h"

static NSString * kGeocodingResults    = @"results";
static NSString * kGeocodingStatusCode = @"status";

const NSString * kGeocodeStatusCodeOk               = @"OK";
const NSString * kGeocodeStatusCodeZeroResults      = @"ZERO_RESULTS";
const NSString * kGeocodeStatusCodeOverQueryLimit   = @"OVER_QUERY_LIMIT";
const NSString * kGeocodeStatusCodeRequestDenied    = @"REQUEST_DENIED";
const NSString * kGeocodeStatusCodeInvalidRequest   = @"INVALID_REQUEST";

@implementation GeocodingResponse

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
        NSDictionary * JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray * placemarks = [NSMutableArray array];
        NSArray * results = [JSON objectForKey:kGeocodingResults];
        for (id dictionary in results) {
            [placemarks addObject:[[QPlacemark alloc] initWithDictionary:dictionary]];
        }

        _placemarks = [placemarks copy];
        _statusCode = [self codeForString:[JSON valueForKey:kGeocodingStatusCode]];
    }
    return self;
}

@end


