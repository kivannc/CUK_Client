//
//  CUK_Client.h
//  Pods
//
//  Created by Kivanc on 17/06/15.
//
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"

@interface CUK_Client : AFHTTPSessionManager

+ (CUK_Client *) sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end
