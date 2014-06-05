//
//  QPlacemark.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/16/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface QPlacemark : NSObject

@property (nonatomic, readonly) CLLocation * location;
@property (nonatomic, readonly) CLRegion * region;

// Not supported
@property (nonatomic, readonly) NSDictionary * addressDictionary;

@property (nonatomic, readonly) NSString *name; // eg. Apple Inc.
@property (nonatomic, readonly) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
@property (nonatomic, readonly) NSString *subThoroughfare; // eg. 1
@property (nonatomic, readonly) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readonly) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readonly) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, readonly) NSString *ISOcountryCode; // eg. US
@property (nonatomic, readonly) NSString *country; // eg. United States

// Not supported
@property (nonatomic, readonly) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, readonly) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, readonly) NSArray *areasOfInterest; // eg. Golden Gate Park

@end