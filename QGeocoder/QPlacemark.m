//
//  QPlacemark.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/16/10.
//  Copyright 2011 Soleil Noir. All rights reserved.
//

#import "QPlacemark.h"
#import "QPlacemarkInternal.h"

@implementation QPlacemark

- (void)dealloc {
    [_addressDictionary release];
    [_location release];
    [_region release];
    [super dealloc];
}

- (NSString *)description {
    NSString * formattedAddress = [(NSArray *)[_addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"%@", formattedAddress];
}

- (CLLocation *)location {
    return _location;
}
- (CLRegion *)region {
    return _region;
}

- (NSArray *)areasOfInterest {
    return nil;
}

- (NSDictionary *)addressDictionary {
    return _addressDictionary;
}

- (NSString *)administrativeArea {
    return [_addressDictionary objectForKey:kPlacemarkAdministrativeArea];
}

- (NSString *)country {
    return [_addressDictionary objectForKey:kPlacemarkCountry];
}

- (NSString *)inlandWater {
    return [_addressDictionary objectForKey:kPlacemarkInlandWater];
}
- (NSString *)ISOcountryCode {
    return [_addressDictionary objectForKey:kPlacemarkISOcountryCode];
}

- (NSString *)locality {
    return [_addressDictionary objectForKey:kPlacemarkLocality];
}

- (NSString *)name {
    return nil;
}

- (NSString *)ocean {
    return [_addressDictionary objectForKey:kPlacemarkOcean];
}

- (NSString *)postalCode {
    return [_addressDictionary objectForKey:kPlacemarkPostalCode];
}

- (NSString *)subAdministrativeArea {
    return [_addressDictionary objectForKey:kPlacemarkSubAdministrativeArea];
}

- (NSString *)subLocality {
    return [_addressDictionary objectForKey:kPlacemarkSubLocality];
}

- (NSString *)subThoroughfare {
    return [_addressDictionary objectForKey:kPlacemarkSubThoroughfare];
}

- (NSString *)thoroughfare {
    return [_addressDictionary objectForKey:kPlacemarkThoroughfare];
}

@end