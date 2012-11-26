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
    // TODO : NSNotificationCenter
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
