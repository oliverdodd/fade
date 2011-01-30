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
#import <ShortcutRecorder/SRCommon.h>


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
	// Ignore if iTunes is not running.  This is an application level decision,
	// the control will open iTunes and fade in if iTunes is not running.
	if ([gctrl isRunning])
		[gctrl fadeToggle];
}

-(IBAction)openPreferences:(id)sender {
	if (preferencesController == nil) {
		preferencesController = [[PreferencesController alloc] initWithPreferences:preferences delegate:self];
	}
	[preferencesController showWindow:sender];
	NSWindow *window = [preferencesController window];
	[window orderFront:sender];
}

-(void)preferencesDidUpdate:(id)sender {
	// fade
	[ctrl setFadeInTime:preferences.fadeInTime];
	[ctrl setFadeOutTime:preferences.fadeOutTime];
	// hotkey
	[self unregisterHotKey];
	if (preferences.useHotKey && preferences.keyCode > 0 && preferences.modifierFlags >= 0) {
		[self registerHotKey:preferences.keyCode modifierFlags:preferences.modifierFlags];
		
		[fadeItem setKeyEquivalent:SRCharacterForKeyCodeAndCocoaFlags(preferences.keyCode, preferences.modifierFlags)];
		[fadeItem setKeyEquivalentModifierMask:SRCarbonToCocoaFlags(preferences.modifierFlags)];
	}
	// login item
	if (preferences.addLoginItem) {
		[self addLoginItem];
	} else {
		[self removeLoginItem];
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
	
	[menu setAutoenablesItems:NO];
}
						
-(void)updateFadeItem {
	[fadeItem setTitle:(![ctrl isRunning] || ![ctrl isPlaying]
						? @"Fade In"
						: @"Fade Out")];
	[fadeItem setEnabled:[ctrl isRunning]];
}

/*-----------------------------------------------------------------------------\
 |	login item (http://cocoatutorial.grapewave.com/tag/lssharedfilelist-h/)
 \----------------------------------------------------------------------------*/
#pragma mark login item

-(void) addLoginItem {
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]; 
	
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	if (loginItems) {
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
																	 kLSSharedFileListItemLast,
																	 NULL, NULL,url, NULL, NULL);
		if (item){
			CFRelease(item);
		}
	}	
	
	CFRelease(loginItems);
}

-(void) removeLoginItem {
	NSString *path = [[NSBundle mainBundle] bundlePath];
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:path]; 
	
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	if (loginItems) {
		UInt32 seed;
		NSArray  *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seed);
		
		int i = 0;
		for(i; i< [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)[loginItemsArray
																		objectAtIndex:i];
			
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(NSURL*)url path];
				if ([urlPath compare:path] == NSOrderedSame){
					LSSharedFileListItemRemove(loginItems,itemRef);
				}
			}
		}
		[loginItemsArray release];
	}
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
