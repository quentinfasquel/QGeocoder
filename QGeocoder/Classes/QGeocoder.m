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
#import "QRequestOperation.h"

@interface QGeocoder () <QRequestOperationDelegate>
@property (strong, nonatomic) NSOperationQueue *requestQueue;
@property (strong, nonatomic) NSMapTable *completionHandlers;
@end


@implementation QGeocoder

+ (void)setGoogleClientID:(NSString *)clientID {
    [GeocodingRequest setGoogleClientID:clientID];
}

+ (void)setGooglePrivateKey:(NSString *)privateKey {
    [GeocodingRequest setGooglePrivateKey:privateKey];
}

- (id)init {
    if ((self = [super init])) {
        _completionHandlers = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableCopyIn];
        _requestQueue = [NSOperationQueue new];
    }
    return self;
}

#pragma mark - Managing Geocoding Requests

- (void)cancelGeocode {
    [self.requestQueue cancelAllOperations];
}

- (BOOL)isGeocoding {
    if (self.requestQueue.operationCount < 1) {
        return NO;
    }

    for (NSOperation * operation in self.requestQueue.operations) {
        if (operation.isExecuting) {
            return YES;
        }
    }

    return NO;
}

- (void)completeRequestOperation:(QRequestOperation *)request placemarks:(NSArray *)placemarks error:(NSError *)error {
    CLGeocodeCompletionHandler completionHandler = [self.completionHandlers objectForKey:request];
    if (completionHandler) {
        completionHandler(placemarks, error);
        [self.completionHandlers removeObjectForKey:request];
    }
}

#pragma mark - Reverse Geocoding a Location

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    GeocodingRequest * request = [[GeocodingRequest alloc] initWithCoordinate:location.coordinate];
    request.components = self.components;
    request.language = self.language;
    request.region = self.region;
#ifdef DEBUG
    request.secure = NO;
#else
    request.secure = YES;
#endif

    QRequestOperation *operation = [QRequestOperation requestOperationWithURL:request.URL delegate:self];
    [self.completionHandlers setObject:[completionHandler copy] forKey:operation];
    [self.requestQueue addOperation:operation];
}

#pragma mark - Geocoding an Address

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler {

    GeocodingRequest * request = [[GeocodingRequest alloc] initWithAddress:addressString];
    request.components = self.components;
    request.language = self.language;
    request.region = self.region;
#ifdef DEBUG
    request.secure = NO;
#else
    request.secure = YES;
#endif

    QRequestOperation *operation = [QRequestOperation requestOperationWithURL:request.URL delegate:self];
    [self.completionHandlers setObject:[completionHandler copy] forKey:operation];
    [self.requestQueue addOperation:operation];
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
#pragma warning TODO
}

#pragma mark - Request operation delegate

- (void)requestDidFinishLoading:(QRequestOperation *)request {
    NSError *error = nil;
    GeocodingResponse * response = [[GeocodingResponse alloc] initWithData:request.responseData error:&error];
    [self completeRequestOperation:request placemarks:[response.placemarks copy] error:error];
}

- (void)request:(QRequestOperation *)request didFailWithError:(NSError *)error {
    [self completeRequestOperation:request placemarks:nil error:error];
}

@end
