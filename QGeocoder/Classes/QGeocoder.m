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

#import "RequestOperation.h"

@interface QGeocoder ()
@end


@implementation QGeocoder

+ (NSOperationQueue *)mainQueue {
    static dispatch_once_t once;
    static NSOperationQueue * GeocoderQueue = nil;
    dispatch_once(&once, ^{
        GeocoderQueue = [[NSOperationQueue alloc] init];
    });
    return GeocoderQueue;
}

#pragma mark - Managing Geocoding Requests

- (void)cancelGeocode {
    [[QGeocoder mainQueue] cancelAllOperations];
}

- (BOOL)isGeocoding {
    if ([[QGeocoder mainQueue] operationCount] < 1) {
        return NO;
    }

    for (NSOperation * operation in [[QGeocoder mainQueue] operations]) {
        if ([operation isExecuting]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Reverse Geocoding a Location

- (void)reverseGeocodeLocation:(CLLocation *)location {
    [self cancelGeocode];
    
    GeocodingRequest * request = [[GeocodingRequest alloc] initWithCoordinate:location.coordinate];
    request.region = _region;
    request.language = _language;

    if ([self.delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
        request.secure = [self.delegate geocoderShouldUseSecureConnection:self];
    }

    [[QGeocoder mainQueue] addOperation:[RequestOperation requestOperationWithURL:request.URL delegate:self]];
}


#pragma mark - Geocoding an Address

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary {
#pragma warning TODO
}

- (void)geocodeAddressString:(NSString *)addressString {

    GeocodingRequest * request = [[GeocodingRequest alloc] initWithAddress:addressString];
    request.region = _region;
    request.language = _language;

    if ([self.delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
        request.secure = [self.delegate geocoderShouldUseSecureConnection:self];
    }

    [[QGeocoder mainQueue] addOperation:[RequestOperation requestOperationWithURL:request.URL delegate:self]];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region {
    [self cancelGeocode];
#pragma warning TODO
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler {
#pragma warning TODO
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler {

    GeocodingRequest * request = [[GeocodingRequest alloc] initWithAddress:addressString];
    request.region = _region;
    request.language = _language;

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:request.URL] queue:[QGeocoder mainQueue] completionHandler:^(NSURLResponse * urlResponse, NSData * responseData, NSError * error){
        GeocodingResponse * response = [[GeocodingResponse alloc] initWithData:responseData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(response.placemarks, error);
        });
    }];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
#pragma warning TODO
}

#pragma mark - Managing Internal Requests

- (void)requestDidFinishLoading:(RequestOperation *)request {
    GeocodingResponse * response = [[GeocodingResponse alloc] initWithData:request.responseData];

    GeocodeStatusCode statusCode = response.statusCode;
    if (statusCode == GeocodeStatusCodeOk || statusCode == GeocodeStatusCodeZeroResults) {
        if ([self.delegate respondsToSelector:@selector(geocoder:didFindPlacemarks:)]) {
            [self.delegate geocoder:self didFindPlacemarks:response.placemarks];
        }
    }
    else {
        // TODO "Receive unexpected status code"
    }
}

- (void)request:(GeocodingRequest *)request didFailWithError:(NSError *)error {

    if ([self.delegate respondsToSelector:@selector(geocoder:didFailWithError:)]) {
        [self.delegate geocoder:self didFailWithError:error];        
    }
}

@end
