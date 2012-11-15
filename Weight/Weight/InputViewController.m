//
//  InputViewController.m
//  Weight
//
//  Created by takuya.watabe on 11/12/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)dateButtonPushed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
- (IBAction)closeSoftwareKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation InputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if ([self.textField canBecomeFirstResponder])
    {
        [self.textField becomeFirstResponder];
    }
    self.textField.returnKeyType = UIReturnKeyDone;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerChanged:(id)sender {
    NSDate* date = self.datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    [self.dateButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
}

- (IBAction)cancelButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (IBAction)dateButtonPushed:(id)sender {
    [self.textField resignFirstResponder];
}
- (IBAction)closeSoftwareKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}
- (IBAction)cancel:(id)sender {
}
@end
