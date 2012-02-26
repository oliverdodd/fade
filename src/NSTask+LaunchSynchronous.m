//
//  NSTask+launchSynchronous.m
//
//  Created by Oliver C Dodd on 2010-05-16.
//  Copyright 2010 Oliver C Dodd. All rights reserved.
//

#import "NSTask+LaunchSynchronous.h"

@implementation NSTask (LaunchSynchronous)

- (NSString *)launchSynchronous {
	// io
    [self setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
	NSPipe *pipe = [NSPipe pipe];
    [self setStandardOutput: pipe];
	[self setStandardError: pipe];
    NSFileHandle *pipeFile = [pipe fileHandleForReading];
	//launch
	[self launch];
	// synchronous output
	return [[[NSString alloc] initWithData:[pipeFile readDataToEndOfFile] 
								  encoding:NSUTF8StringEncoding] autorelease];
}

@end
