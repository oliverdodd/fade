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

+(void)hotkeyToggleFade;

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
	[self showStatusMenu];
	[self updateFadeItem];
	[self registerHotkeys];
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

/*-----------------------------------------------------------------------------\
 |	private
 \----------------------------------------------------------------------------*/
#pragma mark private

-(void)showStatusMenu {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	
    statusItem = [[statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
	
    [statusItem setTitle: NSLocalizedString(@"f",@"")];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:menu];
}
						
-(void)updateFadeItem {
	NSLog(@"%i",[ctrl isPlaying]);
	[fadeItem setTitle:([ctrl isPlaying]
							? @"Fade Out"
							: @"Fade In")];
}

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {
	[FadeApplicationDelegate hotkeyToggleFade];
	return noErr;
}

-(void)registerHotkeys {
	//Register the Hotkeys
	EventHotKeyRef hkRef;
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	EventHotKeyID hkID;
	hkID.signature='fhk1';
	hkID.id=1;
		
	InstallApplicationEventHandler(&hotKeyHandler,1,&eventType,NULL,NULL);
	
	RegisterEventHotKey(49, cmdKey+optionKey+controlKey, hkID, GetApplicationEventTarget(), 0, &hkRef);
}

/*-----------------------------------------------------------------------------\
 |	dealloc
 \----------------------------------------------------------------------------*/
#pragma mark dealloc

-(void)dealloc {
	[ctrl release];
	[statusItem release];
	[super dealloc];
}

@end
