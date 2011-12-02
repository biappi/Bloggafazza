//
//  BFEntry.m
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFEntry.h"

@implementation BFEntry

@synthesize title;
@synthesize slug;
@synthesize date;
@synthesize body;

+ (BFEntry *)entryFromFileWithPath:(NSString *)path error:(NSError **)error;
{
  NSString * filename  = [[path lastPathComponent] stringByDeletingPathExtension];
  NSArray  * nameComps = [filename componentsSeparatedByString:@"--"];
  
  if (nameComps.count != 2)
  {
    if (error)
      *error = [NSError errorWithDomain:@"Entry" code:1 userInfo:nil];
    
    return nil;
  }
  
  NSError  * fileError;
  
  NSString * slug       = [nameComps objectAtIndex:0];
  NSString * dateString = [nameComps objectAtIndex:1];
  
  NSArray  * dateStringComps = [dateString componentsSeparatedByString:@"-"];
  if (dateStringComps.count != 3)
  {
    if (error)
      *error = [NSError errorWithDomain:@"Entry" code:2 userInfo:nil];
    
    return nil;
  }
  
  NSDateComponents * dateComps = [NSDateComponents new];
  dateComps.day   = [[dateStringComps objectAtIndex:0] intValue];
  dateComps.month = [[dateStringComps objectAtIndex:1] intValue];
  dateComps.year  = [[dateStringComps objectAtIndex:2] intValue];
  
  NSCalendar * goodCalendarGreg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDate * date = [goodCalendarGreg dateFromComponents:dateComps];
  
  NSString * body = [NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&fileError];
  
  if (body == nil)
  {
    if (error)
      *error = fileError;
    
    return nil;
  }
  
  NSRange rangeOfNewline = [body rangeOfString:@"\n"];
  if (rangeOfNewline.location == NSNotFound)
  {
    if (error)
      *error = [NSError errorWithDomain:@"Entry" code:2 userInfo:nil];
    
    return nil;
  }
  
  BFEntry * zelf = [BFEntry new];
  zelf.title = [body substringToIndex:rangeOfNewline.location];
  zelf.slug  = slug;
  zelf.date  = date;
  zelf.body  = [body substringFromIndex:rangeOfNewline.location + 1];
  
  return zelf;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"<%@: %p - title: %@, slug: %@, date:%@>", NSStringFromClass([self class]), self, self.title, self.slug, self.date];
}

@end
