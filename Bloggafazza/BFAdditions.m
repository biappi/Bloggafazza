//
//  BFAdditions.m
//  Bloggafazza
//
//  Created by Antonio Malara on 02/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFAdditions.h"

@implementation NSArray (Bloggafazza)

- (NSArray *)arrayByMappingBlock:(NSObject * (^)(NSObject * obj, BOOL * stop))mapFunction;
{
  NSMutableArray * result = [NSMutableArray arrayWithCapacity:self.count];
  BOOL stop = NO;
  
  for (NSObject * obj in self)
  {
    NSObject * newObj = mapFunction(obj, &stop);
    
    if (newObj)
      [result addObject:newObj];
    
    if (stop)
      break;
  }
  
  return [result copy];
}

@end
