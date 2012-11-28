//
//  AlermCell.m
//  Weight
//
//  Created by takuya.watabe on 11/27/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "AlermCell.h"

@implementation AlermCell
- (IBAction)alermSettingChanged:(id)sender {
    BOOL on = self.toggleButton.on;
    NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:on] forKey:@"on"];
    NSNotification* n = [NSNotification notificationWithName:@"Alerm" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
