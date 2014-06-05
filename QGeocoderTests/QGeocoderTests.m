//
//  QGeocoderTests.m
//  QGeocoderTests
//
//  Created by Quentin Fasquel on 04/06/2014.
//
//

#import <XCTest/XCTest.h>
#import "QGeocoder.h"

@interface QGeocoderTests : XCTestCase
@property (strong, nonatomic) QGeocoder *geocoder;
@end

@implementation QGeocoderTests

- (void)waitWithBool:(BOOL *)wait {
    while (*wait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.geocoder = [QGeocoder new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.geocoder = nil;
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testSimpleGeocoding
{
    __block BOOL wait = YES;

    NSString *addressString = @"San Francisco";
    [self.geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            XCTAssert([placemarks isKindOfClass:[NSArray class]], @"placemarks should always be an array when there are no error, it can be empty.");
        } else {
            XCTAssertNotNil(error, @"if placemarks is nil, then an error should be there.");
        }

        wait = NO;
    }];
    
    [self waitWithBool:&wait];
}

@end
