//
//  LocationDetailViewController.m
//  Mapz
//
//  Created by Edrease Peshtaz on 9/3/15.
//  Copyright (c) 2015 cf. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setReminderButtonPressed:(id)sender {
  
  if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
    CLCircularRegion *monitoringRegion = [[CLCircularRegion alloc] initWithCenter:self.selectedCoordinate radius:100 identifier:@"Selected Location"];
//    MKCircle *monitoringRadius = [MKCircle circleWithCenterCoordinate:self.selectedCoordinate radius:100];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:monitoringRegion forKey:@"Jetfighter"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:self userInfo:userInfo];
  }
  

  
  [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
  NSLog(@"%@",textField.text);
  
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return false;
}

@end
