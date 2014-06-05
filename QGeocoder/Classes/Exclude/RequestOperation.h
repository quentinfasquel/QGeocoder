//
//  RequestOperation.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import <Foundation/Foundation.h>

@interface RequestOperation : NSOperation
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic, readonly) NSURLConnection *connection;
@property (strong, nonatomic, readonly) NSURL *URL;
@property (strong, nonatomic, readonly) NSMutableData *responseData;
@property (assign, nonatomic) BOOL secure;

+ (instancetype)requestOperationWithURL:(NSURL *)URL delegate:(id)delegate;

@end
