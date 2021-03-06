//
//  WeightCollection.m
//  Weight
//
//  Created by takuya.watabe on 11/21/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "WeightCollection.h"
#define UD_COLLECTION_DATA_KEY @"weight_collection"

@implementation WeightCollection
-(WeightCollection*)init
{
    if((self=[super init])) {
        [self load];
    }
    
    return self;
}

-(void) setData:(NSArray *)list
{
    for (id data in list) {
        WeightData* weight = (WeightData*)data;
        [self add:weight];
    }
}

-(void) add:(WeightData*) weight
{
    [self.dictionary setObject:[weight valueForDic] forKey:[weight keyForDic]];
}

-(NSArray*) array
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (id key in [self.dictionary allKeys]) {
        float weight = [[self.dictionary valueForKey:(NSString*)key] floatValue];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:WEIGHT_DATE_FORMAT];
        NSString* dateString = (NSString*)key;
        NSDate* date = [formatter dateFromString:(NSString*)dateString];
        
        WeightData* data = [[WeightData alloc] initWithWeight:weight :date];
        [array addObject:data];
    }
    
    NSSortDescriptor *sortDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray* sortedArray = [NSArray arrayWithObjects:sortDate, nil];
    return [array sortedArrayUsingDescriptors:sortedArray];
}

-(void) save
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.dictionary forKey:UD_COLLECTION_DATA_KEY];
    [ud synchronize];
}

-(void) load
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [ud dictionaryForKey:UD_COLLECTION_DATA_KEY];
    if ([dict count] == 0) {
        self.dictionary = [NSMutableDictionary dictionary];
    } else {
        self.dictionary = [dict mutableCopy];
    }
}

-(WeightData*) latest
{
    NSMutableArray* array = [self array];
    if ([array count] == 0) {
        return nil;
    } else {
        return [array objectAtIndex:(0)];
    }
}

-(float) maxWeightWithPeriod:(int)days
{
    NSMutableArray* array = [self array];
    float max = 0.0f;
    NSDate* now = [NSDate date];
    NSTimeInterval interval = days * 24.0f * 60.0f * 60.0f;
    
    for (int i = 0; i < array.count; i++) {
        WeightData* data = [array objectAtIndex:i];
        if ([now timeIntervalSinceDate:data.date] <= interval) {
            if (i == 0) {
                max = data.weight;
            } else {
                max = MAX(data.weight, max);
            }
        }
    }
    
    return max;
}

-(float) minWeightWithPeriod:(int)days
{
    NSMutableArray* array = [self array];
    float min = 0.0f;
    NSDate* now = [NSDate date];
    NSTimeInterval interval = days * 24.0f * 60.0f * 60.0f;
    
    for (int i = 0; i < array.count; i++) {
        WeightData* data = [array objectAtIndex:i];
        if ([now timeIntervalSinceDate:data.date] <= interval) {
            if (i == 0) {
                min = data.weight;
            } else {
                min = MIN(data.weight, min);
            }
        }
    }
    
    return min;
}

@end
