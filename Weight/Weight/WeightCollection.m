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
        self.dictionary = [NSMutableDictionary dictionary];
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud registerDefaults:self.dictionary];
        
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
    for (id key in [self.dictionary allKeys]) {
        NSLog(@"key:%@", (NSString*)key);
    }
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
    NSLog(@"hi:%@", @"save");
    for (id key in [self.dictionary allKeys]) {
        NSLog(@"s-key:%@", (NSString*)key);
    }
    [ud setObject:self.dictionary forKey:UD_COLLECTION_DATA_KEY];
    [ud synchronize];
}

-(void) load
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [ud dictionaryForKey:UD_COLLECTION_DATA_KEY];
    NSLog(@"hi:%@", @"load");
    for (id key in [dict allKeys]) {
        NSLog(@"d-key:%@", (NSString*)key);
    }
    self.dictionary = [dict mutableCopy];
}

@end