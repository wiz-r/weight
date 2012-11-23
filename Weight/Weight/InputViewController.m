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
- (IBAction)okButtonPushed:(id)sender;
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
    NSDate* today = [NSDate date];
    [self.datePicker setDate:today];
    [self.dateButton setTitle:[self pickDate] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerChanged:(id)sender {
    [self.dateButton setTitle:[self pickDate] forState:UIControlStateNormal];
}

- (IBAction)cancelButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (IBAction)dateButtonPushed:(id)sender {
    [self.textField resignFirstResponder];
}

- (IBAction)okButtonPushed:(id)sender {
    NSString* weight = self.textField.text;
    if ([weight length] == 0) return; // ignore button pushed
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"hoge" message:[NSString stringWithFormat:@"date:%@ / weight:%@", [self pickDate], weight] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
}

- (IBAction)closeSoftwareKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

- (NSString*)pickDate {
    NSDate* date = self.datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    return [formatter stringFromDate:date];
}
@end
