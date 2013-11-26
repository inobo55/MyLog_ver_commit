//
//  LogConfiguration.m
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import "LogConfiguration.h"

@implementation LogConfiguration

static NSString* LOGS_NAME = @"Log.Name";
static NSString* LOG_COFIGURATION_NAME = @"LogConfiguration.Name";

static NSString* QUESTION_NAME = @"Question.Name";
static NSString* ANSWER_NAME = @"Answer.Name";
static NSString* ANSWER_TYPE_NAME = @"AnswerType.Name";

static NSString *TYPE_NSString = @"テキスト";
static NSString* TYPE_NSNumber = @"点数";

+(NSMutableArray *)getLogs{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSDictionary *QandA1 = @{QUESTION_NAME:@"はじめての方への挨拶",ANSWER_NAME:@"こんにちは.はじめまして."};
    NSDictionary *QandA2 = @{QUESTION_NAME:@"このアプリは何に使うの？",ANSWER_NAME:@"あなたの気になるものを評価するアプリです"};
    NSDictionary *QandA3 = @{QUESTION_NAME:@"評価した後はどうするの?",ANSWER_NAME:@"人に見せてみましょう.\n何か楽しい話ができるかも"};
    NSMutableArray *Log = [[NSMutableArray alloc]initWithObjects:QandA1, QandA2,QandA3,nil];
    NSMutableArray *Logs = [[NSMutableArray alloc]initWithObjects:Log,nil];
    [ud registerDefaults:@{LOGS_NAME: Logs}];
    
    return [ud objectForKey:LOGS_NAME];
}

+(void)addLog:(NSMutableArray *)log{
    
    if([log isEqual:nil]){
        NSLog(@"addLog: log is nill");
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *logs = [[NSMutableArray alloc]initWithArray:self.getLogs];
    [logs insertObject:log atIndex:0];
    [ud setObject:logs forKey:LOGS_NAME];
    
    [self synchronize];
    
}

+(void)rmLog:(NSUInteger)index{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *logs = [[NSMutableArray alloc]initWithArray:self.getLogs];
    
    if([logs count] < index){
        NSLog(@"ERROR in rmLog:Logs do not have the index item. Index is :%i",index);
        return;
    }
    
    [logs removeObjectAtIndex:index];
    [ud setObject:logs forKey:LOGS_NAME];
    
    [self synchronize];
}

+(void)renewLog:(NSUInteger)index Log:(NSMutableArray *)log{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [self rmLog:index];
    NSMutableArray *logs = [[NSMutableArray alloc]initWithArray:[self getLogs]];
    [logs insertObject:log atIndex:index];
    [ud setObject:logs forKey:LOGS_NAME];
    
    [self synchronize];
    
}

+(void)replaceLog:(NSUInteger)from_index to:(NSUInteger)to_index{
    
    //to_indexの値をtmpに一時保存。to_indexにfrom_indexの値を代入。from_indexにto_indexの値を代入する。
    NSMutableArray *logs = [self getLogs];
    NSMutableArray *from_log = [logs objectAtIndex:from_index];
    NSMutableArray *to_log = [logs objectAtIndex:to_index];
    
    [self renewLog:from_index Log:to_log];
    [self renewLog:to_index Log:from_log];
    
}

+(void)renewQAtext:(NSDictionary*)QAtext log_index:(NSUInteger)log_index qa_index:(NSUInteger)qa_index{
    
    NSMutableArray *logs = [self getLogs];
    NSMutableArray *log = [[NSMutableArray alloc]initWithArray:[logs objectAtIndex:log_index]];
    [log removeObjectAtIndex:qa_index];
    [log insertObject:QAtext atIndex:qa_index];
    
    [self renewLog:log_index Log:log];
    
}

+(NSMutableArray *)getLogConfig{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *Qtext_Atype1 = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  @"何のレビュー？",QUESTION_NAME,@"テキスト",ANSWER_TYPE_NAME,
                                  nil];
    NSDictionary *Qtext_Atype2 = [[NSDictionary alloc]
                                  initWithObjectsAndKeys:
                                  @"どんな内容なのか？",QUESTION_NAME,@"テキスト",ANSWER_TYPE_NAME, nil];
    NSMutableArray *QAtypes = [[NSMutableArray alloc]initWithArray:@[Qtext_Atype1,Qtext_Atype2]];
    [ud registerDefaults:@{LOG_COFIGURATION_NAME: QAtypes}];
    
    NSLog(@"LogConfig:%@",[[ud objectForKey:LOG_COFIGURATION_NAME] debugDescription]);
    return [ud objectForKey:LOG_COFIGURATION_NAME];
    
}

+(void)addLogConfig:(NSDictionary *)Qtext_Atype{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *QAtypes = [[NSMutableArray alloc]initWithArray:[self getLogConfig]];
    [QAtypes addObject:Qtext_Atype];
    [ud setObject:QAtypes forKey:LOG_COFIGURATION_NAME];
    
    [self synchronize];
}

+(void)rmLogConfig:(NSUInteger)index{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *QAtypes = [[NSMutableArray alloc]initWithArray:[self getLogConfig]];
    
    if([QAtypes count] < index){
        NSLog(@"ERROR in rmLogConfig:QAtypes do not have the index item. Index is :%i",index);
        return;
    }
    [QAtypes removeObjectAtIndex:index];
    [ud setObject:QAtypes forKey:LOG_COFIGURATION_NAME];
    
    [self synchronize];
}

+(void)renewLogConfig:(NSUInteger)index Qtext_Atype:(NSDictionary *)Qtext_Atype{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *QAtypes = [[NSMutableArray alloc]initWithArray:[self getLogConfig]];
    [QAtypes replaceObjectAtIndex:index withObject:Qtext_Atype];
    
    [ud setObject:QAtypes forKey:LOG_COFIGURATION_NAME];
    
    [self synchronize];
}


+(void)synchronize{
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString*)getAnswerType:(NSString*)question{
    
    NSMutableArray *logConfig = [[NSMutableArray alloc]initWithArray:[self getLogConfig]];
    for (NSDictionary *Qtext_Atype in logConfig)
        if([question isEqual:[Qtext_Atype objectForKey:QUESTION_NAME]])
            return [Qtext_Atype objectForKey:ANSWER_TYPE_NAME];
    
    return nil;
}

+(NSString *)getTypeStringFromClass:(NSString*)class{
    
    NSRange range = [class rangeOfString:@"String"];
    if (range.location != NSNotFound)
        return @"テキスト";
    return @"点数";
}

+(NSDictionary *)createQAWith:(NSString *)question Answer:(id)answer{
    
    NSString *ConfigAtype = [self getAnswerType:question];
    
    NSString *Atype = [self getTypeStringFromClass:NSStringFromClass([answer class])];
    
    if(!question || !answer){
        NSLog(@"Your question or answer is nil.");
        return nil;
    }
    
    if([ConfigAtype isEqual:nil]){
        NSLog(@"Your question is not mattched with all questions in config.");
        return nil;
    }
    
    if(![ConfigAtype isEqual:Atype]){
        NSLog(@"Your answer type is not matched with config answer type. Your Type:%@. Config Type:%@"
              ,Atype,ConfigAtype);
        return nil;
    }
    
    NSDictionary *log = [[NSDictionary alloc]
                         initWithObjectsAndKeys:question,QUESTION_NAME,answer,ANSWER_NAME,nil];
    return log;
}

+(NSDictionary *)createQtext_Atype:(NSString *)question Atype:(NSString *)type{
    
    if([question isEqual:nil] || [type isEqual:nil])
    {
        NSLog(@"question or type is null");
        return nil;
    }
    
    NSDictionary *Qtext_Atype = [[NSDictionary alloc]
                                 initWithObjectsAndKeys:question,QUESTION_NAME,type,ANSWER_TYPE_NAME,nil];
    return Qtext_Atype;
    
}

+(NSString *)getQtextOfConfig:(NSUInteger)index{
    
    if(index >= [[LogConfiguration getLogConfig]count])
        return nil;
    return [[[self getLogConfig]objectAtIndex:index] objectForKey:QUESTION_NAME];
}

+(NSString*)getAtype:(NSUInteger)index{
    if(index >= [[LogConfiguration getLogConfig]count])
        return nil;
    return [[[self getLogConfig]objectAtIndex:index]objectForKey:ANSWER_TYPE_NAME];
}

+(NSMutableArray*)getLog:(NSUInteger)log_index{
    
    return [[self getLogs] objectAtIndex:log_index];
}

+(NSString*)getQtextOfLog:(NSUInteger)log_index qa_index:(NSUInteger)qa_index{
    
    if([[self getLog:log_index]count] <= qa_index)
        return @"No Question";
    return [[[self getLog:log_index]objectAtIndex:qa_index] objectForKey:QUESTION_NAME];
}

+(NSString*)getAnswer:(NSUInteger)log_index qa_index:(NSUInteger)qa_index{
   
    if([[self getLog:log_index]count] <= qa_index)
        return @"No Answer";
    
    id answer = [[[self getLog:log_index]objectAtIndex:qa_index] objectForKey:ANSWER_NAME];
    NSString *answer_type = [self getTypeStringFromClass:NSStringFromClass([answer class])]; //テキストor点数.
/*
    if([answer_type isEqualToString:@"点数"])
        return [NSString stringWithFormat:@"%d",[(NSNumber*)answer intValue]];
 */
    return answer;
}

+(NSMutableArray*)getTextAnswers:(NSUInteger)log_index{
    NSMutableArray *array = [self getOneTypeAnswers:log_index type:TYPE_NSString];
    if([array isEqual:@[]])
        return [[NSMutableArray alloc]initWithArray:@[@"No Answers"]];
    return array;
}

+(NSMutableArray*)getScoreAnswers:(NSUInteger)log_index{
    NSMutableArray *array = [self getOneTypeAnswers:log_index type:TYPE_NSNumber];
    if([array isEqual:@[]])
        return [[NSMutableArray alloc]initWithArray:@[@"No Scores"]];
    return array;
}

+(NSMutableArray*)getOneTypeAnswers:(NSUInteger)log_index type:(NSString*)type_name{
    NSMutableArray *text_answers = [[NSMutableArray alloc]init];
    NSMutableArray *log = [self getLog:log_index];
    for (NSDictionary *qa in log) {
        NSString *answer = [qa objectForKey:ANSWER_NAME];
        NSString *a_type = [self getTypeStringFromClass:NSStringFromClass([answer class])];
        if([a_type isEqualToString:type_name])
            [text_answers addObject:answer];
    }
    return text_answers;
}

+(NSMutableArray*)getTitlesFromLogs{
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    NSArray *logs = [self getLogs];
    for(NSArray *log in logs){
        NSDictionary *qa = [log objectAtIndex:0]; // 0 = title_string
        [titles addObject:[qa objectForKey:ANSWER_NAME]];
    }
    return titles;
}

@end
