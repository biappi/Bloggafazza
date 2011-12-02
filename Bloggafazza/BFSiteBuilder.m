//
//  BFSiteBuilder.m
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFSiteBuilder.h"
#import "BFEntry.h"

@interface BFSiteBuilder ()

@property(nonatomic, strong) NSString   * outputDir;
@property(nonatomic, strong) NSString   * entriesSubdir;
@property(nonatomic, strong) BFTemplate * template;

- (NSString *)renderEntry:(BFEntry *)entry error:(NSError **)error;

@end

@implementation BFSiteBuilder

@synthesize outputDir;
@synthesize entriesSubdir;
@synthesize template;

+ (BFSiteBuilder *)siteBuilderWithOutputDir:(NSString *)outputDir entriesSubdir:(NSString *)entriesSubdir template:(BFTemplate *)template;
{
  BFSiteBuilder * zelf = [BFSiteBuilder new];
  zelf.outputDir = outputDir;
  zelf.entriesSubdir = entriesSubdir;
  zelf.template = template;
  return zelf;
}

- (BOOL)renderEntryCollection:(BFEntriesCollection *)collection error:(NSError **)error;
{
  NSError * localError;
  NSMutableArray * renderedEntries = [NSMutableArray arrayWithCapacity:collection.entries.count];
  
  if ([[NSFileManager defaultManager] createDirectoryAtPath:self.outputDir withIntermediateDirectories:YES attributes:nil error:&localError] == NO)
  {
    if (error != nil) *error = localError;
    return NO;    
  }
  
  for (BFEntry * entry in collection.entries)
  {
    NSString * entryString = [self renderEntry:entry error:&localError];
    
    if (entryString == nil)
    {
      if (error != nil) *error = localError;
      return NO;
    }
    
    [renderedEntries addObject:entryString];
  }
  
  NSString * indexString = [self.template renderPage:[renderedEntries componentsJoinedByString:@"\n"]];
  NSString * filePath    = [self.outputDir stringByAppendingPathComponent:@"index.html"];
  
  if ([indexString writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&localError] == NO)
  {
    if (error) *error = localError;
    return NO;
  }
  
  return YES;
}

- (NSString *)renderEntry:(BFEntry *)entry error:(NSError **)error;
{
  NSError  * fileError;
  NSString * entryString   = [self.template renderEntry:entry];
  NSString * entryPage     = [self.template renderPage:entryString];
  NSString * entryDir      = [self.outputDir stringByAppendingPathComponent:self.entriesSubdir];
  NSString * entryFileName = [entry.slug stringByAppendingPathExtension:@"html"];
  NSString * entryFilePath = [entryDir stringByAppendingPathComponent:entryFileName];
  
  if ([[NSFileManager defaultManager] createDirectoryAtPath:entryDir withIntermediateDirectories:YES attributes:nil error:&fileError] == NO)
  {
    if (error != nil) *error = fileError;
    return nil;
  }
  
  if ([entryPage writeToFile:entryFilePath atomically:NO encoding:NSUTF8StringEncoding error:&fileError] == NO)
  {
    if (error) *error = fileError;
    return nil;
  }
  
  return entryString;
}

@end
