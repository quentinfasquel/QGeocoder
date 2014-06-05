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
@property (nonatomic, readonly) NSArray * areasOfInterest;
@property (nonatomic, readonly) NSDictionary * addressDictionary;
@property (nonatomic, readonly) NSString * inlandWater;
@property (nonatomic, readonly) NSString * country;
@property (nonatomic, readonly) NSString * ISOcountryCode;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * ocean;
@property (nonatomic, readonly) NSString * postalCode;
@property (nonatomic, readonly) NSString * administrativeArea;
@property (nonatomic, readonly) NSString * subAdministrativeArea;
@property (nonatomic, readonly) NSString * locality;
@property (nonatomic, readonly) NSString * subLocality;
@property (nonatomic, readonly) NSString * thoroughfare;
@property (nonatomic, readonly) NSString * subThoroughfare;

@end