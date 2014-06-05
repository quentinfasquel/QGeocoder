//
//  RequestOperation.h
//  QGeocoder
//
//  Created by Quentin Fasquel on 21/11/12.
//
//

#import <Foundation/Foundation.h>

@class QRequestOperation;

@protocol QRequestOperationDelegate <NSObject>
- (void)requestDidFinishLoading:(QRequestOperation *)request;
- (void)request:(QRequestOperation *)request didFailWithError:(NSError *)error;
@end

@interface QRequestOperation : NSOperation
@property (weak, nonatomic) id<QRequestOperationDelegate> delegate;
@property (strong, nonatomic, readonly) NSURL *URL;
@property (strong, nonatomic, readonly) NSMutableData *responseData;

+ (instancetype)requestOperationWithURL:(NSURL *)URL delegate:(id<QRequestOperationDelegate>)delegate;

@end
