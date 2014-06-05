//
//  RequestOperation.m
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import "QRequestOperation.h"

@interface QRequestOperation () {
    BOOL _executing;
    BOOL _finished;
}
@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;
@property (strong, nonatomic, readwrite) NSURL *URL;
@property (strong, nonatomic) NSURLConnection *connection;
@end


@implementation QRequestOperation

+ (instancetype)requestOperationWithURL:(NSURL *)URL delegate:(id)delegate {
    return [[self alloc] initWithURL:URL delegate:delegate];
}

- (id)initWithURL:(NSURL *)URL delegate:(id<QRequestOperationDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
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
    
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:self.URL];
    self.connection = [NSURLConnection connectionWithRequest:URLRequest delegate:self];

    [self.connection start];
}

- (void)terminate {
    self.connection = nil;
    self.executing = NO;
    self.finished = YES;
    self.URL = nil;
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    if (response.statusCode != 200) {
        [connection cancel];
        
        NSString *localizedFailureReason = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:response.statusCode userInfo:@{NSLocalizedFailureReasonErrorKey: localizedFailureReason}];
        [self connection:connection didFailWithError:error];
    }
}

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
