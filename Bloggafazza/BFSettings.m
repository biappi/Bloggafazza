//
//  BFSettings.m
//  Bloggafazza
//
//  Created by Antonio Malara on 01/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFSettings.h"

@implementation BFSettings

+ (BFSettings *)settings;
{
  static BFSettings * settings = nil;
  
  if (settings == nil)
    settings = [[BFSettings alloc] init];
  
  return settings;
}

- (NSString *)dataDirectoryPath;
{
  return [[NSUserDefaults standardUserDefaults] stringForKey:@"DataDirectory"];
}

- (void)setDataDirectoryPath:(NSString *)dataDirectoryPath;
{
  [[NSUserDefaults standardUserDefaults] setObject:dataDirectoryPath forKey:@"DataDirectory"];
}

@end