//
//  BFEntriesCollection.m
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFEntriesCollection.h"
#import "BFAdditions.h"
#import "BFEntry.h"

@implementation BFEntriesCollection

@synthesize entries;

+ (BFEntriesCollection *)entryCollectionFromDirectory:(NSString *)directory error:(NSError **)error;
{
  if (directory == nil)
  {
    if (error != nil)
      *error = [NSError errorWithDomain:@"Settings" code:1 userInfo:nil];
    
    return nil;
  }
  
  NSError * fileError;
  NSArray * entriesFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&fileError];
  
  if (entriesFiles == nil)
  {
    if (error != nil)
      *error = fileError;
    
    return nil;
  }
  
  BFEntriesCollection * zelf = [BFEntriesCollection new];
  
  zelf.entries = [entriesFiles arrayByMappingBlock:
                  ^(NSObject * obj, BOOL * stop)
                  {
                    BFEntry * entry;
                    
                    @autoreleasepool
                    {
                      entry = [BFEntry entryFromFileWithPath:[directory stringByAppendingPathComponent:(NSString *)obj]
                                                       error:nil];
                    }
                    
                    return entry;
                  }];
  return zelf;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"<%@: %p>\n%@", NSStringFromClass([self class]), self, [self.entries description]];
}

@end
