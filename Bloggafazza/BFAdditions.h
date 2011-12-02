//
//  BFAdditions.h
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Bloggafazza)
- (NSArray *)arrayByMappingBlock:(NSObject * (^)(NSObject * obj, BOOL * stop))mapFunction;
@end
