//
//  SimpleHTTPResponse.m
//  TouchMe
//
//  Created by Alex P on 16/11/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SimpleHTTPResponse.h"

@implementation SimpleHTTPResponse

- (id)init
{
	if(self = [super init]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
		
		data = [[NSMutableDictionary dictionaryWithObjectsAndKeys:
			[NSMutableDictionary dictionaryWithObjectsAndKeys:
				@"text/html", @"Content-type",
				[dateFormatter stringFromDate:[NSDate date]], @"Date",
				[dateFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:10]], @"Expires",
				@"SimpleHTTPd", @"Server",
				nil
			], @"headers",
			[NSNumber numberWithInt:200], @"code",
			[NSData data], @"content",
			nil
		] retain];
	}
	
	return self;
}

- (void)dealloc {
    [data release];
    
    [super dealloc];
}

- (void)addHeader:(NSString *)key withValue:(NSString *)value
{
	[[data objectForKey:@"headers"] setValue:value forKey:key];
}

- (NSDictionary *)headers
{
	return [data objectForKey:@"headers"];
}

- (void)setContentType:(NSString *)mimeType
{
	[[data objectForKey:@"headers"] setValue:mimeType forKey:@"Content-type"];
}

- (NSString *)contentType
{
	return [[data objectForKey:@"headers"] objectForKey:@"Content-type"];
}

- (void)setResponseCode:(int)code
{
	[data setObject:[NSNumber numberWithInt:code] forKey:@"code"];
}

- (int)responseCode
{
	return [[data objectForKey:@"code"] intValue];
}

- (void)setContent:(NSData *)toData
{
	[data setObject:toData forKey:@"content"];
}

- (void)setContentString:(NSString *)toString
{
	[data setObject:[toString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] forKey:@"content"];
}

- (NSData *)content
{
	return [data objectForKey:@"content"];
}

@end
