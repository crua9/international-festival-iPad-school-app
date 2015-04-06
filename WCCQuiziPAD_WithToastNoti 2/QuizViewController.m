//
//  QuizViewController.m
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

#import "QuizViewController.h"
#import "QuizQuestions.h"
#import "QuizOptionsViewCell.h"
#import "TimerUIApplication.h"


@interface QuizViewController () {
    NSMutableArray *QuizArray  ;
    QuizQuestions *myQuiz;
    NSDictionary *currentQuestion;
    int questionIndex, correctAnsCount ;
    NSString *popupText;
    NSString *timeRemaining;
    int seconds, secondsPassed;
    NSString *imageName;
    NSArray *options;
    NSString *theQuestion;
    NSString *correctAns;
    BOOL isEnd;
    BOOL isCorrect;
    BOOL isSkipped;
    int duration;
    MBProgressHUD *hud;
    UITapGestureRecognizer *FingerTap;
}

@end

@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myQuiz = [[QuizQuestions alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initiate the Quiz data for the selected Category
    [self QuizInitiate];

    //listen for inactivity timeout after being idle for 30 sec
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerTimeout) name:kApplicationDidTimeoutNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerTimeout2) name:kWarningTimeoutNotification2 object:nil];
   
}

//fired after being idle for 30 sec
-(void)timerTimeout{
    NSLog (@"time exceeded!!");
    [self dismissController];
}
-(void)timerTimeout2{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.delegate= self;
    hud.labelText = @"Timout in 10 seconds, please tap anywhere on the screen to prevent Timeout.";
    [hud hide:YES afterDelay:3];
    if (!FingerTap) {
        FingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleFingerTap)];
        [FingerTap setNumberOfTouchesRequired:1];
        
        [self.view addGestureRecognizer:FingerTap];
    }
    
}

-(void)handleFingerTap{
    
    if (![hud isHidden]) {
        [hud hide:YES];
    }
    [self.view removeGestureRecognizer:FingerTap];
    FingerTap = nil;
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    [self.view removeGestureRecognizer:FingerTap];
    FingerTap = nil;
}


-(void)viewDidAppear:(BOOL)animated{
    
    //listener for 5 min timer.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuizEndtimerTimeout) name:kApplicationDidTimeoutNotification2 object:nil];

}

//fired every second to keep track of time
-(void)QuizEndtimerTimeout{
    seconds--;
    NSLog (@"1 second passed!!");
    
    if (seconds == 0) {
        [self dismissController];
    }
    //upate timer label every second
    [self timeUpdate];
    
    
}



-(void)timeUpdate{
    int m = 0;
//    int m1 = 0;
    //    int h?;
    int s = 0;
//    int s1 = 0;
    
   
    secondsPassed = duration - seconds;
    if (seconds>59) {
        m = seconds/60;
        s = seconds % 60;
        
    }
    else{
        s = seconds;
    }
    NSString *time = [NSString stringWithFormat:@"%02d:%02d",m,s];
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",m,s];
    if (secondsPassed > 59) {
        m = secondsPassed/60;
        s = secondsPassed%60;
    }
    else{
        m = 0;
        s = secondsPassed;
    }
   timeRemaining = [NSString stringWithFormat:@"%02d:%02d",m,s];
    
    
}


-(void)QuizInitiate{
    questionIndex = 0;
   
    correctAnsCount = 0;
    isEnd = NO;
    
    //start 5 min timer
    [(TimerUIApplication *)[UIApplication sharedApplication] resetQuizTimer];
    TimerUIApplication *timeApp = (TimerUIApplication *)[UIApplication sharedApplication];
     duration = timeApp.timer2ExceedTimeInSeconds;
     seconds = duration;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QuizEndtimerTimeout) name:kApplicationDidTimeoutNotification2 object:nil];
    
    //get all quizzes
    QuizArray = nil;
    QuizArray = [myQuiz createQuizCollectionOfCategoryIndex:self.catIndex];
    
    //set question count label
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d/%d", questionIndex+1, [QuizArray count ]];
    if ([QuizArray count] ==0) {
        [self nextQuestion];
    }
    else {
        [self setupQuizQuestion];
        [self.questionTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}


//this sets up all variables for each quiz.
-(void)setupQuizQuestion{
    currentQuestion = [QuizArray objectAtIndex:questionIndex];
    theQuestion = [currentQuestion objectForKey:@"question"];
    options = [currentQuestion objectForKey:@"options"];
    popupText = [currentQuestion objectForKey:@"popupText"];
    imageName = [currentQuestion objectForKey:@"image"];
    correctAns = [currentQuestion objectForKey:@"correctAnswer"];
    [self.QuestionHeaderImage setImage:[UIImage imageNamed:imageName]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table_VIEW_Delegate_Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *MyIdentifier = @"MyIdentifier";
    static NSString *MyIdentifier = @"OptionSCell";

    
                QuizOptionsViewCell *cell = (QuizOptionsViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = nil;
                if (cell == nil) {
                    //        cell = [[StationTableCellModel alloc] initWithStyle:UITableViewCellStyleDefault
                    //                                      reuseIdentifier:CellIdentifier];
                    
                    cell = [[QuizOptionsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
                    NSArray *topLevelObjects=[[NSBundle mainBundle]loadNibNamed:@"QuizOptionsViewCell" owner:self options:nil];
                    cell = (QuizOptionsViewCell*)[topLevelObjects objectAtIndex:0];
                }
                
                
    UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    [imageViewBG setImage:[UIImage imageNamed:@"cellBG.png"]];
    [cell.contentView addSubview:imageViewBG];
    [cell.contentView sendSubviewToBack:imageViewBG];
    
    cell.backgroundView.frame = CGRectZero;
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.OptionsLabel.text = [options objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
   QuizOptionsViewCell *selectedCell =(QuizOptionsViewCell*)[tableView cellForRowAtIndexPath:indexPath];
   NSString *answer = selectedCell.OptionsLabel.text;
    if ([answer isEqualToString:correctAns]) {
        correctAnsCount++;
        isCorrect = YES;
    }
    [self popUpViewAtEachQuizEnd];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.QuestionLabel.text =   theQuestion; //[currentQuestion objectForKey:@"question"];
    return self.questionView;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}



- (IBAction)skiptapped:(UIButton *)sender {
    isCorrect = NO;
    isSkipped = YES;
//    popupText = @"Skipping a question will be counted as a wrong answer. \n The Correct Answer is %@ \n %@"; //You've skipped the question. \n \n It will be counted as a wrong answer.";
    popupText =[NSString stringWithFormat:@"Skipping a question will be counted as a wrong answer. The Correct Answer is %@ \n\n %@",correctAns, popupText];
    [self popUpViewAtEachQuizEnd];
}


- (IBAction)backbuttonTapped:(UIButton *)sender {
    
    [self dismissController];
   
}

-(void)nextQuestion{
  questionIndex ++;
    if (questionIndex == QuizArray.count) {
        [(TimerUIApplication *)[UIApplication sharedApplication] disableQuizTimer];
        isEnd = YES;
        [self popUpViewAtEachQuizEnd];
        return ;
    }
    
    if (!isEnd) {
        self.questionNumberLabel.text = [NSString stringWithFormat:@"%d/%d", questionIndex+1, [QuizArray count ]];
        
        [self setupQuizQuestion];
        [self.questionTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (questionIndex == QuizArray.count+1) {
        [self dismissController];
    }
   
    
}

-(void)dismissController{
    [(TimerUIApplication *)[UIApplication sharedApplication] disableQuizTimer];
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
    
}

-(void)popUpViewAtEachQuizEnd{
    
    //create transparent background
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4];
    
    //check if quiz has come to an end and set popup accordingly
    if (isEnd) {
        self.popUpLabel.text = [NSString stringWithFormat:@"Your Score is %d out of %d Questions in %@ time. Do you want to try this category again?", correctAnsCount, [QuizArray count] ,timeRemaining];
        [self.okButton setHidden:NO];
        [self.nextQuestionButton setTitle:@"Try another category." forState:UIControlStateNormal];
    }
    else{
        if (isSkipped) {
            self.popUpLabel.text = popupText;
        }
        else{
            if (isCorrect) {
                self.popUpLabel.text =  [NSString stringWithFormat:@"Congratulations! \nYour answer is correct. \n \n %@", popupText];
            }
            else{
                self.popUpLabel.text =  [NSString stringWithFormat:@"Wrong Answer! \nThe correct answer is %@. \n \n %@",correctAns, popupText];
            }
        }
        
        [self.okButton setHidden:YES];
        [self.nextQuestionButton setTitle:@"Next Question >" forState:UIControlStateNormal];
    }
    isCorrect = NO;
    isSkipped = NO;
    self.popUpVIew.center = bgView.center;
    self.popUpVIew.layer.cornerRadius = 10;
    self.popUpVIew.layer.masksToBounds = YES;
    
    [bgView addSubview:self.popUpVIew];
    [bgView bringSubviewToFront:self.popUpVIew];
    bgView.tag = 117;
    self.popUpVIew.alpha = 1.0;
    
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePopUp1)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    
    [bgView addGestureRecognizer:tapRecognizer];
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyGesture)];
    [tapRecognizer2 setNumberOfTapsRequired:1];
    [tapRecognizer2 setDelegate:self];
    
    [self.popUpVIew addGestureRecognizer:tapRecognizer2];
}


- (IBAction)crossTapped:(id)sender {
    
    [self removePopUp1];
}


-(void)removePopUp1{
    [self removePopupViewOfQuiz];
        [self nextQuestion];
    
}

-(void)removePopupViewOfQuiz{
    UIView* bgview = [self.view viewWithTag:117];
    [bgview removeFromSuperview];

}

- (IBAction)restartQuiz:(id)sender {
    [self removePopupViewOfQuiz];
    [self QuizInitiate];

    
    
}


-(void)emptyGesture{
    
}

@end
