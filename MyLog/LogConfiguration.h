//
//  LogConfiguration.h
//  MyLog
//
//  Created by inoue on 2013/10/11.
//  Copyright (c) 2013年 inobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogConfiguration : NSObject

/*
 
 NSUserDefault {LOGS_NAME:(NSMutableArray)logs,LOG_CONFIG_NAME:(NSMutableArray)QAtypes};
 
  logs [(NSMutableArray)log1,log2,....,logN];
   log [(NSDictionry){Q:(NSString)question,A:(id)answer},{QA},...,{QA}];

  QAtypes [(NSDictionry)Qtext_Atype1,Qtext_Atype2,.....,Qtext_AtypeN];
   Qtext_Atype {Q:(NSString)question,Atype:(NSString)type};
 
 */

+ (NSMutableArray*)getLogs;
+ (void)addLog:(NSMutableArray*)log;
+ (void)rmLog:(NSUInteger)index;
+ (void)renewLog:(NSUInteger)index Log:(NSMutableArray*)log;
+ (void)replaceLog:(NSUInteger)from_index to:(NSUInteger)to_index;
+ (void)renewQAtext:(NSDictionary*)QAtext log_index:(NSUInteger)log_index qa_index:(NSUInteger)qa_index;

+ (NSMutableArray*)getLogConfig;
+ (void)addLogConfig:(NSDictionary*)Qtext_Atype;
+ (void)rmLogConfig:(NSUInteger)index;
+ (void)renewLogConfig:(NSUInteger)index Qtext_Atype:(NSDictionary*)Qtext_Atype;

+ (void)synchronize;

+ (NSDictionary*)createQAWith:(NSString*)question Answer:(id)answer;
+ (NSDictionary*)createQtext_Atype:(NSString*)question Atype:(NSString*)type;


+ (NSMutableArray*)getLog:(NSUInteger)log_index;

+ (NSString*)getQtextOfConfig:(NSUInteger)index;
+ (NSString*)getAtype:(NSUInteger)index;

+ (NSString*)getQtextOfLog:(NSUInteger)log_index qa_index:(NSUInteger)qa_index;
+ (NSString*)getAnswer:(NSUInteger)log_index qa_index:(NSUInteger)qa_index;


+ (NSMutableArray*)getTextAnswers:(NSUInteger)log_index; // LogsViewに使用
+ (NSMutableArray*)getScoreAnswers:(NSUInteger)log_index; //

+ (NSArray*)getTitlesFromLogs; //検索に使用

+ (NSString *)getTypeStringFromClass:(NSString*)class;



@end
