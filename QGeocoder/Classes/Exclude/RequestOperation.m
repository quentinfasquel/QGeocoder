//
//  RequestOperation.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import "RequestOperation.h"
#import "NSObject+RequestOperation.h"

@interface RequestOperation () {
    BOOL _executing;
    BOOL _finished;
}

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end


@implementation RequestOperation

#pragma mark - Geocoding or Reverse Geocoding

+ (instancetype)requestOperationWithURL:(NSURL *)URL delegate:(id)delegate {
    RequestOperation *operation = [[self alloc] initWithURL:URL];
    operation.delegate = delegate;
    return operation;
}

- (id)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        _URL = URL;
        _finished = NO;
        _executing = NO;
    }
    return self;
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
    [self.connection cancel];
    
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
    [self.connection start];
}

- (void)terminate {
    _connection = nil;
    _URL = nil;
    self.executing = NO;
    self.finished = YES;
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] initWithData:data];
    } else {
        [self.responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [self.delegate request:self didFailWithError:error];
    }
    
    [self terminate];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
        [self.delegate requestDidFinishLoading:self];
    }

    [self terminate];
}

@end
