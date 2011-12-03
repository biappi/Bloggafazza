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
#import "BFTemplate.h"
#import "BFSiteBuilder.h"

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
    
    NSString * templatePath = [BFSettings settings].templateDirectoryPath;
    if (templatePath == nil)
    {
      NSLog(@"TemplateDirectory not set - The directory with the template files");
      return 1;
    }
    
    BFTemplate * template = [BFTemplate templateFromDirectory:templatePath error:&error];
    
    if (template == nil)
    {
      NSLog(@"%@", [error localizedDescription]);
      return 1;
    }
    
    NSString * outputPath = [BFSettings settings].outputDirectoryPath;
    if (outputPath == nil)
    {
      NSLog(@"OutputDirectory not set - The directory in which to store the output");
      return 1;
    }
    
    NSString * resourcesPath = [BFSettings settings].resourcesDirectoryPath;
    if (resourcesPath != nil)
    {
      for (NSString * file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcesPath error:nil])
      {
        NSError  * err;
        NSString * src = [resourcesPath stringByAppendingPathComponent:file];
        NSString * dst = [outputPath stringByAppendingPathComponent:file];
        
        if (![[NSFileManager defaultManager] removeItemAtPath:dst error:&err])
          NSLog(@"%@", [err localizedDescription]);
        
        if (![[NSFileManager defaultManager] copyItemAtPath:src
                                                     toPath:dst
                                                      error:&err])
        {
          NSLog(@"%@", [err localizedDescription]);
        }
      }
    }
    
    BFSiteBuilder * siteBuilder = [BFSiteBuilder siteBuilderWithOutputDir:outputPath entriesSubdir:@"entries" template:template];
    BOOL success = [siteBuilder renderEntryCollection:collection error:&error];
    
    if (success == NO)
    {
      NSLog(@"%@", [error localizedDescription]);
      return 1;
    }
  }
  
  return 0;
}
