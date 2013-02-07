//
//  RequestOperation.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import <Foundation/Foundation.h>

@interface RequestOperation : NSOperation {
    NSURL *                 _URL;
    NSURLConnection *       _connection;
    NSMutableData *         _responseData;
    BOOL                    _executing;
    BOOL                    _finished;
    BOOL                    _secure;
}

@property (nonatomic, retain)   id                      delegate;
@property (nonatomic, readonly) NSURL *                 URL;
@property (nonatomic, readonly) NSMutableData *         responseData;
@property (nonatomic, assign)   BOOL                    secure;

+ (id)requestOperationWithURL:(NSURL *)URL delegate:(id)delegate;

@end
