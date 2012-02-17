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
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
@property (nonatomic, copy) CLGeocodeCompletionHandler geocodeCompletionHandler;
#endif
@end


@implementation QGeocoder
@synthesize delegate = _delegate;
@synthesize language = _language;
@synthesize region = _region;
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
@synthesize geocodeCompletionHandler = _geocodeCompletionHandler;
@synthesize usesCoreLocationGeocoder;
#endif

- (void)dealloc {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    [_geocoder release];
    [_geocodeCompletionHandler release];
#endif
    [_language release];
    [_region release];
    [_request release];
    [_response release];
    [super dealloc];
}


#pragma mark - Managing Geocoding Requests

- (void)cancelGeocode {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        [_geocoder cancelGeocode];
    }
    else
#endif
    if (_request) {
        [_request cancel];
        [_request release], _request = nil;
    }
}

- (BOOL)isGeocoding {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        return [_geocoder isGeocoding];
    }
    else
#endif
        return [_request isExecuting];
}

#if QGEOCODER_IPHONE_5_0_API_WRAPPER
- (void)setDelegate:(id<QGeocoderDelegate>)delegate {
    _delegate = delegate;

    self.geocodeCompletionHandler = ^(NSArray * placemarks, NSError * error) {
        if (error) {
            [_delegate geocoder:self didFailWithError:error];
        }
        else {
            [_delegate geocoder:self didFindPlacemarks:placemarks];
        }
    };
}

- (void)setUsesCoreLocationGeocoder:(BOOL)coreLocationGeocoder {
    usesCoreLocationGeocoder = coreLocationGeocoder;
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
}
#endif


#pragma mark - Reverse Geocoding a Location

- (void)reverseGeocodeLocation:(CLLocation *)location {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        [_geocoder reverseGeocodeLocation:location completionHandler:self.geocodeCompletionHandler];
    }
    else
#endif
    {
        [self cancelGeocode];
        
        _request = [[GeocodingRequest alloc] initWithCoordinate:location.coordinate delegate:self];
        _request.region = _region;
        _request.language = _language;

        if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
            _request.secure = [_delegate geocoderShouldUseSecureConnection:self];
        }

        [_request start];
    }
}


#pragma mark - Geocoding an Address

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        [_geocoder geocodeAddressDictionary:addressDictionary completionHandler:self.geocodeCompletionHandler];
    }
    else
#endif
    {
        [self cancelGeocode];
        // TODO
    }
}

- (void)geocodeAddressString:(NSString *)addressString {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        [_geocoder geocodeAddressString:addressString completionHandler:self.geocodeCompletionHandler];
    }
    else
#endif
    {
        [self cancelGeocode];

        _request = [[GeocodingRequest alloc] initWithAddress:addressString delegate:self];
        _request.region = _region;
        _request.language = _language;

        if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
            _request.secure = [_delegate geocoderShouldUseSecureConnection:self];
        }

        [_request start];
    }    
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (usesCoreLocationGeocoder) {
        [_geocoder geocodeAddressString:addressString inRegion:region completionHandler:self.geocodeCompletionHandler];
    }
    else
#endif
    {
        [self cancelGeocode];

        // TODO
    }
}


#pragma mark - Managing Internal Requests

- (void)geocodingRequestDidFinishLoading:(GeocodingRequest *)request {
    _response = [[GeocodingResponse alloc] initWithData:request.responseData];

    GeocodeStatusCode statusCode = _response.statusCode;
    if (statusCode == GeocodeStatusCodeOk || statusCode == GeocodeStatusCodeZeroResults) {
        if ([_delegate respondsToSelector:@selector(geocoder:didFindPlacemarks:)]) {
            [_delegate geocoder:self didFindPlacemarks:_response.placemarks];
        }
    }
    else {
        // TODO "Receive unexpected status code"
    }

    [_request release], _request = nil;
    [_response release], _response = nil;
}

- (void)geocodingRequest:(GeocodingRequest *)request didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(geocoder:didFailWithError:)]) {
        [_delegate geocoder:self didFailWithError:error];        
    }

    [_request release], _request = nil;
}

@end
