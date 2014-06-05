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

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
    while(condition) { \
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
    }


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.geocoder = [QGeocoder new];
    self.geocoder.components = @{@"country":@"US", @"locality":@"locality"};
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
    StartBlock();

    [self.geocoder geocodeAddressString:@"Santa" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            XCTAssert([placemarks isKindOfClass:[NSArray class]], @"placemarks should always be an array when there are no error, it can be empty.");
        } else {
            XCTAssertNotNil(error, @"if placemarks is nil, then an error should be there.");
        }

        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

@end
