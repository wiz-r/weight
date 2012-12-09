//
//  SettingViewController.m
//  Weight
//
//  Created by takuya.watabe on 11/25/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "SettingViewController.h"
#import "AlarmCell.h"
#import "Setting.h"

#define SETTING_VIEW_DATE_FORMAT @"HH:mm"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) Setting* setting;
- (IBAction)dateChanged:(id)sender;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Setting", @"Setting");
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
        self.setting = [[Setting alloc] init];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(alermNotificationReceived:) name:ALERM_SETING_NOTIFICATION_NAME object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:SETTING_VIEW_DATE_FORMAT];
    NSDate* date = [dateFormat dateFromString:[self.setting valueForKey:SETTING_ALARM_DATE]];
    self.datePicker.date = date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Setting";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {     
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"AlermCellView" bundle:nil];
        cell = (AlarmCell*)controller.view;
        [cell switchValue:[(NSNumber*)[self.setting valueForKey:SETTING_USE_ALARM] boolValue]];
    }
    return cell;
}

-(void)alermNotificationReceived:(NSNotification*)center{
    [center userInfo];
    NSNumber* value = [[center userInfo] objectForKey:@"on"];
    BOOL on = [value boolValue];
    [self.setting setValue:[NSNumber numberWithBool:on] forKey:SETTING_USE_ALARM];
    [self.setting setAlarmNotification];
}
- (IBAction)dateChanged:(id)sender {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:SETTING_VIEW_DATE_FORMAT];
    [self.setting setValue:[dateFormat stringFromDate:self.datePicker.date] forKey:SETTING_ALARM_DATE];
    [self.setting setAlarmNotification];
}
@end
