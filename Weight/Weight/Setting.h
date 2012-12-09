//
//  Setting.h
//  Weight
//
//  Created by takuya on 2012/12/08.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTING_USE_ALARM @"use_alarm"
#define SETTING_ALARM_DATE @"alarm_date"

@interface Setting : NSObject
-(Setting*) init;
-(id) valueForKey: (id) key;
-(void) setValue: (id)value forKey:(id) key;
-(void) setAlarmNotification;
@end
