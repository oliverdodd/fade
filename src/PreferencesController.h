//
//  PreferencesController.h
//  fade
//
//  Created by Oliver C Dodd on 2011-01-03.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "FadePreferences.h"
#import "FadePreferencesDelegate.h"


@interface PreferencesController : NSWindowController {
	IBOutlet NSSlider *fadeInSlider;
	IBOutlet NSSlider *fadeOutSlider;
	
	IBOutlet NSTextField *fadeInLabel;
	IBOutlet NSTextField *fadeOutLabel;
	
	IBOutlet NSButton *enableShortcutButton;
	IBOutlet SRRecorderControl *shortcutRecorder;
	
	IBOutlet NSButton *addLoginItemButton;
	
	FadePreferences *preferences;
	id<FadePreferencesDelegate> preferencesDelegate;
}
@property(nonatomic, retain) FadePreferences *preferences;
@property(nonatomic,retain) NSSlider *fadeInSlider;
@property(nonatomic,retain) NSSlider *fadeOutSlider;
@property(nonatomic,retain) NSTextField *fadeInLabel;
@property(nonatomic,retain) NSTextField *fadeOutLabel;
@property(nonatomic,retain) NSButton *enableShortcutButton;
@property(nonatomic,retain) SRRecorderControl *shortcutRecorder;
@property(nonatomic,retain) NSButton *addLoginItemButton;

- (id)initWithPreferences:(FadePreferences *)prefs delegate:(id<FadePreferencesDelegate>)delegate;

- (IBAction)performOk:(id)sender;
- (IBAction)performCancel:(id)sender;

@end
