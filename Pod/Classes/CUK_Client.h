//
//  CUK_Client.h
//  Pods
//
//  Created by Kivanc on 17/06/15.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
#import "Constants.h"

@interface CUK_Client : AFHTTPSessionManager

+ (CUK_Client *) sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;


- (void) retrieveToken:(DefaultBooleanResultBlock)compilation;

- (void) makeRequestPost:(NSString *)route WithParameters:(NSDictionary *) paramaters compilation:(DefaultIdResultBlock) compilation;

- (void) getMallsCallback:(DefaultIdResultBlock) callback;
@end
