//
//  CUK_Client.m
//  Pods
//
//  Created by Kivanc on 17/06/15.
//
//

// Set this to your World Weather Online API Key

//add this to your constan.h file

#import "CUK_Client.h"
#import <sys/utsname.h>

//Get DeviceName without using any thirdParty lib
NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


@implementation CUK_Client


+ (CUK_Client *) sharedClient {
    static CUK_Client *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken , ^ {
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:MallframeItURL]];
        
    });
    
    return  _sharedClient;
}

+ (CUK_Client *) googleMapsClient {
    static CUK_Client *googleMapsClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken , ^ {
        googleMapsClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/"]];
        
    });
    
    return  googleMapsClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    
    return self;
    
}

-(void)retrieveToken:(DefaultBooleanResultBlock)completion {
    
    NSDictionary *paramaters = @{
                                 @"info" : @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName()
                                         },
                                 @"data" : @{
                                         @"secret" : MallframeItApiKey
                                         }
                                 };
    
    NSLog(@"paramaters %@" ,paramaters);
    NSLog(@"deviceName %@", deviceName());
    [self POST:@"/v1/auth/token"
    parameters:paramaters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (responseObject) {
               NSLog(@"response object %@" ,responseObject);
               NSString *strToken = [responseObject valueForKey:@"token"];
               if (strToken) {
                   [self saveToken:strToken];
                   if (completion){
                       return completion ( nil , YES );
                   }
               }
               else {
                   //Problem about token give error;
                   if (completion){
                       id error = [responseObject valueForKey:@"error"];
                       return completion ( [NSString stringWithFormat:@"%@ - %@", [error valueForKey:@"code"], [error valueForKey:@"msg"]] , NO );
                   }
               }
               
           }
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"error %@" , [error localizedDescription]);
           return completion ( [error localizedDescription] ,NO );
       }];
    
}

- (void) makeRequestPost:(NSString *)route WithParameters:(NSDictionary *) paramaters completion:(DefaultIdResultBlock) completion {
    
    
    
    [self setHeader];
    [self POST:route parameters:paramaters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (!responseObject) {
            return completion( @"Something went wrong try again never :)"  ,  nil);
        }
        
        //        NSLog(@"JSON: %@", [responseObject description]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *error = responseObject[@"error"];
            if ( error) {
                
                NSNumber *code = [error valueForKey:@"code"];
                NSLog(@"%@ - %@" ,code,error);
                
                if ([code integerValue] == TOKEN_ERROR ) {
                    
                    DefaultBooleanResultBlock retrieveTokenBlock = ^( NSString *error ,BOOL succes ) {
                        
                        if (error) {
                            return  completion ( @"Something went wrong try again never :)" , nil);
                        }
                        
                        NSLog(@"Token was expired. Now it renewed and you can make a new post request");
                        
                        [self setHeader];
                        [self POST:route parameters:paramaters success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSLog(@"You made it. Expired token is renewed and the request is made. Good Job.");
                            if (!responseObject) {
                                return completion(@"Something went wrong try again never :)", nil);
                            }
                            return completion (nil , responseObject);
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                            NSLog(@"Token expired tried to renew it but it didnt work out sorry :(");
                            return completion ( @"Something went wrong try again never :)" , nil);
                        }];
                        
                    };
                    return [self retrieveToken:retrieveTokenBlock];
                }
                
                return completion ( [NSString stringWithFormat:@"%@ - %@" ,code, error] ,nil );
                
            }
        }
        
        return completion ( nil ,responseObject );
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@" , [error description]);
        NSLog(@"The request is failed due to other problems. Check you internet.");
        return completion ([error localizedDescription], nil);
    }];
}


-(void)getMallsCallback:(DefaultIdResultBlock)callback {
    
    NSDictionary *parameters = @{
                                 @"info" : @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName(),
                                         }
                                 };
    
    [self makeRequestPost:@"v1/malls/" WithParameters:parameters completion:callback];
}



- (void)saveToken:(NSString*) token {
    NSString *fullToken = [NSString stringWithFormat:@"BEARER %@",token ];
    [[NSUserDefaults standardUserDefaults] setObject:fullToken forKey:USER_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getToken {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN];
    if (!token || token.length ==0) {
        token = @"Yeni_token_lazim";
    }
    return token;
    
}

- (void) setHeader {
    [self.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Authorization"];
}

- (NSString *) getLanguage {
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if (![language isEqualToString:@"it"]) {
        language = @"en";
    }
    
    return language;
}

- (NSDictionary *) getInfoObject   {
    return @{
             @"language" : [self getLanguage],
             @"device" : @"iOS",
             @"deviceModel" : deviceName()
             };
}

-(void)getStoresInspirationsPromitionWithMallId:(NSString *)mallId versionDict:(NSDictionary *)versions completion:(DefaultIdResultBlock)completion {
    
    NSDictionary *parameters = @{
                                 @"info" : @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName()
                                         },
                                 @"version":versions
                                 };
    NSString *route = [NSString stringWithFormat:@"v1/malls/%@/stores-promotions-inspirations", mallId];
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}

- (void) getLandsWithMallId:(NSString *) mallId versionDict:(NSDictionary*) versions completion:(DefaultIdResultBlock)completion{
    
    NSDictionary *parameters = @{
                                 @"info" : @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName()
                                         },
                                 @"version":@{
                                         @"lands":versions
                                         }
                                 };
    NSString *route = [NSString stringWithFormat:@"v1/malls/%@/lands", mallId];
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}

- (void) getHowTeWebviews: (NSString *) mallId completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info" : @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName()
                                         }
                                 };
    
    NSString *route = [NSString stringWithFormat:@"v1/malls/%@/getby", mallId];
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}

- (void) makeRequestGet:(NSString *) route withParamaters:(NSDictionary *)parameters completion:(DefaultIdResultBlock) completion {
    
    [self GET:route
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          
          return completion ( nil ,responseObject );
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          
          return completion ( [error localizedDescription] , nil );
      }];
}

-(void)getDirection:(NSDictionary *)params completion:(DefaultIdResultBlock)completion {
    
    [self makeRequestGet:@"maps/api/directions/json" withParamaters:params completion:completion];
}


//Login Methods

- (void)loginWithMail:(NSString *) email password:(NSString *) password mallID:(NSString *) mallID completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"mail":email,
                                         @"password":password,
                                         @"mall":mallID
                                         }
                                 };
    NSString *route = @"v1/user/login/mail";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}

- (void)loginWithSocial:(NSString *)mallId
             socailType:(NSString *)socialType
                  token:(NSString *)token
                  email:(NSString *)email
                    raw:(NSDictionary *)raw
             completion:(DefaultIdResultBlock)completion {
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"mall":mallId,
                                         @"social": @{
                                                 @"type":socialType,
                                                 @"token":token,
                                                 @"content":@{
                                                         @"email":email,
                                                         @"raw":raw
                                                         }
                                                 }
                                         }
                                 
                                 };
    
    NSString *route = @"v1/user/login/social";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
    
}

- (void)logout:(NSString *) userId completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"userid":userId
                                         }
                                 };
    NSString *route = @"v1/user/logout";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}



- (void)registerWithMail:(NSDictionary *) user completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"mall":[user valueForKey:@"mall"],
                                         @"user_name":[user valueForKey:@"user_name"],
                                         @"user_surname":[user valueForKey:@"user_surname"],
                                         @"user_gender":[user valueForKey:@"user_gender"],
                                         @"user_birthdate":[user valueForKey:@"user_birthdate"],
                                         @"user_mail":[user valueForKey:@"user_mail"],
                                         @"user_password":[user valueForKey:@"user_password"],
                                         }
                                 };
    
    NSString *route = @"v1/user/register";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
    
}

- (void)addToFavorite:(NSString *) userid itemTpye:(NSString *) itemType itemId:(NSString *)itemId completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"userid":userid,
                                         @"itemtype":itemType,
                                         @"itemid":itemId
                                         }
                                 };
    NSString *route = @"v1/user/favorite/add";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
}

- (void)removeFromFavorite:(NSString *) userid itemTpye:(NSString *) itemType itemId:(NSString *)itemId completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"userid":userid,
                                         @"itemtype":itemType,
                                         @"itemid":itemId
                                         }
                                 };
    NSString *route = @"v1/user/favorite/remove";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
}

- (void)removeFromNotification:(NSString *) userId notificationId:(NSString *) notificationId completion:(DefaultIdResultBlock) completion {
    
    NSDictionary *parameters = @{
                                 @"info": @{
                                         @"language" : [self getLanguage],
                                         @"device" : @"iOS"
                                         },
                                 @"data": @{
                                         @"userid":userId,
                                         @"notificationid":notificationId
                                         }
                                 };
    
    NSString *route = @"v1/user/notification/remove";
    
    [self makeRequestPost:route WithParameters:parameters completion:completion];
}

@end
