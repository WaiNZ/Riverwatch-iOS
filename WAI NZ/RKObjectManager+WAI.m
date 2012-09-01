//
//  RKObjectManager+WAI.m
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "RKObjectManager+WAI.h"

@implementation RKObjectManager (WAI)

- (void)postObjectWithResponse:(id<NSObject>)object usingBlock:(RKObjectLoaderBlock)block {
	[[RKObjectManager sharedManager] postObject:object
									 usingBlock:^(RKObjectLoader *loader) {
										 loader.objectMapping = [self.mappingProvider objectMappingForClass:[object class]];
										 loader.targetObject = nil;
										 block(loader);
									 }];
}
@end
