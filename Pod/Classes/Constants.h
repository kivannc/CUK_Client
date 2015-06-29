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
