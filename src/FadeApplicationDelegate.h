//
//  FadeApplicationDelegate.h
//  fade
//
//  Created by Oliver C Dodd on 2011-01-02.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>
#import "iTunesController.h"
#import "PreferencesController.h"
#import "FadePreferences.h"
#import "FadePreferencesDelegate.h"
#import "FadeHotKeyService.h"

@interface FadeApplicationDelegate : NSObject<NSApplicationDelegate,FadePreferencesDelegate,FadeHotKeyService> {
	IBOutlet NSMenu *menu;
	IBOutlet NSMenuItem *fadeItem;
	
	NSImage *statusImage;
	NSImage *statusHighlightImage;
	
	PreferencesController *preferencesController;
	FadePreferences *preferences;
}
@property(nonatomic,retain) NSMenu *menu;
@property(nonatomic,retain) NSMenuItem *fadeItem;

-(IBAction)toggleFade:(id)sender;
-(IBAction)openPreferences:(id)sender;

@end
