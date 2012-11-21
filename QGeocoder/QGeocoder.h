//
//  QGeocoder.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GeocodingRequest;
@class GeocodingResponse;
@protocol QGeocoderDelegate;

@interface QGeocoder : NSObject {
@private
    GeocodingRequest * _request;
    GeocodingResponse * _response;
}

@property (nonatomic, retain) id <QGeocoderDelegate> delegate;
@property (nonatomic, readonly, getter = isGeocoding) BOOL geocoding;

// Optionnal parameters
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * region;

- (void)reverseGeocodeLocation:(CLLocation *)location;

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary;
- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString;
- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler;
- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region;
- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler;

- (void)cancelGeocode;

@end


@protocol QGeocoderDelegate <NSObject>
@required
- (void)geocoder:(QGeocoder *)geocoder didFindPlacemarks:(NSArray *)placemarks;
- (void)geocoder:(QGeocoder *)geocoder didFailWithError:(NSError *)error;
@optional
- (BOOL)geocoderShouldUseSecureConnection:(QGeocoder *)geocoder;
@end

