//
//  SimpleHTTPResponder.m
//  TouchMe
//
//  Created by Alex P on 15/11/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SimpleHTTPResponder.h"
#import "SimpleHTTPConnection.h"
#import "SimpleHTTPServer.h"
#import "SimpleHTTPRequest.h"
#import "SimpleHTTPResponse.h"

static NSDictionary *simpleHTTPd_mimeTypes = nil;

@implementation SimpleHTTPResponder

+ (void)initialize
{
	simpleHTTPd_mimeTypes = [NSDictionary dictionaryWithObjectsAndKeys:
										   @"text/html", @"html",
										   @"text/html", @"htm",
										   @"application/x-javascript", @"js",
										   @"text/css", @"css",
										   @"image/png", @"png",
										   @"image/gif", @"gif",
										   @"image/jpg", @"jpg",
										   @"image/x-icon", @"ico",
										   nil
	];
}

- (void)listen:(unsigned)onPort
{
	port = onPort;
}

- (void)setWebRoot:(NSString *)toPath
{
	webRoot = toPath;
}

- (void)setIndexFile:(NSString *)fileName
{
	indexFile = fileName;
}

- (void)setDelegate:(id<SimpleHTTPWillRespond>)respondDelegate
{
	delegate = respondDelegate;
}

- (void)startListening
{
	server = [[SimpleHTTPServer alloc] initWithTCPPort:port delegate:self];
}

- (void)stopListening
{
	
}

- (void)publish:(NSString *)withName
{
	bonjour = [[NSNetService alloc] initWithDomain:@"" type:@"_http._tcp." name:withName port:port];
	[bonjour publish];
}

- (SimpleHTTPResponse *)processPOST:(SimpleHTTPRequest *)request
{
	if(delegate != nil) {
		return [delegate processPOST:request];
	}
	
	return [self processRequest:request];
}

- (SimpleHTTPResponse *)processGET:(SimpleHTTPRequest *)request
{
	if(delegate != nil) {
		return [delegate processGET:request];
	}
		
	return [self processRequest:request];
}

- (SimpleHTTPResponse *)processRequest:(SimpleHTTPRequest *)request
{
	SimpleHTTPResponse *response = [[SimpleHTTPResponse alloc] init];
	
	if(webRoot != nil) {
		NSDictionary *fileData;
		NSString *fileName = [[request url] absoluteString];
		NSArray *substrings = [fileName componentsSeparatedByString:@"?"];
				
		if([substrings count] > 1) { // parse out query strings
			fileName = [substrings objectAtIndex:0];
		}
		
		fileData = [self getFileFromWebRoot:fileName];
		
		if([fileData objectForKey:@"error"] != nil) {
			[response setResponseCode:404];
			[response setContentString:[fileData objectForKey:@"error"]];
		} else {
			[response setContentType:[fileData objectForKey:@"mimeType"]];
			[response setContent:[fileData objectForKey:@"data"]];
		}
	} else {
		[response setResponseCode:404];
		[response setContentString:@"Handler not found."];
	}
	
	return response;
}

- (void)stopProcessing
{
	
}

- (NSDictionary *)getFileFromWebRoot:(NSString *)requestedFile
{
	NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
	
	if(webRoot != nil) {
		NSString *path = [webRoot stringByAppendingString:requestedFile];
		//NSLog(@"file requested was %@", path);
		if(![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
			//NSLog(@"Could not read file %@", path);
			[output setObject:@"Cannot read file" forKey:@"error"];
			return output;
		}
		
		BOOL isDirectory = false;
		
		if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
			//NSLog(@"Could not find file %@", path);
			[output setObject:@"File not found" forKey:@"error"];
			return output;
		}
		
		if(isDirectory) {
			//NSLog(@"File is directory %@", path);
			
			if(indexFile != nil) {
				if([[requestedFile substringFromIndex:[requestedFile length] - 1] isEqualToString:@"/"]) {
					return [self getFileFromWebRoot:[requestedFile stringByAppendingString:indexFile]];
				}
				
				return [self getFileFromWebRoot:[requestedFile stringByAppendingString:[@"/" stringByAppendingString:indexFile]]];
			}
			
			[output setObject:@"Directory index not permitted" forKey:@"error"];
			return output;
		}
		
		//NSLog(@"Sending file %@ with mimetype %@", path, [self getMimeTypeFromFile:path]);
		[output setObject:[NSData dataWithContentsOfFile:path] forKey:@"data"];
		[output setObject:[self getMimeTypeFromFile:path] forKey:@"mimeType"];
	} else {
		[output setObject:@"Webroot not set" forKey:@"error"];
	}
	
	return output;
}

- (NSString *)getMimeTypeFromFile:(NSString *)filePath
{
	NSArray *fileNameParts = [filePath componentsSeparatedByString:@"."];
	NSString *extension = [fileNameParts objectAtIndex:[fileNameParts count] -1];
	
	if([simpleHTTPd_mimeTypes objectForKey:extension] != nil) {
		return [simpleHTTPd_mimeTypes objectForKey:extension];
	}
	
	return @"application/octet-stream";
}

@end
