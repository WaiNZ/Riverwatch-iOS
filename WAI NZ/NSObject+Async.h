//
//  NSObject+Async.h
//  WAI NZ
//
//  Created by Melby Ruarus on 4/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Additions to NSObject to assist with accessing methods that can take
 a significant amount of time to return by using background threads for
 loading
 */
@interface NSObject (Async)

/**
 Access the specified method in a background thread and return the
 result via a block callback.
 
 The callback can either be executed on the same background thread
 as the property was accessed on, or can be called on the main thread.
 
 Using the main thread will elliminate most multithreading and concurrent
 access problems.
 
 This method returns immediatly.
 
 The method specified by selector must have at most one argument.
 
 @param selector the selector of the method to call on th backrgound thread
 @param arg an optional argument to the method, may be nil if the selector doesn't take any arguments
 @param mainThread whether the callback should be executed on the main thread
 @param callback the block to call once the method has returned, takes one argument which is the return result of the method specified by selector
 */
- (void)accessGetterConcurrently:(SEL)selector withObject:(id)arg onMainThread:(BOOL)mainThread callback:(void (^)(id returnValue))callback;

@end