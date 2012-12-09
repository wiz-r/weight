//
//  Setting.m
//  Weight
//
//  Created by takuya on 2012/12/08.
//  Copyright (c) 2012年 takuya. All rights reserved.
//

#import "Setting.h"
#define UD_SETTING_DATA_KEY @"setting"

@interface Setting ()
@property(retain, nonatomic) NSMutableDictionary* dictionary;
@end

@implementation Setting
-(Setting*)init
{
    if((self=[super init])) {
        [self load];
    }
    
    return self;
}

-(void) load
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [ud dictionaryForKey:UD_SETTING_DATA_KEY];
    if ([dict count] == 0) {
        self.dictionary = [NSMutableDictionary dictionary];
        [self setDefaultSetting];
        [self save];
    } else {
        self.dictionary = [dict mutableCopy];
    }
}

-(void) setDefaultSetting
{
    [self.dictionary setObject:[NSNumber numberWithBool:YES] forKey:SETTING_USE_ALARM];
    [self.dictionary setObject:@"19:00" forKey:SETTING_ALARM_DATE];
}

-(void) save
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.dictionary forKey:UD_SETTING_DATA_KEY];
    [ud synchronize];
}

-(id) valueForKey: (id) key
{
    [self load];
    return [self.dictionary objectForKey:key];
}

-(void) setValue: (id)value forKey:(id) key
{
    [self load];
    [self.dictionary setObject:value forKey:key];
    [self save];
}

- (void)setAlarmNotification
{
    BOOL useAlarm = [(NSNumber*)[self valueForKey:SETTING_USE_ALARM] boolValue];
    if (useAlarm) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSDate* settingDate = [dateFormat dateFromString:[self valueForKey:SETTING_ALARM_DATE]];
        NSDate* today = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* settingComp = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:settingDate];
        NSDateComponents* todayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:today];
        NSDateComponents* fireComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit fromDate:today];
        [fireComp setYear:todayComp.year];
        [fireComp setMonth:todayComp.month];
        [fireComp setDay:todayComp.day];
        [fireComp setHour:settingComp.hour];
        [fireComp setMinute:settingComp.minute];
        
        NSDate* fireDate = [calendar dateFromComponents:fireComp];
        
        UILocalNotification* notification = [[UILocalNotification alloc] init];
        if (notification == nil) return;
        notification.fireDate = fireDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = NSDayCalendarUnit;
        notification.alertBody = @"It's time to measure your weight for your better life";
        notification.alertAction = @"View Details";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}
@end
