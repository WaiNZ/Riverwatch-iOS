//
//  RKObjectManager+WAI.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface RKObjectManager (WAI)

- (void)postObjectWithResponse:(id<NSObject>)object usingBlock:(RKObjectLoaderBlock)block;

@end
