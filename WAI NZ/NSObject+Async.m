//
//  NSObject+Async.m
//  77 Pieces
//
//  Created by Melby Ruarus on 4/09/12.
//  Copyright (c) 2012 77 Pieces. All rights reserved.
//

#import "NSObject+Async.h"

#import <dispatch/dispatch.h>

@implementation NSObject (Async)

- (void)accessGetterConcurrently:(SEL)selector withObject:(id)arg onMainThread:(BOOL)mainThread callback:(void (^)(id returnValue))callback {
	dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(async, ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		id returnValue = [self performSelector:selector withObject:arg];
#pragma clang diagnostic pop
		if(callback) {
			if(mainThread) {
				dispatch_queue_t main = dispatch_get_main_queue();
				dispatch_async(main, ^{
					callback(returnValue);
				});
			}
			else {
				callback(returnValue);
			}
		}
	});
}

@end
