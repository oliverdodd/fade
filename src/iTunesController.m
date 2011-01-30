//
//  iTunesController.m
//  fade
//
//  Created by Oliver C Dodd on 2011-01-02.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import "iTunesController.h"

@interface iTunesController(Private)

-(void)fade:(NSNumber *)d;
-(void)cancelFade;
-(void)preFade;
-(int)calculateDelta:(double)time;

@end



@implementation iTunesController

/*-----------------------------------------------------------------------------\
 |	vars
 \----------------------------------------------------------------------------*/
#pragma mark vars
const int MIN_VOL = 0;
const int MAX_VOL = 100;

NSTimeInterval timeInterval = .05;
int deltaVolumeIn = 10;
int deltaVolumeOut = 10;

double fadeInTime = .5;
double fadeOutTime = .5;

int originalVolume;
BOOL isFading = NO;
iTunesApplication *iTunes;


/*-----------------------------------------------------------------------------\
 |	init
 \----------------------------------------------------------------------------*/
#pragma mark init

-(id)init {
	if (self = [super init]) {
		iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
		originalVolume = MAX_VOL;
	}
	return self;
}


/*-----------------------------------------------------------------------------\
 |	controls
 \----------------------------------------------------------------------------*/
#pragma mark controls

-(void)playPause {
	[iTunes playpause];
}

-(bool)isPlaying {
	return [iTunes playerState] == iTunesEPlSPlaying;
}

-(bool)isRunning {
	return [iTunes isRunning];
}

-(int)volume {
	return [iTunes soundVolume];
}

-(void)setVolume:(int)vol {
	[iTunes setSoundVolume:vol];
}

/*-----------------------------------------------------------------------------\
 |	fade
 \----------------------------------------------------------------------------*/
#pragma mark fade
-(void)fadeIn {
	[self preFade];
	[self setVolume:MIN_VOL];
	[self fade:[NSNumber numberWithInt: FADE_IN]];
}

-(void)fadeOut {
	[self preFade];
	[self fade:[NSNumber numberWithInt: FADE_OUT]];
}

-(void)fadeToggle {
	if ([self isPlaying])
        [self fadeOut];
    else
        [self fadeIn];
}

-(void)fade:(NSNumber *)fadeDirection {
	isFading = YES;
	int d = fadeDirection.intValue;
	int v = [self volume];
    
	if (v == 0) {
        [self playPause];
    }
    
    if ((d > 0 && v < originalVolume) || (d < 0 && v != 0)) {
		NSLog(@"%d",v);
		int deltaVolume = d > 0 ? deltaVolumeIn : deltaVolumeOut;
		[self setVolume:(v + d * deltaVolume)];
		[self performSelector:@selector(fade:) withObject:fadeDirection afterDelay:timeInterval]; 
    } else {
		[self setVolume:originalVolume];
		isFading = NO;
    }
}

-(void)cancelFade {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	isFading = NO;
}

-(void)preFade {
	if (!isFading) {
		originalVolume = [self volume];
		deltaVolumeIn = [self calculateDelta:fadeInTime];
		deltaVolumeOut = [self calculateDelta:fadeOutTime];
	}
	[self cancelFade];
}

-(int)calculateDelta:(double)time {
	if (time <= 0) {
		return MAX_VOL;
	} else {
		double units = time / timeInterval;
		return ceil(originalVolume/units);
	}
}

-(void)setFadeInTime:(double)time {
	fadeInTime = time;
}

-(void)setFadeOutTime:(double)time {
	fadeOutTime = time;
}

@end
