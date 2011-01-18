//
//  PreferencesController.m
//  fade
//
//  Created by Oliver C Dodd on 2011-01-03.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "PreferencesController.h"

@interface PreferencesController (Private)

-(void)updateInputFields;

@end

@implementation PreferencesController
@synthesize fadeInSlider, fadeOutSlider, fadeInLabel, fadeOutLabel, 
	enableShortcutButton, shortcutRecorder;

- (id)initWithPreferences:(FadePreferences *)prefs delegate:(id<FadePreferencesDelegate>)delegate {
	self = [self initWithWindowNibName:@"Preferences"];
	if (![self isWindowLoaded]) {
		[[self window] center];
		[[self window] setLevel:NSFloatingWindowLevel];
	}
	preferencesDelegate = delegate;
	[self setPreferences:prefs];
	
	// set up shortcut recorder
	[shortcutRecorder setAllowsKeyOnly:NO escapeKeysRecord:NO];
	
	return self;
}

- (FadePreferences *) preferences {
	return preferences;
}

- (void)setPreferences:(FadePreferences *) prefs {
	preferences = prefs;
	[self updateInputFields];
}

-(void)updateInputFields {
	[self.fadeInSlider setDoubleValue:preferences.fadeInTime];
	[self.fadeInLabel setDoubleValue:preferences.fadeInTime];
	[self.fadeOutSlider setDoubleValue:preferences.fadeOutTime];
	[self.fadeOutLabel setDoubleValue:preferences.fadeOutTime];
	
	KeyCombo keyCombo;
	keyCombo.code = preferences.keyCode;
	keyCombo.flags = [shortcutRecorder carbonToCocoaFlags: preferences.modifierFlags];
	
	[self.shortcutRecorder setKeyCombo:keyCombo];
}

- (IBAction)performOk:(id)sender {
	preferences.fadeInTime = [self.fadeInSlider doubleValue];
	preferences.fadeOutTime = [self.fadeOutSlider doubleValue];
	preferences.useHotKey = [self.enableShortcutButton  state] == NSOnState ? YES : NO;
	
	KeyCombo keyCombo = [self.shortcutRecorder keyCombo];
	preferences.keyCode = keyCombo.code;
	preferences.modifierFlags = [shortcutRecorder cocoaToCarbonFlags: keyCombo.flags];
	
	[preferences save];
	[preferencesDelegate preferencesDidUpdate:self];
	
	[self close];	 
}

- (IBAction)performCancel:(id)sender {
	[self updateInputFields];
	[self close];
}

@end
