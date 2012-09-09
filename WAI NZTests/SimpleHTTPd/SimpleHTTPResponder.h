//
//  HTTPResponder.h
//  TouchMe
//
//  Created by Alex P on 15/11/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SimpleHTTPConnection;
@class SimpleHTTPServer;
@class SimpleHTTPWillRespond;
@class SimpleHTTPRequest;
@class SimpleHTTPResponse;

@protocol SimpleHTTPWillRespond
	- (SimpleHTTPResponse *)processPOST:(SimpleHTTPRequest *)request;
	- (SimpleHTTPResponse *)processGET:(SimpleHTTPRequest *)request;
@end

@interface SimpleHTTPResponder : NSObject {
	unsigned port;
	SimpleHTTPServer *server;
	NSString *webRoot;
	NSString *indexFile;
	id<SimpleHTTPWillRespond> delegate;
	NSNetService *bonjour;
}

- (void)listen:(unsigned)onPort;
- (void)setWebRoot:(NSString *)toPath;
- (void)setIndexFile:(NSString *)fileName;
- (void)setDelegate:(id<SimpleHTTPWillRespond>)respondDelegate;

- (void)startListening;
- (void)stopListening;

- (void)publish:(NSString *)withName;

- (SimpleHTTPResponse *)processPOST:(SimpleHTTPRequest *)request;
- (SimpleHTTPResponse *)processGET:(SimpleHTTPRequest *)request;
- (SimpleHTTPResponse *)processRequest:(SimpleHTTPRequest *)request;
- (NSDictionary *)getFileFromWebRoot:(NSString *)requestedFile;
- (NSString *)getMimeTypeFromFile:(NSString *)filePath;

- (void)stopProcessing;

@end
