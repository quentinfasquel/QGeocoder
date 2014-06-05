//
//  QPlacemark.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 12/16/10.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QPlacemark.h"
#import "QPlacemarkInternal.h"

@implementation QPlacemark

- (NSString *)description {
    return self.addressComponents[@"FormattedAddress"];
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
    return nil;
}

- (NSString *)administrativeArea {
    return self.addressComponents[kPlacemarkAdministrativeArea];
}

- (NSString *)country {
    return self.addressComponents[kPlacemarkCountry];
}

- (NSString *)inlandWater {
    return nil;
}

- (NSString *)ISOcountryCode {
    return self.addressComponents[kPlacemarkISOcountryCode];
}

- (NSString *)locality {
    return self.addressComponents[kPlacemarkLocality];
}

- (NSString *)name {
    return nil;
}

- (NSString *)ocean {
    return nil;
}

- (NSString *)postalCode {
    return self.addressComponents[kPlacemarkPostalCode];
}

- (NSString *)subAdministrativeArea {
    return self.addressComponents[kPlacemarkSubAdministrativeArea];
}

- (NSString *)subLocality {
    return self.addressComponents[kPlacemarkSubLocality];
}

- (NSString *)subThoroughfare {
    return self.addressComponents[kPlacemarkSubThoroughfare];
}

- (NSString *)thoroughfare {
    return self.addressComponents[kPlacemarkThoroughfare];
}

@end
