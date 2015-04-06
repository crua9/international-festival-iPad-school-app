//
//  QuizQuestions.m
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

#import "QuizQuestions.h"

@implementation QuizQuestions

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


//this function is only experimental. Don't use it.
-(NSArray *)createQuizCollectionOfCategory:(NSString *)category{
    
    NSArray *QuizCollection = [[NSArray alloc] initWithObjects:[self CreateQuizArrayOfIndex:0],[self CreateQuizArrayOfIndex:1], nil];
    return QuizCollection;
    
    
}

//An array of quiz questions of a specific category are created by accessing database.
-(NSArray *)createQuizCollectionOfCategoryIndex:(int)category{
    
    NSArray *QuizQuestions = [[DBManager getSharedInstance] getDataFromDBWithCatrgory:category];
    NSArray *formattedQuizPack = [self formatQuizCollection2:QuizQuestions];
    return formattedQuizPack;
    
}


//An experimental Function, don't use it either.
-(NSDictionary *)CreateQuizArrayOfIndex:(int)index{
    NSString *question = [NSString stringWithFormat:@"Question %d",index];
    NSString *correctAns = @"Correct Answer";
    NSString *option1 = @"wrong answer 1";
    NSString *option2 = @"wrong answer 2";
    NSString *option3 = @"wrong answer 3";
    
    NSMutableArray *quizArray = [[NSMutableArray alloc] initWithObjects:correctAns,option1, option2, option3, nil];
    [quizArray exchangeObjectAtIndex:rand()%3 withObjectAtIndex:rand()%3];
    [quizArray exchangeObjectAtIndex:rand()%3 withObjectAtIndex:rand()%3];
    
    NSDictionary *quiz = [[NSDictionary alloc] initWithObjectsAndKeys:question,@"question", quizArray, @"options", correctAns, @"correctAnswer", nil];


    return quiz;
 
}


//From the array of quizzes fetched from DB, each quiz is formatted in a NSDictionary here.

-(NSArray *)formatQuizCollection2:(NSArray *)collection{
    NSMutableArray *QuizPack = [[NSMutableArray alloc]init];

    for ( NSArray *selectedQuiz in collection) {
    
    NSString *question = [selectedQuiz objectAtIndex:0];
    NSMutableIndexSet *optionIndexes = [[NSMutableIndexSet alloc]init];
    [optionIndexes addIndex:1];
     [optionIndexes addIndex:2];
     [optionIndexes addIndex:3];
     [optionIndexes addIndex:4];
    NSMutableArray *myOptions =  [[NSMutableArray alloc] initWithArray: [selectedQuiz objectsAtIndexes:optionIndexes]];
    NSNumber *correctAnswerindex = [selectedQuiz objectAtIndex:5];
    NSString *correctAnswer = [selectedQuiz objectAtIndex:[correctAnswerindex integerValue]+1];
        [myOptions exchangeObjectAtIndex:rand()%3 withObjectAtIndex:rand()%3];
        [myOptions exchangeObjectAtIndex:rand()%3 withObjectAtIndex:rand()%3];
//    NSLog(@"options %@", myOptions);
    NSString *imageName = [selectedQuiz objectAtIndex:6];
    NSString *popUpText = [selectedQuiz objectAtIndex:7];
    NSDictionary *quiz = [[NSDictionary alloc] initWithObjectsAndKeys:question,@"question", myOptions, @"options", correctAnswer, @"correctAnswer",imageName, @"image", popUpText, @"popupText", nil];
    [QuizPack addObject:quiz];
    
    }
    
    return QuizPack;
}


@end
