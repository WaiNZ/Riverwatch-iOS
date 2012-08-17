//
//  WASubmissionPhoto.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionPhoto.h"

@implementation WASubmissionPhoto

- (id)initWithPhoto:(UIImage *)photo timestamp:(time_t)time location:
    (CLLocation *)loc {
    self = [super init];
    if (self) {
        image = photo;
        timestamp = time;
        location = loc;
    }
    return self;
}

@end
