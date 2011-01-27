//
//  FadePreferences.h
//  fade
//
//  Created by Oliver C Dodd on 2011-01-03.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>


@interface FadePreferences : NSObject {
	double fadeInTime;
	double fadeOutTime;
	
	Boolean useHotKey;
	NSInteger keyCode;
	NSUInteger modifierFlags;
	
	Boolean addLoginItem;
}
@property(nonatomic) double fadeInTime;
@property(nonatomic) double fadeOutTime;
@property(nonatomic) Boolean useHotKey;
@property(nonatomic) NSInteger keyCode;
@property(nonatomic) NSUInteger modifierFlags;
@property(nonatomic) Boolean addLoginItem;

- (void)load;
- (void)save;

@end
