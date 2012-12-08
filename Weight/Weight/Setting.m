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
@end
