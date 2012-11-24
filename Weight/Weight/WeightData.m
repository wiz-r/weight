//
//  WeightData.m
//  PlotSample
//
//  Created by takuya on 2012/11/10.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "WeightData.h"

@implementation WeightData
-(id) initWithWeight:(float)weight :(NSDate*)date
{
    if((self=[super init])) {
        self.weight = weight;
        self.date = date;
    }
    
    return self;
}

-(NSString*) keyForDic
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:WEIGHT_DATE_FORMAT];
    NSString* key = [formatter stringFromDate:self.date];
    return key;
}

-(NSString*) valueForDic
{
    return [NSString stringWithFormat:@"%f", self.weight];
}
@end
