//
//  DatabaseOperations.m
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DatabaseOperations.h"
#import "Utility.h"

#define kEmotionJustOkay 0
#define kEmotionHappy 1
#define kEmotionOverjoyed 2
#define kEmotionRomantic 3
#define kEmotionSad 4
#define kEmotionDepressed 5
#define kEmotionAngry 6


@implementation DatabaseOperations

@synthesize database;
@synthesize arrayInput;

static DatabaseOperations *dbOps = nil;
NSInteger rowsCount = 0;
NSInteger emoticon1Count = 0;
NSInteger emoticon2Count = 0;
NSInteger emoticon3Count = 0;
NSInteger emoticon4Count = 0;
NSInteger emoticon5Count = 0;
NSInteger emoticon6Count = 0;
NSInteger emoticon7Count = 0;


+(DatabaseOperations *) dbOpsSingleton {
    if (dbOps == nil) {
        dbOps = [[DatabaseOperations alloc] init];
        [dbOps openDB];
    }
    return dbOps;
}


// Fetch the database from the device
+(NSString *) filePath {
    NSLog(@"filepath");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"databaseEmotionalJourney.sql"];
}


// Open the Database, if it already exists; else, create a new one
-(void) openDB {
    
    NSLog(@"openDB : Opening the DB");
    
    if (sqlite3_open([[DatabaseOperations filePath] UTF8String], &database) != SQLITE_OK ) {
        NSLog(@"openDB : closing DB; failure to open");
        sqlite3_close(database);
        NSAssert(0, @"Database failed to open.");
        
    } else {
        NSLog(@"openDB : opened the DB");
        NSLog(@"Successfully opened the database");
    }
}


/**
 * Closes the database connection
 * @return dbClosure  (int) - The result of the attempt to close the database connection
 */
-(int) closeDB {
    NSLog(@"close db");
    int dbClosure = sqlite3_close(database);
    
    if (dbClosure == SQLITE_OK) {
        NSLog(@"Closed the database connection successfully");
        
    } else {
        NSLog(@"Could not close the database connection");
    }
    
    return dbClosure;
}



/**
 * Create the database table, if not already exists, to persist data
 * tableName  (NSString)  -  Name of the table
 * field1     (NSString)  -  first column's name
 * field2     (NSString)  -  second column's name
 * field3     (NSString)  -  third column's name
 * field4     (NSString)  -  fourth column's name
 */
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2
              withField3:(NSString *) field3
              withField4:(NSString *) field4 {
    
    NSLog(@"create table");
    char *error;
    NSString *createQuery = 
                [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' BLOB);", tableName, field1, field2, field3, field4];
    
    if (sqlite3_exec(database, [createQuery UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Table could not be created.");
        NSLog(@"Table creation failed");
        
    } else {
        NSLog(@"Table created successfully");
    }
    
    self.arrayInput = [[NSMutableArray alloc] init];
}



/**
 * Insert data into the table. Input the data entered by the user.
 * 
 * @param tableName   (NSString)   - the table into which the data is inserted into
 * @param withField2  (NSString)   - the name of the second field i.e. 'emoticon' here
 * @param field2Value (int)        - the integer mapped to the emoticon the user chose
 * @param withField3  (NSString)   - the name of the 2nd field i.e. 'sleep' here
 * @param field3Value (NSString)   - the value chosen by the user for 'sleep', which can be either 'yes' or 'no'
 *
 * @created 23rd Apr 2012
 */
-(void) insertRecordIntoTableNamed: (NSString *) tableName
                        withField1:(NSString *)field1 
                        field1Value:(int)field1Value
                        withField2: (NSString *) field2
                        field2Value: (int) field2Value
                        withField3: (NSString *) field3
                        field3Value: (NSString *) field3Value
                        withField4: (NSString *) field4
                        field4Value: (UIImage *) field4Value {
    
    NSLog(@"insertRecord: Entered");

    
    NSString *query = [NSString stringWithFormat:
                       @"INSERT OR REPLACE INTO '%@' ('%@', '%@', '%@', '%@') VALUES (?,?,?,?)", tableName, field1, field2, field3, field4];
    const char *queryInsertion = [query UTF8String];
    

    // Now, insert the placeholder values
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, queryInsertion, -1, &statement, nil) == SQLITE_OK ) {
        sqlite3_bind_int(statement, 1, field1Value);
        sqlite3_bind_int(statement, 2, field2Value);
        sqlite3_bind_text(statement, 3, [field3Value UTF8String], -1, NULL);
    
        // Convert the picture, if any, to bytes
        if (field4Value != nil) {
            NSData *imageData = UIImagePNGRepresentation(field4Value);        
            sqlite3_bind_blob(statement, 4, [imageData bytes], [imageData length], NULL);
            NSLog(@"Inserted the pic into DB");
            
        } else {
            sqlite3_bind_blob(statement, 4, nil, -1, NULL);
            NSLog(@"no pic to insert into DB");
        }
    }
    
    NSLog(@"Inserted new record into the table with the values %d, %d, %@", 
                            field1Value, field2Value, field3Value);
    
    // Execute the statement
    if ( sqlite3_step ( statement ) != SQLITE_DONE ) {
        NSAssert(0, @"Error updating table");
    }
    sqlite3_finalize(statement);
}



/** 
 * Fetches all the data from the specified table
 * 
 * @param  tableName  (NSString)  - the table name from which to fetch the values
 * @return (NSArray)              - an array with the values:
 *                                      1. Total num of rows in the table
 *                                      2. Count of rows with the value of emoticon1
 *                                      3. Count of rows with the value of emoticon2
 *                                      4. Count of rows with the value of emoticon3
 *                                                                      in that order
 */
-(NSMutableArray *) getAllRowsFromTableNamed: (NSString *) tableName {
    
    NSLog(@"getAllRowsFromTable: Entered");
    
    sqlite3_stmt *statement;
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    // Fetch the data from the table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
 
        NSLog(@"getAllRowsFromTable: got the query executed");
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
        
            NSLog(@"Stepping through the rows");
            
            rowsCount = rowsCount+1;
            
            // Get the first field's value i.e. of 'time'
            int field1 = sqlite3_column_int (statement, 0);
            //NSLog(@"got field1 value: %d", field1);
            
            // Get the second value, i.e., that of 'emoticon'
            int field2 = (int) sqlite3_column_int(statement, 1);
            //NSString *field2Str = [[NSString alloc] initWithUTF8String: field1];
            //NSLog(@"got field2 value: %d", field2);
            // Make a count of each emoticon type
            [self countEmoticons:field2];
            
            // Get the third field's value of 'text'
            char *field3 = (char *) sqlite3_column_text(statement, 2);
            NSString *field3Str = [[NSString alloc] initWithUTF8String: field3];
            //NSLog(@"got field3 value: %@", field3Str);
            
            // Get the fourth filed i.e. the picture, if any
            UIImage *field4 = nil;
            NSData *picData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 3) length:sqlite3_column_bytes(statement, 3)];
            if (picData == nil) {
                NSLog(@"No picture present");
            } else {
                field4 = [UIImage imageWithData:picData];
            }
            
            // Display them
            NSString *str = [[NSString alloc] initWithFormat:@"%d - %d - %@", 
                                    field1, field2, field3Str];
            NSLog(@"%@", str);
            
            [self addToArrayField1:field1 
                            Field2:field2 
                            Field3:field3Str
                            Field4:field4];
            
            // Now, time to be a good Memory Citizen!
            field3Str = nil;
            str = nil;
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        NSLog(@"Num of rows:%d ; Emoticon1:%d ; Emoticon2:%d ; Emoticon3:%d", 
                            rowsCount, emoticon1Count, emoticon2Count, emoticon3Count);
        NSLog(@"Num Returned: %d", [arrayInput count]); 
        return arrayInput;        
    }
    return nil;
}



/**
 * Keeps a count of the emoticon types' occurrence-frequency
 * @param 
 *
 */
-(void) countEmoticons: (int) field2 {
    
    if (field2 == kEmotionJustOkay) {
        emoticon1Count = emoticon1Count + 1;
        
    } else if (field2 == kEmotionHappy) {
        emoticon2Count = emoticon2Count + 1;
        
    } else if (field2 == kEmotionOverjoyed) {
        emoticon3Count = emoticon3Count + 1;
    
    } else if (field2 == kEmotionRomantic) {
        emoticon4Count = emoticon4Count + 1;
        
    } else if (field2 == kEmotionSad) {
        emoticon5Count = emoticon5Count + 1;
        
    } else if (field2 == kEmotionDepressed) {
        emoticon6Count = emoticon6Count + 1;
        
    } else if (field2 == kEmotionAngry) {
        emoticon7Count = emoticon7Count + 1;
    }
}

             

-(void) addToArrayField1: (int) field1
                Field2: (int) field2
                Field3: (NSString *) field3  
                Field4: (UIImage *) field4 {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:field1], @"time",
                                            [NSNumber numberWithInt:field2], @"emotion",
                                            field3, @"text", 
                                            field4, @"picture",
                                            nil];
    [arrayInput insertObject:dict atIndex:0];
    NSLog(@"Added data %d - %d - %@ from DB to Array; new array size:%d", field1, field2, field3, [arrayInput count]);
}



/**
 * Fetches the data that fall between the given dates
 * @param  tableName  NSString  The table from which the data is fetched
 * @param  dateStart  NSDate    The date 'from' which to fetch the data
 * @param  dateEnd    NSDate    The date 'until' which to fetch the data
 * @return NSArray    Array with the count of each mood type between the given dates
 * @created 5th May 2012
 * @sf(read)
 */
-(NSArray *) getDataBetweenDates: (NSString *) tableName 
                          withStartDate: (NSDate *) dateStart
                            withEndDate: (NSDate *) dateEnd {
    
    NSLog(@"getDataBetweenDates: Entered");
    sqlite3_stmt *statement;
    NSMutableArray *arrayResults = [[NSMutableArray alloc] init];
    
    int intStartDate = [Utility getDateAsInt:dateStart];
    int intEndDate   = [Utility getDateAsInt:dateEnd];
    
    NSLog(@"Start date %@ as int: %d", dateStart, intStartDate);
    NSLog(@"End date %@ as int  : %d", dateEnd, intEndDate);
    
    NSString *queryFetch = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (time >= %d) AND (time <= %d)", tableName, intStartDate, intEndDate];
    
    NSLog(@"getDataBetweenDates: created query");
    
    // Fetch the data from the table
    if (sqlite3_prepare_v2 ( database, [queryFetch UTF8String], -1, &statement, nil ) == SQLITE_OK) {
        
        NSLog(@"getDataBetweenDates: prepared stmt");
        
        int field1;
        char *field2;
        NSString *field2Str;
        NSString *str;
        NSInteger rowsCount = 0;
        NSInteger mood1Count = 0;
        NSInteger mood2Count = 0;
        NSInteger mood3Count = 0;
        NSInteger mood4Count = 0;
        NSInteger mood5Count = 0;
        NSInteger mood6Count = 0;
        NSInteger mood7Count = 0;
        
        
        // Iterate through the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSLog(@"getDataBetweenDates: stepping thro result");
            
            rowsCount = rowsCount+1;
            
            // Get the first value, i.e., that of 'emotion'
            field1 = sqlite3_column_int(statement, 1);
            //field1Str = [[NSString alloc] initWithUTF8String: field1];
            
            
            switch (field1) {
                    
                case kEmotionJustOkay:
                    mood1Count = mood1Count + 1;
                    break;
                    
                case kEmotionHappy:
                    mood2Count = mood2Count + 1;
                    break;
                    
                case kEmotionOverjoyed:
                    mood3Count = mood3Count + 1;
                    break;
                    
                case kEmotionRomantic:
                    mood4Count = mood4Count + 1;
                    break;
                    
                case kEmotionSad:
                    mood5Count = mood5Count + 1;
                    break;
                    
                case kEmotionDepressed:
                    mood6Count = mood6Count + 1;
                    break;
                    
                case kEmotionAngry:
                    mood7Count = mood7Count + 1;
                    break;
                    
                default:
                    break;
            }
            
            // Get the value of 'text'
            field2 = (char *) sqlite3_column_text(statement, 2);
            field2Str = [[NSString alloc] initWithUTF8String: field2];
            
            // Get the 'date'
            //field3 = (char *) sqlite3_column_text(statement, 2);
            //field3Str = [[NSString alloc] initWithUTF8String: field3];
            
            // Display 'em
            str = [[NSString alloc] initWithFormat:@"%d - %@", field1, field2Str];
            NSLog(@"%@", str);
        }
        
        // delete the compiled statement from memory
        sqlite3_finalize(statement);
        
        NSLog(@"Num of rows:%d ; Mood1:%d ; Mood2:%d ; Mood3:%d", rowsCount, mood1Count, mood2Count, mood3Count);
        NSLog(@"Mood4:%d ; Mood5:%d ; Mood6:%d ; Mood7:%d", mood4Count, mood5Count, mood6Count, mood7Count);
        
        // Now, time to be a good Memory Citizen!
        field2Str = nil;
        field2 = nil;
        str = nil;
        
        return [[NSArray alloc] initWithObjects:
                                        [NSNumber numberWithInteger:(mood1Count)],
                                        [NSNumber numberWithInteger:(mood2Count)],
                                        [NSNumber numberWithInteger:(mood3Count)],
                                        [NSNumber numberWithInteger:(mood4Count)],
                                        [NSNumber numberWithInteger:(mood5Count)],
                                        [NSNumber numberWithInteger:(mood6Count)],
                                        [NSNumber numberWithInteger:(mood7Count)],
                                        nil];
    }
    return arrayResults;
}

@end
