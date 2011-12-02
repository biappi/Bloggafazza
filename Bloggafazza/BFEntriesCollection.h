//
//  BFEntriesCollection.h
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFEntriesCollection : NSObject

@property(nonatomic, strong) NSArray * entries;

+ (BFEntriesCollection *)entryCollectionFromDirectory:(NSString *)directory error:(NSError **)error;

@end
