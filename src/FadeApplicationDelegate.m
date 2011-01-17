//
//  FadeApplicationDelegate.m
//  fade
//
//  Created by Oliver C Dodd on 2011-01-02.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "FadeApplicationDelegate.h"
#import <Carbon/Carbon.h>


@interface FadeApplicationDelegate(Private)

-(void)showStatusMenu;
-(void)updateFadeItem;
-(void)registerHotkeys;

@end

static iTunesController *gctrl = nil;

@implementation FadeApplicationDelegate
@synthesize menu, fadeItem;

iTunesController *ctrl;
NSStatusItem *statusItem;

/*-----------------------------------------------------------------------------\
 |	events
 \----------------------------------------------------------------------------*/
#pragma mark events

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
	ctrl = [[iTunesController alloc] init];
	gctrl = ctrl;
	preferences = [[FadePreferences alloc] init];
	[self showStatusMenu];
	[self updateFadeItem];
	[self preferencesDidUpdate:self];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
	[self unregisterHotKey];
}

-(void)menuWillOpen:(NSMenu *)theMenu {
	[self updateFadeItem];
}

-(IBAction)toggleFade:(id)sender {
	[ctrl fadeToggle];
}

+(void)hotkeyToggleFade {
	[gctrl fadeToggle];
}

-(IBAction)openPreferences:(id)sender {
	if (preferencesController == nil) {
		preferencesController = [[PreferencesController alloc] initWithPreferences:preferences delegate:self];
	}
	[preferencesController showWindow:sender];
	NSWindow *window = [preferencesController window];
	[window makeKeyAndOrderFront:self];
	(void)sender;
}

-(void)preferencesDidUpdate:(id)sender {
	// fade
	[ctrl setFadeInTime:preferences.fadeInTime];
	[ctrl setFadeOutTime:preferences.fadeOutTime];
	// hotkey
	[self unregisterHotKey];
	if (preferences.useHotKey && preferences.keyCode > 0 && preferences.modifierFlags >= 0) {
		[self registerHotKey:preferences.keyCode modifierFlags:preferences.modifierFlags];
	}
}

/*-----------------------------------------------------------------------------\
 |	hotkey
 \----------------------------------------------------------------------------*/
#pragma mark hotkey

OSType fhkSignature = 'fhk1';
OSType fhkId = 1;
EventHandlerRef ehRef;
EventHotKeyRef hkRef;

static OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {
	[FadeApplicationDelegate hotkeyToggleFade];
	return noErr;
}

-(void)registerHotKey:(NSInteger)keyCode modifierFlags:(NSUInteger)modifierFlags {
	//Register the Hotkey
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	EventHotKeyID hkID;
	hkID.signature = fhkSignature;
	hkID.id = fhkId;
	
	InstallEventHandler(GetApplicationEventTarget(), &hotKeyHandler, 1, &eventType, NULL, &ehRef);
	RegisterEventHotKey(keyCode, modifierFlags, hkID, GetApplicationEventTarget(), 0, &hkRef);
}

-(void)unregisterHotKey {
	UnregisterEventHotKey(hkRef);
	RemoveEventHandler(ehRef);
}


/*-----------------------------------------------------------------------------\
 |	status menu
 \----------------------------------------------------------------------------*/
#pragma mark status menu

-(void)showStatusMenu {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	
    NSBundle *bundle = [NSBundle mainBundle];
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"fader_sound_volume" ofType:@"png"]];
	statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"fader_sound_volume2" ofType:@"png"]];
	
	statusItem = [[statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
    //[statusItem setTitle: NSLocalizedString(@"f",@"")];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menu];
}
						
-(void)updateFadeItem {
	[fadeItem setTitle:([ctrl isPlaying]
							? @"Fade Out"
							: @"Fade In")];
}

/*-----------------------------------------------------------------------------\
 |	dealloc
 \----------------------------------------------------------------------------*/
#pragma mark dealloc

-(void)dealloc {
	[ctrl release];
	[statusItem release];
	[preferences release];
	[super dealloc];
}

@end
