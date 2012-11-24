//
//  WeightData.h
//  PlotSample
//
//  Created by takuya on 2012/11/10.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WEIGHT_DATE_FORMAT @"yyyy/MM/dd"

@interface WeightData : NSObject
@property (assign, nonatomic) float weight;
@property (retain, nonatomic) NSDate* date;

-(id) initWithWeight:(float)weight :(NSDate*)date;
-(NSString*) keyForDic;
-(NSString*) valueForDic;
@end