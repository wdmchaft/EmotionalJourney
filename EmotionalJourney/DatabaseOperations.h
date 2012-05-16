//
//  DatabaseOperations.h
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseOperations : NSObject

// The Singleton DB instance
+(DatabaseOperations *) dbOpsSingleton;

@property (nonatomic) sqlite3 *database;
@property (nonatomic, retain) NSMutableArray *arrayInput;


// Method to create the table in DB, with three fields/columns
-(void) createTableNamed:(NSString *) tableName
              withField1:(NSString *) field1
              withField2:(NSString *) field2
              withField3:(NSString *) field3
              withField4:(NSString *) field4;
    
// Method to fetch the database that's present in the device
-(NSString *) filePath; 

// Method to open the database
-(void) openDB;

-(NSMutableArray *) getAllRowsFromTableNamed: (NSString *) tableName;

-(void) insertRecordIntoTableNamed: (NSString *) tableName
                        withField1: (NSString *) field1
                       field1Value: (int) field1Value
                        withField2: (NSString *) field2
                       field2Value:(int) field2Value
                        withField3: (NSString *) field3
                       field3Value:(NSString *) field3Value
                        withField4: (NSString *) field4
                       field4Value:(UIImage *) field4Value;

// Method to close the database
-(int) closeDB;

// Keeps a count of the emoticon types' occurrence-frequency
-(void) countEmoticons: (int) field2;

-(void) addToArrayField1: (int) field1
                  Field2: (int) field2
                  Field3: (int) field3
                  Field4: (UIImage *) field4;


-(NSArray *) getDataBetweenDates: (NSString *) tableName 
                          withStartDate: (NSDate *) dateStart
                            withEndDate: (NSDate *) dateEnd;

@end
