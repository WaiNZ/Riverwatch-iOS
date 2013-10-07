//
//  NSObject+Async.m
//  WAI NZ
//
//  Created by Melby Ruarus on 4/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "NSObject+Async.h"

#import <dispatch/dispatch.h>

@implementation NSObject (Async)

- (void)accessGetterConcurrently:(SEL)selector withObject:(id)arg onMainThread:(BOOL)mainThread callback:(void (^)(id returnValue))callback {
	dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	// Run on a background thread
	dispatch_async(async, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Call the function
		id returnValue = [self performSelector:selector withObject:arg];
#pragma clang diagnostic pop
		// Call the callback
		if(callback) {
			if(mainThread) {
				dispatch_queue_t main = dispatch_get_main_queue();
				// On the main thread
				dispatch_async(main, ^{
					callback(returnValue);
				});
			}
			else {
				// On the same thread
				callback(returnValue);
			}
		}
	});
}

@end
