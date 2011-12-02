//
//  main.m
//  Bloggafazza
//
//  Created by Antonio Malara on 01/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFSettings.h"
#import "BFEntriesCollection.h"

int main (int argc, const char * argv[])
{
  @autoreleasepool
  {
    NSError * error;
    NSString * dataDirectory = [BFSettings settings].dataDirectoryPath;
    if (dataDirectory == nil)
    {
      NSLog(@"DataDirectory not set - The directory with the entries");
      return 1;
    }
    
    BFEntriesCollection * collection = [BFEntriesCollection entryCollectionFromDirectory:dataDirectory
                                                                                   error:&error];
    if (collection == nil)
    {
      NSLog(@"%@", [error localizedDescription]);
      return 1;
    }
    
    NSLog(@"%@", collection);
  }
  
  return 0;
}
