//
//  BFTemplate.h
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFEntry.h"

@interface BFTemplate : NSObject

+ (BFTemplate *)templateFromDirectory:(NSString *)directory error:(NSError **)error;

- (NSString *)renderEntry:(BFEntry *)entry;
- (NSString *)renderPage:(NSString *)content;

@end
