//
//  iTunesController.h
//  fade
//
//  Created by Oliver C Dodd on 2011-01-02.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"


@interface iTunesController : NSObject {
	enum {FADE_IN = 1, FADE_OUT = -1} FadeDirection;
}
@property(nonatomic) int volume;

-(void)playPause;
-(bool)isPlaying;


-(void)fadeIn;
-(void)fadeOut;
-(void)fadeToggle;

@end
