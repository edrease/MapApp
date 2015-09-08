//
//  ViewController.m
//  Mapz
//
//  Created by Edrease Peshtaz on 8/31/15.
//  Copyright (c) 2015 cf. All rights reserved.
//

#import "ViewController.h"
#import "LocationDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D selectedCoordinate;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  PFSignUpViewController *signUpVC = [[PFSignUpViewController alloc] init];
  signUpVC.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
  signUpVC.delegate = self;
  [self presentViewController:signUpVC animated:true completion:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderNotification:) name:@"Test" object:nil];
  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
  [self.locationManager startUpdatingLocation];
  
  UIGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action: @selector(handleLongPress:)];
  [self.mapView addGestureRecognizer:longPressGesture];
  
}

-(void)reminderNotification: (NSNotification *)notification {
  NSDictionary *userInfo = notification.userInfo;
  if (userInfo) {
    CLCircularRegion *region = userInfo[@"Jetfighter"];
    [self.locationManager startMonitoringForRegion:region];
    MKCircle *overlay = [MKCircle circleWithCenterCoordinate: region.center radius:region.radius];
    [self.mapView addOverlay:overlay];
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleLongPress: (UILongPressGestureRecognizer *) gestureRecognizer {
  
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    annotation.title = @"You are here";
    [self.mapView addAnnotation:annotation];
    self.selectedCoordinate = *(&location);
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)tupacButtonPressed:(id)sender {
  
  PFSignUpViewController *signUpVC = [[PFSignUpViewController alloc] init];
  signUpVC.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
  signUpVC.delegate = self;
  [self presentViewController:signUpVC animated:true completion:nil];
  
}

- (IBAction)biggieButtonPressed:(id)sender {
  [PFUser logOut];
  
  UIAlertView *logout = [[UIAlertView alloc] initWithTitle:@"Logged Out" message:@"You have logged out of Mapz" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
  [logout show];
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  pinView.annotation = annotation;
  
  if (!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  }
  
  pinView.animatesDrop = true;
  pinView.pinColor = MKPinAnnotationColorGreen;
  pinView.canShowCallout = true;
  pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  return pinView;
  
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  circleRenderer.strokeColor = [UIColor blueColor];
  circleRenderer.fillColor = [UIColor blueColor];
  circleRenderer.alpha = 0.2;
  return circleRenderer;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"ShowLocationDetail"]) {
    LocationDetailViewController *locationDetailViewController = [segue destinationViewController];
    locationDetailViewController.selectedCoordinate = self.selectedCoordinate;
  }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
  [self performSegueWithIdentifier:@"ShowLocationDetail" sender:view];
    

  NSLog(@"button press worked");
}






#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  switch (status) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      break;
    default:
      break;
  }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  self.location = locations.lastObject;
  
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  notification.alertTitle = @"Entered Region!";
  notification.alertBody = @"Be safe and have fun!";
  
  [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
  
}

#pragma mark - PFSignUpViewController

-(void)signUpViewController:(PFSignUpViewController * __nonnull)signUpController didSignUpUser:(PFUser * __nonnull)user {
  [signUpController dismissViewControllerAnimated:true completion:nil];
}

- (void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user {
  [logInController dismissViewControllerAnimated:true completion:nil];
}

@end
