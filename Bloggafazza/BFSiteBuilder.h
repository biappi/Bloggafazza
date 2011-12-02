//
//  BFSiteBuilder.h
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFEntriesCollection.h"
#import "BFTemplate.h"

@interface BFSiteBuilder : NSObject

+ (BFSiteBuilder *)siteBuilderWithOutputDir:(NSString *)outputDir entriesSubdir:(NSString *)entriesSubdir template:(BFTemplate *)template;
- (BOOL)renderEntryCollection:(BFEntriesCollection *)collection error:(NSError **)error;

@end
