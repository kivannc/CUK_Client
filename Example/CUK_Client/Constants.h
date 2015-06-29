//
//  Constants.h
//  CUK_Client
//
//  Created by Kivanc on 18/06/15.
//  Copyright (c) 2015 Kivanc ERTURK. All rights reserved.
//

#ifndef CUK_Client_Constants_h
#define CUK_Client_Constants_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//  BLOCKS

typedef void (^DefaultVoidResultBlock)();
typedef void (^DefaultIdResultBlock)(NSError *error, id responseObject );
typedef void (^DefaultBooleanResultBlock)( NSError *error, BOOL success);

#endif
