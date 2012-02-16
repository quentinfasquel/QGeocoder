//
//  QGeocoder.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Soleil Noir. All rights reserved.
//

#import "QGeocoder.h"
#import "GeocodingRequest.h"
#import "GeocodingResponse.h"


@interface QGeocoder ()
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
@property (nonatomic, copy) CLGeocodeCompletionHandler completionHandler;
@property (nonatomic, assign) BOOL shouldUseNativeAPI;
#endif
@end


@implementation QGeocoder
@synthesize delegate = _delegate;
@synthesize language = _language;
@synthesize region = _region;
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
@synthesize completionHandler = _completionHandler;
@synthesize shouldUseNativeAPI;
#endif

- (id)init {
    if ((self = [super init])) {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
        float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        self.shouldUseNativeAPI = (systemVersion >= 5.0);

        if (self.shouldUseNativeAPI) {
            _geocoder = [[CLGeocoder alloc] init];
        }
#endif
    }
    
    return self;
}

- (void)dealloc {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    [_geocoder release];
#endif
    [_geocodingRequest release];
    [_geocodingResponse release];
    [_language release];
    [_region release];
    [super dealloc];
}

- (BOOL)isGeocoding {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (self.shouldUseNativeAPI) {
        return [_geocoder isGeocoding];
    }
    else
#endif
        return [_geocodingRequest isExecuting];
}

- (void)setDelegate:(id<QGeocoderDelegate>)delegate {
    _delegate = delegate;
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    self.completionHandler = ^(NSArray * placemarks, NSError * error)
    {
        if (error) {
            [_delegate performSelector:@selector(geocoder:didFailWithError:) withObject:self withObject:error];
        }
        else {
            [_delegate performSelector:@selector(geocoder:didFindPlacemarks:) withObject:self withObject:placemarks];
        }
    };
#endif
}

- (void)cancelGeocode {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (self.shouldUseNativeAPI) {
        [_geocoder cancelGeocode];
    }
    else
#endif
    if (_geocodingRequest) {
        [_geocodingRequest cancel];
        [_geocodingRequest release], _geocodingRequest = nil;
    }
}

#pragma mark - Reverse geocoding

- (void)reverseGeocodeLocation:(CLLocation *)location {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (self.shouldUseNativeAPI) {
        [_geocoder reverseGeocodeLocation:location completionHandler:[self completionHandler]];
    }
    else
#endif
    {
        [self cancelGeocode];
        
        _geocodingRequest = [[GeocodingRequest alloc] initWithCoordinate:location.coordinate delegate:self];
        _geocodingRequest.region = _region;
        _geocodingRequest.language = _language;

        if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
            _geocodingRequest.secure = [_delegate geocoderShouldUseSecureConnection:self];
        }

        [_geocodingRequest start];
    }
}

#pragma mark - Geocoding

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (self.shouldUseNativeAPI) {
        [_geocoder geocodeAddressDictionary:addressDictionary completionHandler:[self completionHandler]];
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
    if (self.shouldUseNativeAPI) {
        [_geocoder geocodeAddressString:addressString completionHandler:[self completionHandler]];
    }
    else
#endif
    {
        [self cancelGeocode];

        _geocodingRequest = [[GeocodingRequest alloc] initWithAddress:addressString delegate:self];
        _geocodingRequest.region = _region;
        _geocodingRequest.language = _language;

        if ([_delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
            _geocodingRequest.secure = [_delegate geocoderShouldUseSecureConnection:self];
        }

        [_geocodingRequest start];
    }    
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region {
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    if (self.shouldUseNativeAPI) {
        [_geocoder geocodeAddressString:addressString inRegion:region completionHandler:[self completionHandler]];
    }
    else
#endif
    {
        [self cancelGeocode];
        // TODO
    }
}

#pragma mark - Geocoding request delegate

- (void)geocodingRequestDidFinishLoading:(GeocodingRequest *)request {

    _geocodingResponse = [[GeocodingResponse alloc] initWithData:request.responseData];
    GeocodeStatusCode statusCode = _geocodingResponse.statusCode;
    if (statusCode == GeocodeStatusCodeOk || statusCode == GeocodeStatusCodeZeroResults)
    {
        [_delegate performSelector:@selector(geocoder:didFindPlacemarks:) withObject:self withObject:_geocodingResponse.placemarks];
    }
    else
    {
        NSError * error = nil;
        [_delegate performSelector:@selector(geocoder:didFailWithError:) withObject:self withObject:error];
    }
    
    [_geocodingRequest release], _geocodingRequest = nil;
    [_geocodingResponse release], _geocodingResponse = nil;
}

- (void)geocodingRequest:(GeocodingRequest *)request didFailWithError:(NSError *)error {
    [_delegate performSelector:@selector(geocoder:didFailWithError:) withObject:self withObject:error];
    [_geocodingRequest release], _geocodingRequest = nil;
}

@end
