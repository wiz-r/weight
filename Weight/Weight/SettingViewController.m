//
//  SettingViewController.m
//  Weight
//
//  Created by takuya.watabe on 11/25/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "SettingViewController.h"
#import "AlermCell.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Setting", @"Setting");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    AlermCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {     
        UIViewController* controller;
        controller = [[UIViewController alloc] initWithNibName:@"AlermCellView" bundle:nil];
        cell = (AlermCell*)controller.view;
    }
    return cell;
}
@end
