//
//  FadePreferences.m
//  fade
//
//  Created by Oliver C Dodd on 2011-01-03.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "FadePreferences.h"
#import <Carbon/Carbon.h>

@interface FadePreferences (Private)

-(NSDictionary *)defaults;

@end


@implementation FadePreferences
@synthesize fadeInTime,fadeOutTime, useHotKey, keyCode, modifierFlags;


- (id)init {
	self = [super init];
	// set prefs
	[[NSUserDefaults standardUserDefaults] registerDefaults:[self defaults]];
	// set parameters
	[self load];
	return self;
}

- (NSDictionary *)defaults {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithDouble:.5],		@"fadeInTime",
			[NSNumber numberWithDouble:.5],		@"fadeOutTime",
			[NSNumber numberWithBool:YES],		@"useHotKey",
			[NSNumber numberWithInteger:49],	@"keyCode",
			[NSNumber numberWithUnsignedInteger:cmdKey+optionKey+controlKey],
												@"modifierFlags",
			nil];
}

- (void)load {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.fadeInTime = [prefs doubleForKey:@"fadeInTime"];
	self.fadeOutTime = [prefs doubleForKey:@"fadeOutTime"];
	self.useHotKey = [prefs boolForKey:@"useHotKey"];
	self.keyCode = [prefs integerForKey:@"keyCode"];
	self.modifierFlags = (NSUInteger)[prefs integerForKey:@"modifierFlags"];
}

- (void)save {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setDouble:self.fadeInTime forKey:@"fadeInTime"];
	[prefs setDouble:self.fadeOutTime forKey:@"fadeOutTime"];
	[prefs setBool:self.useHotKey forKey:@"useHotKey"];
	[prefs setInteger:self.keyCode forKey:@"keyCode"];
	[prefs setInteger:(NSInteger)self.modifierFlags forKey:@"modifierFlags"];
	[prefs synchronize];
}


@end
