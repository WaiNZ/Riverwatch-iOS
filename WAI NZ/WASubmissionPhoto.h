//
//  WASubmissionPhoto.h
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WASubmissionPhoto : NSObject 
{
    UIImage *image;
    time_t timestamp;
    CLLocation *location;
}

+ (void)photoWithMediaPickingInfo:(NSDictionary *)dict
					  resultBlock:(void (^)(WASubmissionPhoto *photo))resultBlock
					 failureBlock:(void (^)(NSError *error))failureBlock;

- (id)initWithPhoto:(UIImage *)image timestamp:(time_t)timestamp location:(CLLocation *)location;

@property (readonly) CLLocation *location;
@property (readonly) time_t timestamp;
@property (readonly) UIImage *image;
@end
