//
//  BFSettings.h
//  Bloggafazza
//
//  Created by Antonio Malara on 01/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFSettings : NSObject

@property(nonatomic, retain) NSString * dataDirectoryPath;

+ (BFSettings *)settings;

@end
