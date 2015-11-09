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
+ (CUK_Client *) googleMapsClient;

- (instancetype)initWithBaseURL:(NSURL *)url;


- (void)retrieveToken:(DefaultBooleanResultBlock)completion;

- (void)makeRequestPost:(NSString *)route WithParameters:(NSDictionary *) paramaters completion:(DefaultIdResultBlock) completion;

- (void)getMallsCallback:(DefaultIdResultBlock) callback;

- (void)getStoresInspirationsPromitionWithMallId:(NSString *) mallId versionDict:(NSDictionary*) versions completion:(DefaultIdResultBlock)completion;

- (void)getLandsWithMallId:(NSString *) mallId versionDict:(NSDictionary*) versions completion:(DefaultIdResultBlock)completion;

- (void)getHowTeWebviews: (NSString *) mallId completion:(DefaultIdResultBlock) completion;

- (void)getCurrentUser:(NSString *) mallId userId:(NSString *)userId completion:(DefaultIdResultBlock) completion;

//USER Methods

- (void)loginWithMail:(NSString *) email password:(NSString *) password mallID:(NSString *) mallID completion:(DefaultIdResultBlock) completion;

- (void)loginWithSocial:(NSString *)mallId
             socailType:(NSString *) socialType
                  token:(NSString *) token
                  email:(NSString *) email
                    raw:(NSDictionary *) raw
             completion:(DefaultIdResultBlock) completion;

- (void)logout:(NSString *) userId completion:(DefaultIdResultBlock) completion;

- (void)registerWithMail:(NSDictionary *) user completion:(DefaultIdResultBlock) completion;

- (void)addToFavorite:(NSString *) userid itemTpye:(NSString *) itemType itemId:(NSString *)itemId completion:(DefaultIdResultBlock) completion;

- (void)removeFromFavorite:(NSString *) userid itemTpye:(NSString *) itemType itemId:(NSString *)itemId completion:(DefaultIdResultBlock) completion;

- (void)removeFromNotification:(NSString *) userId notificationId:(NSString *) notificationId completion:(DefaultIdResultBlock) completion;

//Map Methods

- (void)makeRequestGet:(NSString *) route withParamaters:(NSDictionary *)parameters completion:(DefaultIdResultBlock) completion ;

- (void)getDirection:(NSDictionary *)params completion:(DefaultIdResultBlock) completion;
@end
