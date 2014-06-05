//
//  QPlacemarkInternal.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QPlacemark.h"

extern const NSString * kAddressComponentTypeStreet;
extern const NSString * kAddressComponentTypeRoute;
extern const NSString * kAddressComponentTypeIntersection;
extern const NSString * kAddressComponentTypePolitical;
extern const NSString * kAddressComponentTypeCountry;
extern const NSString * kAddressComponentTypeAdministrativeAreaLevel1;
extern const NSString * kAddressComponentTypeAdministrativeAreaLevel2;
extern const NSString * kAddressComponentTypeAdministrativeAreaLevel3;
extern const NSString * kAddressComponentTypeColloquialArea;
extern const NSString * kAddressComponentTypeLocality;
extern const NSString * kAddressComponentTypeSubLocality;
extern const NSString * kAddressComponentTypeNeighborhood;
extern const NSString * kAddressComponentTypePremise;
extern const NSString * kAddressComponentTypeSubPremise;
extern const NSString * kAddressComponentTypePostalCode;
extern const NSString * kAddressComponentTypeNaturalFeature;
extern const NSString * kAddressComponentTypeAirport;
extern const NSString * kAddressComponentTypePark;
extern const NSString * kAddressComponentTypePOI;
//
extern const NSString * kAddressComponentTypeStreetNumber;
extern const NSString * kAddressComponentTypePostBox;
extern const NSString * kAddressComponentTypeFloor;
extern const NSString * kAddressComponentTypeRoom;

extern const NSString * kPlacemarkAdministrativeArea;
extern const NSString * kPlacemarkCountry;
extern const NSString * kPlacemarkInlandWater;
extern const NSString * kPlacemarkISOcountryCode;
extern const NSString * kPlacemarkLocality;
extern const NSString * kPlacemarkName;
extern const NSString * kPlacemarkOcean;
extern const NSString * kPlacemarkPostalCode;
extern const NSString * kPlacemarkSubAdministrativeArea;
extern const NSString * kPlacemarkSubLocality;
extern const NSString * kPlacemarkSubThoroughfare;
extern const NSString * kPlacemarkThoroughfare;

@interface QPlacemark () {
    NSMutableDictionary * _addressDictionary;
    CLLocation * _location;
    CLRegion * _region;
}
@end

@interface QPlacemark (Private)
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end