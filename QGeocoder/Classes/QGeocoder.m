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
@property (strong, nonatomic) NSMapTable *completionHandlers;
@end


@implementation QGeocoder

+ (void)setGoogleClientID:(NSString *)clientID {
    [GeocodingRequest setGoogleClientID:clientID];
}

+ (void)setGooglePrivateKey:(NSString *)privateKey {
    [GeocodingRequest setGooglePrivateKey:privateKey];
}

static NSString *_googleApiClientID;
+ (void)setGoogleApiClientID:(NSString *)clientID {
    _googleApiClientID = [clientID copy];
}

+ (NSOperationQueue *)mainQueue {
    static dispatch_once_t once;
    static NSOperationQueue * GeocoderQueue = nil;
    dispatch_once(&once, ^{
        GeocoderQueue = [[NSOperationQueue alloc] init];
    });
    return GeocoderQueue;
}

- (id)init {
    if ((self = [super init])) {
        _completionHandlers = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableCopyIn];
    }
    return self;
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
    request.components = _components;

    if ([self.delegate respondsToSelector:@selector(geocoderShouldUseSecureConnection:)]) {
        request.secure = [self.delegate geocoderShouldUseSecureConnection:self];
    }

    [[QGeocoder mainQueue] addOperation:[RequestOperation requestOperationWithURL:request.URL delegate:self]];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region {
#pragma warning TODO
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler {
#pragma warning TODO
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler {

    GeocodingRequest * request = [[GeocodingRequest alloc] initWithAddress:addressString];
    request.region = _region;
    request.language = _language;
    request.components = _components;

    RequestOperation *operation = [RequestOperation requestOperationWithURL:request.URL delegate:self];

    [self.completionHandlers setObject:completionHandler forKey:operation];
    [[QGeocoder mainQueue] addOperation:operation];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
#pragma warning TODO
}

#pragma mark - Managing Internal Requests

- (void)completeRequestOperation:(RequestOperation *)request placemarks:(NSArray *)placemarks error:(NSError *)error {
    CLGeocodeCompletionHandler completionHandler = [self.completionHandlers objectForKey:request];
    if (completionHandler) {
        completionHandler(placemarks, error);
        [self.completionHandlers removeObjectForKey:request];

    }
    
    if (!error && [self.delegate respondsToSelector:@selector(geocoder:didFindPlacemarks:)]) {
        [self.delegate geocoder:self didFindPlacemarks:placemarks];
    }
    else if (error && [self.delegate respondsToSelector:@selector(geocoder:didFailWithError:)]) {
        [self.delegate geocoder:self didFailWithError:error];
    }
}

- (void)requestDidFinishLoading:(RequestOperation *)request {
    NSError *error = nil;
    GeocodingResponse * response = [[GeocodingResponse alloc] initWithData:request.responseData error:&error];
    [self completeRequestOperation:request placemarks:response.placemarks error:error];
}

- (void)request:(RequestOperation *)request didFailWithError:(NSError *)error {
    [self completeRequestOperation:request placemarks:nil error:error];
}

@end
