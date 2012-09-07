//
//  SimpleHTTPConnection.h
//  SimpleCocoaHTTPServer
//
//  Created by Jürgen Schweizer on 13.09.06.
//  Copyright 2006 Cultured Code.
//  License: Creative Commons Attribution 2.5 License
//           http://creativecommons.org/licenses/by/2.5/
//

#import <Foundation/Foundation.h>


@interface SimpleHTTPConnection : NSObject {
    NSFileHandle *fileHandle;
    id delegate;
    NSString *address;  // client IP address
	
    CFHTTPMessageRef message;
    BOOL isMessageComplete;
	
	NSMutableData *messageBuffer;
}

- (id)initWithFileHandle:(NSFileHandle *)fh delegate:(id)dl;
- (NSFileHandle *)fileHandle;

- (void)setAddress:(NSString *)value;
- (NSString *)address;

@end
