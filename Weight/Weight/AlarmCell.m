//
//  AlermCell.m
//  Weight
//
//  Created by takuya.watabe on 11/27/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "AlarmCell.h"

@interface AlarmCell()
@end

@implementation AlarmCell
- (IBAction)alermSettingChanged:(id)sender {
    BOOL on = self.toggleButton.on;
    NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:on] forKey:@"on"];
    NSNotification* n = [NSNotification notificationWithName:ALERM_SETING_NOTIFICATION_NAME object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)switchValue: (BOOL)on
{
    self.toggleButton.on = on;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
