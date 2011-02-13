//
//  FadeHotKeyService.h
//  fade
//
//  Created by Oliver C Dodd on 2011-01-15.
//  Copyright 2010 Oliver C Dodd http://01001111.net
//  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//

#import <Cocoa/Cocoa.h>


@protocol FadeHotKeyService

-(void)registerHotKey:(NSInteger)keyCode modifierFlags:(NSUInteger)modifierFlags;
-(void)unregisterHotKey;

@end
