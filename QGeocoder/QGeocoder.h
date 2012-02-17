//
//  QGeocoder.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define QGEOCODER_IPHONE_5_0_API_WRAPPER 1

@class GeocodingRequest;
@class GeocodingResponse;
@protocol QGeocoderDelegate;

@interface QGeocoder : NSObject {
@private
    GeocodingRequest * _request;
    GeocodingResponse * _response;
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
    CLGeocoder * _geocoder;
#endif
}

@property (nonatomic, retain) id <QGeocoderDelegate> delegate;
@property (nonatomic, readonly, getter = isGeocoding) BOOL geocoding;
#if QGEOCODER_IPHONE_5_0_API_WRAPPER
@property (nonatomic, assign) BOOL usesCoreLocationGeocoder;
#endif

// Optionnal parameters
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * region;

- (void)reverseGeocodeLocation:(CLLocation *)location;

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary;
- (void)geocodeAddressString:(NSString *)addressString;
- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region;

- (void)cancelGeocode;

@end


@protocol QGeocoderDelegate <NSObject>
@required
- (void)geocoder:(QGeocoder *)geocoder didFindPlacemarks:(NSArray *)placemarks;
- (void)geocoder:(QGeocoder *)geocoder didFailWithError:(NSError *)error;
@optional
- (BOOL)geocoderShouldUseSecureConnection:(QGeocoder *)geocoder;
@end

