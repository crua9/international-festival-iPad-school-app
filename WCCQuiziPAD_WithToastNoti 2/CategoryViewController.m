//
//  CategoryViewController.m
//  WCCQuiz
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

#import "CategoryViewController.h"
#import "QuizViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TimerUIApplication.h"

@interface CategoryViewController (){
    QuizViewController *_quizControl;
}

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inactivityTimeout) name:kApplicationDidTimeoutNotification object:nil];
    self.cat1.layer.cornerRadius =5;
    self.cat1.layer.masksToBounds = YES;
    self.cat1.tag = 0;
    self.cat2.layer.cornerRadius =5;
    self.cat2.layer.masksToBounds = YES;
    self.cat2.tag = 1;
    self.cat3.layer.cornerRadius =5;
    self.cat3.layer.masksToBounds = YES;
    self.cat3.tag = 2;
    self.catAll.layer.cornerRadius =5;
    self.catAll.layer.masksToBounds = YES;
    self.catAll.tag = 3;
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    _quizControl = nil;
}
-(void)inactivityTimeout{
    [self popUpViewAtMainMenuTimeout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)categoryButtonClicked:(UIButton *)sender {
    
    int buttonTag = sender.tag;
//    [[DBManager getSharedInstance] getDataFromDBWithCatrgory:sender.tag+1];
    _quizControl = nil;
    _quizControl = [[QuizViewController alloc] initWithNibName:@"QuizViewController" bundle:nil];
    
    _quizControl.catergory = sender.titleLabel.text;
    _quizControl.catIndex = sender.tag+1;
    [self presentViewController:_quizControl animated:YES completion:^{
        
    }];
    
    
//    [self addChildViewController:_quizControl];
}

-(void)popUpViewAtMainMenuTimeout{
    if (_quizControl) {
        return;
    }
    
    UIView *checkView = [self.view viewWithTag:118];
    if (checkView.superview) {
        return;
    }
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4];
    
    
   
    self.popUpViewForMainScreen.center = bgView.center;
    self.popUpViewForMainScreen.layer.cornerRadius = 10;
    self.popUpViewForMainScreen.layer.masksToBounds = YES;
    
    [bgView addSubview:self.popUpViewForMainScreen];
    [bgView bringSubviewToFront:self.popUpViewForMainScreen];
    bgView.tag = 118;
    self.popUpViewForMainScreen.alpha = 1.0;
    
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePopUp)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    
    [bgView addGestureRecognizer:tapRecognizer];
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyGesture)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    
    [self.popUpViewForMainScreen addGestureRecognizer:tapRecognizer2];
}

-(void)removePopUp{
    UIView* bgview = [self.view viewWithTag:118];
    [bgview removeFromSuperview];

}

-(void)emptyGesture{
    
}
@end
