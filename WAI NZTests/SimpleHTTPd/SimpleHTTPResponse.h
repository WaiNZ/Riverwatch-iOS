//
//  SimpleHTTPResponse.h
//  TouchMe
//
//  Created by Alex P on 16/11/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleHTTPResponse : NSObject {
	NSMutableDictionary *data;
}

- (void)addHeader:(NSString *)key withValue:(NSString *)value;
- (NSDictionary *)headers;

- (void)setContentType:(NSString *)mimeType;
- (NSString *)contentType;

- (void)setResponseCode:(int)code;
- (int)responseCode;

- (void)setContent:(NSData *)toData;
- (void)setContentString:(NSString *)toString;
- (NSData *)content;

@end
