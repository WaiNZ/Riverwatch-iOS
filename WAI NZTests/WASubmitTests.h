//
//  WASubmitTests.h
//  WAI NZ
//
//  Created by Melby Ruarus on 7/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SimpleHTTPd/SimpleHTTPd.h>

@interface WASubmitTests : SenTestCase <SimpleHTTPWillRespond> {
	NSThread *thread;
	NSConditionLock *startLock;
	NSRunLoop *backgroundRunLoop;
	SimpleHTTPResponder *server;
	
	SimpleHTTPResponse *(^currentPOSTExecuter)(SimpleHTTPRequest *);
}

@end
