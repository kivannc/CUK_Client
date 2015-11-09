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
typedef void (^DefaultIdResultBlock)(NSString *error, id responseObject );
typedef void (^DefaultBooleanResultBlock)( NSString *error, BOOL success);

#define USER_TOKEN @"USER_TOKEN"
#define TOKEN_ERROR 8003


static NSString * const MallframeItApiKey = @"AA3XYDCC-D3A7-4B22-B5C8-5A6356977240";

static NSString * const MallframeItURL = @"https://api.mallframe.com/";
