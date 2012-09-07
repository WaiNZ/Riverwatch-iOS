//
//  SimpleHTTPRequest.h
//  TouchMe
//
//  Created by Alex P on 16/11/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimpleHTTPConnection;

@interface SimpleHTTPRequest : NSObject {
	NSDictionary *data;
	NSDictionary *postVars;
	NSDictionary *getVars;
}

- (id)initWithDictionary:(NSMutableDictionary *)dict;

- (NSURL *)url;
- (NSString *)method;
- (NSDictionary *)headers;
- (NSString *)getHeader:(NSString *)byName;
- (NSData *)body;
- (SimpleHTTPConnection *)connection;
- (NSDate *)date;
- (NSString *)postVar:(NSString *)byName;
- (NSString *)getVar:(NSString *)byName;

@end
