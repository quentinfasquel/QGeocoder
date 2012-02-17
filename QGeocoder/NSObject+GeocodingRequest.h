//
//  NSObject+GeocodingRequest.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

@class GeocodingRequest;

@interface NSObject (GeocodingRequest)
- (void)geocodingRequestDidFinishLoading:(GeocodingRequest *)request;
- (void)geocodingRequest:(GeocodingRequest *)request didFailWithError:(NSError *)error;
@end