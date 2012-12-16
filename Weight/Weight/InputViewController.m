//
//  InputViewController.m
//  Weight
//
//  Created by takuya.watabe on 11/12/12.
//  Copyright (c) 2012 takuya. All rights reserved.
//

#import "InputViewController.h"
#import "WeightCollection.h"

#import "Flurry.h"

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
@property (weak, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)buttonPushed:(id)sender;
- (IBAction)clearPushed:(id)sender;
- (IBAction)pickerClosePushed:(id)sender;

@end

@implementation InputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *backgroundImage = [UIImage imageNamed:@"cream.jpg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pickerView.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate* today = [NSDate date];
    [self.datePicker setDate:today];
    [self.dateButton setTitle:[self pickDate] forState:UIControlStateNormal];
    [Flurry logEvent:@"Input_View"];
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
    self.pickerView.hidden = !self.pickerView.hidden;
}

- (IBAction)okButtonPushed:(id)sender {
    NSString* weight = self.textField.text;
    if ([weight length] == 0) return; // ignore button pushed
        
    WeightData* data = [[WeightData alloc] initWithWeight:[weight floatValue] :self.datePicker.date];
    WeightCollection* collection = [[WeightCollection alloc] init];
    [collection add:data];
    [collection save];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self emitCloseEvent];
    }];
}

- (IBAction)closeSoftwareKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

- (NSString*)pickDate {
    NSDate* date = self.datePicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:WEIGHT_DATE_FORMAT];
    return [formatter stringFromDate:date];
}

- (IBAction)buttonPushed:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSString* label = button.titleLabel.text;
    self.textField.text = [NSString stringWithFormat:@"%@%@", self.textField.text, label];
}

- (IBAction)clearPushed:(id)sender {
    self.textField.text = @"";
}

- (IBAction)pickerClosePushed:(id)sender {
    self.pickerView.hidden = YES;
}

- (void) emitCloseEvent
{
    NSNotification* n = [NSNotification notificationWithName:INPUT_CLOSE_NOTIFICATION_NAME object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}
@end
