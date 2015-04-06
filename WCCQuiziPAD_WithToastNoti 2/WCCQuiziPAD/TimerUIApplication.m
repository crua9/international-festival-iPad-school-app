//
//  TimerUIApplication.m
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
//

#import "TimerUIApplication.h"

@implementation TimerUIApplication{
    int secondCount;
    int inactivityCounter;
}

//here we are listening for any touch. If the screen receives touch, the timer is reset
-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (!myidleTimer)
    {
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
            [self resetIdleTimer];
        }
        
    }
}
//as labeled...reset the timer
-(void)resetIdleTimer
{
    inactivityCounter = 0;
    if (myidleTimer)
    {
        [myidleTimer invalidate];
    }
    
    // Interval for the Toast notification to appear as a warning 10 seconds before timeout.
    self.ToastAppearTimeInSeconds = 30;
    // Interval after which the quiz app will show the timeout Popup or exit from the quiz.
    self.idleTimerExceedTimeInSeconds = 40;
    // convert the wait period into minutes rather than seconds
    //    int timeout =31;
    //    myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    int timeout =1;
    myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:YES];
    
}

-(void)resetQuizTimer{
    if (quizEndTimer)
    {
        [quizEndTimer invalidate];
    }
    // Total Quiz time duration in seconds
    self.timer2ExceedTimeInSeconds = 300;
    secondCount = 0;
    quizEndTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(idleTimerExceeded2) userInfo:nil repeats:YES];
}


//if the timer reaches the limit as defined in kApplicationTimeoutInMinutes, post this notification
-(void)idleTimerExceeded
{
    inactivityCounter ++;
    if (inactivityCounter==self.ToastAppearTimeInSeconds) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWarningTimeoutNotification2 object:nil];
    }
    else if(inactivityCounter>self.idleTimerExceedTimeInSeconds){
        [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

-(void)idleTimerExceeded2
{
    secondCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification2 object:nil];
    
    if (secondCount > self.timer2ExceedTimeInSeconds) {
        
         [quizEndTimer invalidate];
    }
}

-(void)disableQuizTimer{
    
    if (quizEndTimer)
    {
        [quizEndTimer invalidate];
        quizEndTimer = nil;
    }
    
}


@end
