//
//  CUK_CLilent_Constans.h
//  Pods
//
//  Created by Kivanc on 18/06/15.
//
//
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#ifndef Pods_CUK_CLilent_Constans_h
#define Pods_CUK_CLilent_Constans_h




//  BLOCKS

typedef void (^DefaultVoidResultBlock)();
typedef void (^DefaultIdResultBlock)(NSError *error, id responceObject );
typedef void (^DefaultBooleanResultBlock)( NSError *error, BOOL success);

#endif
