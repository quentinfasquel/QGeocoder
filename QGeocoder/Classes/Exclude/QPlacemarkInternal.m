//
//  QPlacemarkInternal.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 25/07/11.
//  Copyright 2011 Quentin Fasquel. All rights reserved.
//

#import "QPlacemarkInternal.h"
#import <CoreLocation/CoreLocation.h>

static NSString * kGeocodingResultAddressComponents = @"address_components";
static NSString * kGeocodingResultFormattedAddress  = @"formatted_address";
static NSString * kGeocodingResultGeometry          = @"geometry";
static NSString * kGeocodingResultLocation          = @"location";
static NSString * kGeocodingResultLatitude          = @"lat";
static NSString * kGeocodingResultLongitude         = @"lng";

const NSString * kAddressComponentTypeStreet                    = @"street_address";
const NSString * kAddressComponentTypeRoute                     = @"route";
const NSString * kAddressComponentTypeIntersection              = @"intersection";
const NSString * kAddressComponentTypePolitical                 = @"political";
const NSString * kAddressComponentTypeCountry                   = @"country";
const NSString * kAddressComponentTypeAdministrativeAreaLevel1  = @"administrative_area_level_1";
const NSString * kAddressComponentTypeAdministrativeAreaLevel2  = @"administrative_area_level_2";
const NSString * kAddressComponentTypeAdministrativeAreaLevel3  = @"administrative_area_level_3";
const NSString * kAddressComponentTypeColloquialArea            = @"colloquial_area";
const NSString * kAddressComponentTypeLocality                  = @"locality";
const NSString * kAddressComponentTypeSubLocality               = @"sublocality";
const NSString * kAddressComponentTypeNeighborhood              = @"neighborhood";
const NSString * kAddressComponentTypePremise                   = @"premise";
const NSString * kAddressComponentTypeSubPremise                = @"subpremise";
const NSString * kAddressComponentTypePostalCode                = @"postal_code";
const NSString * kAddressComponentTypeNaturalFeature            = @"natural_feature";
const NSString * kAddressComponentTypeAirport                   = @"airport";
const NSString * kAddressComponentTypePark                      = @"park";
const NSString * kAddressComponentTypePOI                       = @"point_of_interest";
const NSString * kAddressComponentTypeStreetNumber              = @"street_number";
const NSString * kAddressComponentTypePostBox                   = @"post_box";
const NSString * kAddressComponentTypeFloor                     = @"floor";
const NSString * kAddressComponentTypeRoom                      = @"room";

const NSString * kPlacemarkAdministrativeArea       = @"State";
const NSString * kPlacemarkCountry                  = @"Country";
const NSString * kPlacemarkInlandWater              = @"";
const NSString * kPlacemarkISOcountryCode           = @"CountryCode";
const NSString * kPlacemarkLocality                 = @"City";
const NSString * kPlacemarkName                     = @"";
const NSString * kPlacemarkOcean                    = @"";
const NSString * kPlacemarkPostalCode               = @"ZIP";
const NSString * kPlacemarkSubAdministrativeArea    = @"SubAdministrativeArea";
const NSString * kPlacemarkSubLocality              = @"SubLocality";
const NSString * kPlacemarkSubThoroughfare          = @"SubThoroughfare";
const NSString * kPlacemarkThoroughfare             = @"Thoroughfare";


@implementation QPlacemark (Internal)

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary *addressComponents = [[NSMutableDictionary alloc] init];

        // Address components
        NSDictionary * components = [dictionary objectForKey:kGeocodingResultAddressComponents];
        for (id component in components)
        {
            NSString * shortName = [component objectForKey:@"short_name"];
            NSString * longName = [component objectForKey:@"long_name"];
            NSArray * types = [component objectForKey:@"types"];
            
            if ([types containsObject:kAddressComponentTypeLocality]) {
                addressComponents[kPlacemarkLocality] = longName;
            }
            else if ([types containsObject:kAddressComponentTypeSubLocality]) {
                addressComponents[kPlacemarkSubLocality] = longName;
            }
            else if ([types containsObject:kAddressComponentTypeCountry]) {
                addressComponents[kPlacemarkCountry] = longName;
                addressComponents[kPlacemarkISOcountryCode] = shortName;
            }
            else if ([types containsObject:kAddressComponentTypePostalCode]) {
                addressComponents[kPlacemarkPostalCode] = longName;
            }
            else if ([types containsObject:kAddressComponentTypeAdministrativeAreaLevel1]) {
                addressComponents[kPlacemarkAdministrativeArea] = shortName;
            }
            else if ([types containsObject:kAddressComponentTypeAdministrativeAreaLevel2]) {
                addressComponents[kPlacemarkSubAdministrativeArea] = longName;
            }
            else if ([types containsObject:kAddressComponentTypeRoute]) {
                addressComponents[kPlacemarkThoroughfare] = longName;
            }
            else if ([types containsObject:kAddressComponentTypeStreetNumber]) {
                addressComponents[kPlacemarkSubThoroughfare] = longName;
            }
        }
        
        // Formatted address
//        NSArray * formattedAddressLines = [[dictionary objectForKey:kGeocodingResultFormattedAddress] componentsSeparatedByString:@", "];
        addressComponents[@"FormattedAddress"] = [dictionary objectForKey:kGeocodingResultFormattedAddress];

        _addressComponents = [addressComponents copy];

        // Location
        NSDictionary * geometry     = [dictionary objectForKey:kGeocodingResultGeometry];
        NSDictionary * locationData = [geometry objectForKey:kGeocodingResultLocation];
        CLLocationDegrees latitude  = [[locationData valueForKey:kGeocodingResultLatitude] doubleValue];
        CLLocationDegrees longitude = [[locationData valueForKey:kGeocodingResultLongitude] doubleValue];
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

        // Region
        CLLocationDistance distance = 100.0;
        CLLocationCoordinate2D regionCenter = CLLocationCoordinate2DMake(latitude, longitude);
        _region = [[CLCircularRegion alloc] initWithCenter:regionCenter radius:distance identifier:nil];
    }

    return self;
}

@end
