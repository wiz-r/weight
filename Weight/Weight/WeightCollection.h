//
//  WeightCollection.h
//  Weight
//
//  Created by takuya.watabe on 11/21/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeightData.h"

@interface WeightCollection : NSObject
@property (retain, nonatomic) NSMutableDictionary* dictionary;
-(WeightCollection*) init;
-(void) setData: (NSArray*)list;
-(void) add:(WeightData*) weight;
-(void) load;
-(void) save;
-(NSMutableArray*) array;
@end
