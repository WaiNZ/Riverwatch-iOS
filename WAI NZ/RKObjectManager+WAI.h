//
//  RKObjectManager+WAI.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <RestKit/RestKit.h>

/**
 Additions to RKObjectManager specific to the WAI NZ application
 */
@interface RKObjectManager (WAI)

/**
 Post an object using a block to configure the object loader before
 it is sent.
 
 This method is different from those on RKObjectManager as it
 respects object mappings set up based on resource paths using
 setObjectMapping:forResourcePathPattern:
 
 By default postObject... methods on RKObjectManager use the source
 object as the target object when mapping the response, which breaks
 when you are expecting a different class back from what you submitted,
 this method fixes that and lets the restkit normal class matching
 work on responses.
 
 @param object the object to post
 @param block the block that can be used to configure the object loader
 */
- (void)postObjectWithResponse:(id<NSObject>)object usingBlock:(RKObjectLoaderBlock)block;

@end
