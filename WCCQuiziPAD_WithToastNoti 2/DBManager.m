//
//  DBManager.m
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

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager{
    BOOL isSuccess;
}

+(DBManager*)getSharedInstance{
    
    //get a shared Instance here
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        
    }
    return sharedInstance;
}

-(NSArray *) getDataFromDBWithCatrgory:(int)categoryIndex{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databasePath = [[NSBundle mainBundle] pathForResource:@"Questions_final" ofType:@"sqlite"];
    
    
    isSuccess = YES;
    const char *dbpath = [databasePath UTF8String];
    //open and access the database
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM all_in_one WHERE category LIKE %d ORDER BY RANDOM() LIMIT 10",categoryIndex];
        if (categoryIndex == 4) {
            querySQL = @"SELECT * FROM all_in_one ORDER BY RANDOM() LIMIT 10";
        }

        const char *query_stmt = [querySQL UTF8String];
        
      
        NSMutableArray *questionsAll = [[NSMutableArray alloc] init];
        
        
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, nil) == SQLITE_OK)
        {

           
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                NSString *question = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:question];
                
                NSString *option1 = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:option1];
                
                NSString *option2 = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:option2];
                
                NSString *option3 = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 3)];
                [resultArray addObject:option3];
              
                NSString *option4 = @""; //[[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                [resultArray addObject:option4];
                
                NSString *correctAnswerIndex = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 5)];
                NSNumber *correcrAnsIndexInt = [self getIndexvalueFromColumnName:correctAnswerIndex];
                [resultArray addObject:correcrAnsIndexInt];
                
                NSString *imageName = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 7)];
                [resultArray addObject:imageName];
                
                NSString *popUpText = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 8)];
                [resultArray addObject:popUpText];
                
                [questionsAll addObject:resultArray];
                
                
                
            }
             sqlite3_finalize(statement);
            sqlite3_close(database);
            return questionsAll;
//            sqlite3_reset(statement);
        }
    }
    return nil;
    
}

-(NSNumber *)getIndexvalueFromColumnName:(NSString *)columnValue{
    
    //convert correct Answer alphabet to array index number.
    if ([columnValue isEqualToString:@"A"]) {
        return [NSNumber numberWithInt:0];
    }
    else if ([columnValue isEqualToString:@"B"]){
        return [NSNumber numberWithInt:1];
    }
    else if ([columnValue isEqualToString:@"C"]){
        return [NSNumber numberWithInt:2];
    }
    else if ([columnValue isEqualToString:@"D"]){
        return [NSNumber numberWithInt:3];
    }
    else{
        return [NSNumber numberWithInt:0];
    }
    
    
}

// an attempt to print the sqlite3 statement but it has failed it's purpose
-(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement
{
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"{\"statement\":["];
    for (int c = 0; c < sqlite3_column_count(statement); c++){
        [s appendFormat:@"{\"column\":\"%@\",\"value\":\"%@\"}",[NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, c)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, c)]];
        if (c < sqlite3_column_count(statement) - 1)
            [s appendString:@","];
    }
    [s appendString:@"]}"];
    return s;
}


@end
