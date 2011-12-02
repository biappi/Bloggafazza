//
//  BFSettings.h
//  Bloggafazza
//
//  Created by Antonio Malara on 01/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFSettings : NSObject

@property(nonatomic, strong) NSString * dataDirectoryPath;
@property(nonatomic, strong) NSString * outputDirectoryPath;
@property(nonatomic, strong) NSString * templateDirectoryPath;

+ (BFSettings *)settings;

@end
