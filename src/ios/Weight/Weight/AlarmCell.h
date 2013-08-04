//
//  AlermCell.h
//  Weight
//
//  Created by takuya.watabe on 11/27/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALERM_SETING_NOTIFICATION_NAME @"AlarmSetting"

@interface AlarmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleButton;
-(void)switchValue:(BOOL)on;
@end
