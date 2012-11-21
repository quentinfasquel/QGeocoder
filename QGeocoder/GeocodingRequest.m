//
//  GeocodingRequest.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "GeocodingRequest.h"
#import "NSObject+GeocodingRequest.h"

static NSString * GeocodingURL          = @"http://maps.googleapis.com/maps/api/geocode/%@?%@";
static NSString * GeocodingSecureURL    = @"https://maps.googleapis.com/maps/api/geocode/%@?%@";

NSString * const GeocodingRequestOutputJSON = @"json";
NSString * const GeocodingRequestOutputXML  = @"xml";


@interface GeocodingRequest ()
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end


@implementation GeocodingRequest

@synthesize delegate        = _delegate;
@synthesize URL             = _URL;
@synthesize responseData    = _responseData;
@synthesize coordinate      = _coordinate;
@synthesize address         = _address;
@synthesize southwest       = _southwest;
@synthesize northeast       = _northeast;
@synthesize region          = _region;
@synthesize language        = _language;
@synthesize secure          = _secure;

#pragma mark - Geocoding or Reverse Geocoding

- (id)initWithAddress:(NSString *)address delegate:(id)aDelegate {
    if (self = [super init]) {
        _delegate = [aDelegate retain];
        _address = [address copy];
        _northeast = kCLLocationCoordinate2DInvalid;
        _southwest = kCLLocationCoordinate2DInvalid;
        _finished = NO;
        _executing = NO;
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id)aDelegate {
    if ((self = [super init])) {
        _delegate = [aDelegate retain];
        _address = nil;
        _coordinate = coordinate;
        _northeast = kCLLocationCoordinate2DInvalid;
        _southwest = kCLLocationCoordinate2DInvalid;        
        _finished = NO;
        _executing = NO;
    }
    return self;
}

- (void)dealloc {
    [_delegate release], _delegate = nil;
    [_address release], _address = nil;
    [_region release], _region = nil;
    [_URL release], _URL = nil;
    [_connection release], _connection = nil;
    [_responseData release], _responseData = nil;
    [super dealloc];
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
    
    // sensor because iPhone is a device
    [parameters appendString:@"&sensor=false"];
    
    return parameters;
}

- (NSURL *)URL {
    if (!_URL) {
        _URL = [[NSURL alloc] initWithString:
                [NSString stringWithFormat:
                 (_secure ? GeocodingSecureURL : GeocodingURL),
                 GeocodingRequestOutputJSON,
                 [self parameters]]];
    }
    return _URL;
}

#pragma mark - NSOperation

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];        
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = executing;
}

- (void)cancel {
    [_connection cancel];

    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self didChangeValueForKey:@"isCancelled"];    
}

- (void)start {

    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }

    self.executing = YES;

    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.URL] delegate:self];
    [_connection start];
}

- (void)terminate {
    [_connection release], _connection = nil;
    [_URL release], _URL = nil;
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] init];
    }
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(geocodingRequest:didFailWithError:)]) {
        [_delegate geocodingRequest:self didFailWithError:error];
    }
    [self terminate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([_delegate respondsToSelector:@selector(geocodingRequestDidFinishLoading:)]) {
        [_delegate geocodingRequestDidFinishLoading:self];
    }
    [self terminate];
}

@end
