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

-(void)retrieveToken:(DefaultBooleanResultBlock)compilation {
    
    NSDictionary *paramaters = @{
                                 @"info" : @{
                                         @"language" : [[NSLocale preferredLanguages] objectAtIndex:0],
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
                   if (compilation){
                       return compilation ( nil , YES );
                   }
               }
               else {
                   //Problem about token give error;
                   if (compilation){
                       id error = [responseObject valueForKey:@"error"];
                       return compilation ( [NSString stringWithFormat:@"%@ - %@", [error valueForKey:@"code"], [error valueForKey:@"msg"]] , NO );
                   }
               }
               
           }
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"error %@" , [error localizedDescription]);
           return compilation ( [error localizedDescription] ,NO );
       }];
    
}

- (void) makeRequestPost:(NSString *)route WithParameters:(NSDictionary *) paramaters compilation:(DefaultIdResultBlock) compilation {
    
    
    
    //gettoken fonksiyonu yaz nilse @""
    [self setHeader];
    [self POST:route parameters:paramaters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (!responseObject) {
            return compilation( @"Something went wrong try again never :)"  ,  nil);
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
                            return  compilation ( @"Something went wrong try again never :)" , nil);
                        }
                        
                        NSLog(@"Token was expired. Now it renewed and you can make a new post request");
                        
                        [self setHeader];
                        [self POST:route parameters:paramaters success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSLog(@"You made it. Expired token is renewed and the request is made. Good Job.");
                            if (!responseObject) {
                                return compilation(@"Something went wrong try again never :)", nil);
                            }
                            return compilation (nil , responseObject);
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                            NSLog(@"Token expired tried to renew it but it didnt work out sorry :(");
                            return compilation ( @"Something went wrong try again never :)" , nil);
                        }];
                        
                    };
                    return [self retrieveToken:retrieveTokenBlock];
                }
                
                return compilation ( [NSString stringWithFormat:@"%@ - %@" ,code, error] ,nil );
                
            }
        }
        
        return compilation ( nil ,responseObject );
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@" , [error description]);
        NSLog(@"The request is failed due to other problems. Check you internet.");
        return compilation ([error localizedDescription], nil);
    }];
}


-(void)getMallsCallback:(DefaultIdResultBlock)callback {
    
    NSDictionary *parameters = @{
                                 @"info" : @{
                                         @"language" : [[NSLocale preferredLanguages] objectAtIndex:0],
                                         @"device" : @"iOS",
                                         @"deviceModel" : deviceName(),
                                         }
                                 };
    
    [self makeRequestPost:@"v1/malls/" WithParameters:parameters compilation:callback];
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

- (NSDictionary *) getInfoObject   {
    return @{
             @"language" : [[NSLocale preferredLanguages] objectAtIndex:0],
             @"device" : @"iOS",
             @"deviceModel" : deviceName()
             };
}

@end
