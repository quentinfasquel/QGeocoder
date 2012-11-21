//
//  QGeocoder.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QGeocoder.h"
#import "GeocodingRequest.h"
#import "GeocodingResponse.h"


@interface QGeocoder ()
@property (retain, nonatomic) CLGeocodeCompletionHandler completionHandler;
@end


@implementation QGeocoder
@synthesize delegate = _delegate;
@synthesize language = _language;
@synthesize region = _region;
@synthesize completionHandler = _completionHandler;

- (void)dealloc {
    [_language release];
    [_region release];
    [_request release];
    [_response release];
    [super dealloc];
}


#pragma mark - Managing Geocoding Requests

- (void)cancelGeocode {
    if (_request) {
        [_request cancel];
        [_request release], _request = nil;
    }

    if (_completionHandler) {
        [_completionHandler release], _completionHandler = nil;
    }
}

- (BOOL)isGeocoding {
    return [_request isExecuting];
}

#pragma mark - Reverse Geocoding a Location

- (void)reverseGeocodeLocation:(CLLocation *)location {
    [self cancelGeocode];
    
    _request = [[GeocodingRequest alloc] initWithCoordinate:location.coordinate delegate:self];
    _request.region = _region;
    _request.language = _language;

    if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
        _request.secure = [_delegate geocoderShouldUseSecureConnection:self];
    }

    [_request start];
}


#pragma mark - Geocoding an Address

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary {
    [self cancelGeocode];
#warning TODO
}

- (void)geocodeAddressString:(NSString *)addressString {
    [self cancelGeocode];

    _request = [[GeocodingRequest alloc] initWithAddress:addressString delegate:self];
    _request.region = _region;
    _request.language = _language;

    if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
        _request.secure = [_delegate geocoderShouldUseSecureConnection:self];
    }

    [_request start];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region {
    [self cancelGeocode];
#warning TODO
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    [self geocodeAddressDictionary:addressDictionary];
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler {
//    ^(NSArray * placemarks, NSError * error)
    self.completionHandler = completionHandler;
    [self geocodeAddressString:addressString];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    [self geocodeAddressString:addressString inRegion:region];
}

#pragma mark - Managing Internal Requests

- (void)geocodingRequestDidFinishLoading:(GeocodingRequest *)request {
    _response = [[GeocodingResponse alloc] initWithData:request.responseData];

    GeocodeStatusCode statusCode = _response.statusCode;
    if (statusCode == GeocodeStatusCodeOk || statusCode == GeocodeStatusCodeZeroResults) {
        if (_completionHandler) {
            _completionHandler(_response.placemarks, nil);
        }
        else if ([_delegate respondsToSelector:@selector(geocoder:didFindPlacemarks:)]) {
            [_delegate geocoder:self didFindPlacemarks:_response.placemarks];
        }
    }
    else {
        // TODO "Receive unexpected status code"
    }

    [_request release], _request = nil;
    [_response release], _response = nil;
    [_completionHandler release], _completionHandler = nil;
}

- (void)geocodingRequest:(GeocodingRequest *)request didFailWithError:(NSError *)error {
    if (_completionHandler) {
        _completionHandler([NSArray array], error);
    }
    else if ([_delegate respondsToSelector:@selector(geocoder:didFailWithError:)]) {
        [_delegate geocoder:self didFailWithError:error];        
    }

    [_request release], _request = nil;
    [_completionHandler release], _completionHandler = nil;
}

@end
