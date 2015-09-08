//
//  AppDelegate.h
//  Mapz
//
//  Created by Edrease Peshtaz on 8/31/15.
//  Copyright (c) 2015 cf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

