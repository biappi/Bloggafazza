//
//  BFPageLayout.m
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFTemplate.h"

@interface BFTemplate ()
@property(nonatomic, strong) NSString * pageFormat;
@property(nonatomic, strong) NSString * entryFormat;
@end

@implementation BFTemplate

@synthesize pageFormat;
@synthesize entryFormat;

+ (BFTemplate *)templateFromDirectory:(NSString *)directory error:(NSError **)error;
{
  NSError    * fileError;
  BFTemplate * template = [BFTemplate new];
  
  template.pageFormat = [NSString stringWithContentsOfFile:[directory stringByAppendingPathComponent:@"pageFormat"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&fileError];
  
  if (template.pageFormat == nil)
  {
    if (error)
      *error = fileError;
    
    return nil;
  }
  
  template.entryFormat = [NSString stringWithContentsOfFile:[directory stringByAppendingPathComponent:@"entryFormat"]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&fileError];
  
  if (template.entryFormat == nil)
  {
    if (error)
      *error = fileError;
    
    return nil;
  }
  
  return template;
}

- (NSString *)renderEntry:(BFEntry *)entry additionalSubstitutions:(NSDictionary *)subs;
{
  NSString * date = [NSDateFormatter localizedStringFromDate:entry.date
                                                   dateStyle:NSDateFormatterMediumStyle
                                                   timeStyle:NSDateFormatterNoStyle];
  
  NSString * rendered = self.entryFormat;
  rendered = [rendered stringByReplacingOccurrencesOfString:@"{{TITLE}}" withString:entry.title];
  rendered = [rendered stringByReplacingOccurrencesOfString:@"{{SLUG}}" withString:entry.slug];
  rendered = [rendered stringByReplacingOccurrencesOfString:@"{{BODY}}" withString:entry.body];
  rendered = [rendered stringByReplacingOccurrencesOfString:@"{{DATE}}" withString:date];
  
  for (NSString * key in subs)
    rendered = [rendered stringByReplacingOccurrencesOfString:key
                                                   withString:[subs objectForKey:key]];
  
  return rendered;
}

- (NSString *)renderPage:(NSString *)content;
{  
  return [self.pageFormat stringByReplacingOccurrencesOfString:@"{{CONTENT}}" withString:content];
}

@end
