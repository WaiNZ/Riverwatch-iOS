//
//  NSObject+Async.h
//  77 Pieces
//
//  Created by Melby Ruarus on 4/09/12.
//  Copyright (c) 2012 77 Pieces. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Async)

- (void)accessGetterConcurrently:(SEL)selector withObject:(id)arg onMainThread:(BOOL)mainThread callback:(void (^)(id returnValue))callback;

@end
