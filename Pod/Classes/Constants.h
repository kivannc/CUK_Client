//
//  Constants.h
//  CUK_Client
//
//  Created by Kivanc on 18/06/15.
//  Copyright (c) 2015 Kivanc ERTURK. All rights reserved.
//


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//  BLOCKS

typedef void (^DefaultVoidResultBlock)();
typedef void (^DefaultIdResultBlock)(NSString *error, id responceObject );
typedef void (^DefaultBooleanResultBlock)( NSString *error, BOOL success);

#define USER_TOKEN @"USER_TOKEN"
#define TOKEN_ERROR 8003

static NSString * const MallframeItApiKey = @"<#PUT YOUR KEY HERE#>";

static NSString * const MallframeItURL = @"<#PUT YOUR URL HERE#>";
