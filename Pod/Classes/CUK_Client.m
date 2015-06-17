//
//  CUK_Client.m
//  Pods
//
//  Created by Kivanc on 17/06/15.
//
//

// Set this to your World Weather Online API Key
static NSString * const MallframeItApiKey = @"PASTE YOUR API KEY HERE";

static NSString * const MallframeItURL = @"PASTE YOUR BASE ULR HERE";


#import "CUK_Client.h"

@implementation CUK_Client

+ (CUK_Client *) sharedClient {
    static CUK_Client *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken , ^ {
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:MallframeItURL]];
        
    });
    
    return  _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
    
}
@end
