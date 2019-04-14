//
//  DBManager.h
//  MoviesList
//
//  Created by Doaa Tantawy on 8/2/1440 AH.
//  Copyright © 1440 AH Doaa Tantawy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
-(void)copyDatabaseIntoDocumentsDirectory;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end

