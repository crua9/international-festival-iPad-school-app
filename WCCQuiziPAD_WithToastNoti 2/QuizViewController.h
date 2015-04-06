//
//  QuizViewController.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface QuizViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
    
}
@property (strong, nonatomic) IBOutlet UIView *questionView;
@property (strong, nonatomic) NSString* catergory;
@property (strong, nonatomic) IBOutlet UITableView *questionTable;
@property (strong, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (assign, nonatomic) int catIndex;
@property (strong, nonatomic) IBOutlet UIView *popUpVIew;
@property (strong, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *popUpLabel;
@property (strong, nonatomic) IBOutlet UIImageView *QuestionHeaderImage;
@property (strong, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@end
