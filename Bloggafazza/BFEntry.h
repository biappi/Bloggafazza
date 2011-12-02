//
//  BFEntry.h
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFEntry : NSObject

@property(nonatomic, strong) NSString * title;
@property(nonatomic, strong) NSString * slug;
@property(nonatomic, strong) NSDate   * date;
@property(nonatomic, strong) NSString * body;

+ (BFEntry *)entryFromFileWithPath:(NSString *)path error:(NSError **)error;

@end
