//
//  GeocodingResponse.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/14/10.
//  Copyright 2011 Soleil Noir. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString * kGeocodeStatusCodeOk;
extern const NSString * kGeocodeStatusCodeZeroResults;
extern const NSString * kGeocodeStatusCodeOverQueryLimit;
extern const NSString * kGeocodeStatusCodeRequestDenied;
extern const NSString * kGeocodeStatusCodeInvalidRequest;

typedef enum {
    GeocodeStatusCodeOk             = 0,
    GeocodeStatusCodeZeroResults    = 2,
    GeocodeStatusCodeOverQueryLimit = 4,
    GeocodeStatusCodeRequestDenied  = 8,
    GeocodeStatusCodeInvalidRequest = 16
} GeocodeStatusCode;

@interface GeocodingResponse : NSObject {
    NSArray *   _placemarks;
    NSInteger   _statusCode;
}

@property (nonatomic, readonly) NSArray *   placemarks;
@property (nonatomic, readonly) NSInteger   statusCode;

- (id)initWithData:(NSData *)data;

@end
