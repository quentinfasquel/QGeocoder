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

@implementation QPlacemark (Private)

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init]))
    {
        _addressDictionary = [[NSMutableDictionary alloc] init];
        
        // Address components
        NSDictionary * components = [dictionary objectForKey:kGeocodingResultAddressComponents];
        for (id component in components)
        {
            NSString * shortName = [component objectForKey:@"short_name"];
            NSString * longName = [component objectForKey:@"long_name"];
            NSArray * types = [component objectForKey:@"types"];
            
            if ([types containsObject:kAddressComponentTypeLocality]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkLocality];
            }
            else if ([types containsObject:kAddressComponentTypeSubLocality]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkSubLocality];
            }
            else if ([types containsObject:kAddressComponentTypeCountry]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkCountry];
                [_addressDictionary setObject:shortName forKey:kPlacemarkISOcountryCode];
            }
            else if ([types containsObject:kAddressComponentTypePostalCode]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkPostalCode];
            }
            else if ([types containsObject:kAddressComponentTypeAdministrativeAreaLevel1]) {
                [_addressDictionary setObject:shortName forKey:kPlacemarkAdministrativeArea];
            }
            else if ([types containsObject:kAddressComponentTypeAdministrativeAreaLevel2]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkSubAdministrativeArea];
            }
            else if ([types containsObject:kAddressComponentTypeRoute]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkThoroughfare];
            }
            else if ([types containsObject:kAddressComponentTypeStreetNumber]) {
                [_addressDictionary setObject:longName forKey:kPlacemarkSubThoroughfare];
            }
        }
        
        // Formatted address
        NSArray * formattedAddressLines = [[dictionary objectForKey:kGeocodingResultFormattedAddress]
                                           componentsSeparatedByString:@", "];
        [_addressDictionary setObject:formattedAddressLines forKey:@"FormattedAddressLines"];
        
        // Location
        NSDictionary * geometry     = [dictionary objectForKey:kGeocodingResultGeometry];
        NSDictionary * location     = [geometry objectForKey:kGeocodingResultLocation];
        CLLocationDegrees latitude  = [[location valueForKey:kGeocodingResultLatitude] doubleValue];
        CLLocationDegrees longitude = [[location valueForKey:kGeocodingResultLongitude] doubleValue];
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        // Region
        //        NSDictionary * northeast = [[geometry objectForKey:@"bounds"] objectForKey:@"northeast"];
        //        NSDictionary * southwest = [[geometry objectForKey:@"bounds"] objectForKey:@"southwest"];
        //        CLLocationCoordinate2D NE = CLLocationCoordinate2DMake([[northeast objectForKey:kGeocodingResultLatitude] doubleValue],
        //                                                               [[northeast objectForKey:kGeocodingResultLongitude] doubleValue]);
        //        CLLocationCoordinate2D SW = CLLocationCoordinate2DMake([[southwest objectForKey:kGeocodingResultLatitude] doubleValue],
        //                                                               [[southwest objectForKey:kGeocodingResultLongitude] doubleValue]);
        CLLocationDistance distance = 100.0;
        _region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(latitude, longitude)
                                                          radius:distance
                                                      identifier:nil];
    }
    return self;
}

@end
