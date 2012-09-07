//
//  SimpleHTTPServer.h
//
//  Created by Jürgen on 19.09.06.
//  Copyright 2006 Cultured Code.
//  License: Creative Commons Attribution 2.5 License
//           http://creativecommons.org/licenses/by/2.5/
//

#import <Foundation/Foundation.h>

@class SimpleHTTPConnection;
@class SimpleHTTPResponder;
@class SimpleHTTPRequest;
@class SimpleHTTPResponse;

@interface SimpleHTTPServer : NSObject {
    unsigned port;
    SimpleHTTPResponder *delegate;

    NSFileHandle *fileHandle;
    NSMutableArray *connections;
    NSMutableArray *requests;    
    SimpleHTTPRequest *currentRequest;
}

- (id)initWithTCPPort:(unsigned)po delegate:(SimpleHTTPResponder *)dl;

- (NSArray *)connections;
- (NSArray *)requests;

- (void)closeConnection:(SimpleHTTPConnection *)connection;
- (void)newRequestWithURL:(NSURL *)url method:(NSString *)method body:(NSData *)body headers:(NSDictionary *)headers connection:(SimpleHTTPConnection *)connection;

// Request currently being processed
// Note: this need not be the most recently received request
- (SimpleHTTPRequest *)currentRequest;
- (void)processResponse:(SimpleHTTPResponse *)response;

@end
