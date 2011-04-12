//
//  NSTImer+Extensions.h
//  LittleLamb
//
//  Created by Corey Floyd on 4/12/11.
//  Copyright 2011 Flying Jalapeño. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (Extensions)

+ (void)addTimer:(NSTimer*)timer forKey:(NSString*)key;

+ (NSTimer*)timerForKey:(NSString*)key;

+ (void)stopTimerForKey:(NSString*)key;

@end
