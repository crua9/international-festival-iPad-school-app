//
//  AppDelegate.m
//  WCCQuiziPAD
//
//  Created by Craig Thomas Bennett II on 9/15/14.
//  Copyright (c) 2014 Tech Reviews and Help. All rights reserved.
//
//
//  This code was made pro bono by Craig Thomas Bennett II Executive Director Tech Reviews and Help for the state of North Carolina, Wayne Community College, Goldsboro NC.
//  This code is copyrighted, but can be used by Wayne Community College and agreed parties for free/nonprofit events and as an academic teaching tool/aid.
//  *Free event = Any event which the participants do not have to montionarly pay to enter and use this app.
//
//  You must have direct permission by Craig Thomas Bennett II to donate this code, sell this code, use it in a paid event, or to make a profit because of this code.
//  If the code is to be utilized within an academia environment as an academic teaching tool, then you may use it for paid and/or free classes.
//  You may give this code out to any public or private school. However, they must agree to these terms of use.
//
//  No one other than Craig Thomas Bennett II has the right to change these terms or the code.
//  By using this, you agree to these terms.
//
//

#import "AppDelegate.h"
#import "CategoryViewController.h"
#import "TimerUIApplication.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    CategoryViewController *catViewController = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
    self.window.rootViewController = catViewController;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuizEndtimerTimeout2) name:kApplicationDidTimeoutNotification2 object:nil];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog (@"time exceeded!!");
    [(TimerUIApplication *)[UIApplication sharedApplication] resetIdleTimer];

    
    //This is where storyboarding vs xib files comes in. Whichever view controller you want to revert back to, on your storyboard, make sure it is given the identifier that matches the following code. In my case, "mainView". My storyboard file is called MainStoryboard.storyboard, so make sure your file name matches the storyboardWithName property.
//    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"mainView"];
//    
//    [(UINavigationController *)self.window.rootViewController pushViewController:controller animated:YES];
}

//-(void)QuizEndtimerTimeout2{
//    NSLog (@"QuizEnded!!");
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
