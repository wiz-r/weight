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
@end
