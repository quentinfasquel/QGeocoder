//
//  RequestOperation.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import "RequestOperation.h"
#import "NSObject+RequestOperation.h"

@interface RequestOperation ()
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end


@implementation RequestOperation

@synthesize delegate        = _delegate;
@synthesize URL             = _URL;
@synthesize responseData    = _responseData;

#pragma mark - Geocoding or Reverse Geocoding

+ (id)requestOperationWithURL:(NSURL *)URL delegate:(id)delegate {
    return [[[self alloc] initWithURL:URL delegate:delegate] autorelease];
}

- (id)initWithURL:(NSURL *)URL delegate:(id)aDelegate {
    if (self = [super init]) {
        _URL = [URL retain];
        _delegate = [aDelegate retain];
        _finished = NO;
        _executing = NO;
    }
    return self;
}

- (void)dealloc {
    [_delegate release], _delegate = nil;
    [_connection release], _connection = nil;
    [_responseData release], _responseData = nil;
    [super dealloc];
}

#pragma mark - NSOperation

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)cancel {
    [_connection cancel];
    
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self didChangeValueForKey:@"isCancelled"];
}

- (void)start {
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    self.executing = YES;
    
    _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.URL] delegate:self];
    [_connection start];
}

- (void)terminate {
    [_connection release], _connection = nil;
    [_URL release], _URL = nil;
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] init];
    }
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
    [self terminate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([_delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
        [_delegate requestDidFinishLoading:self];
    }
    [self terminate];
}

@end
