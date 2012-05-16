//
//  Utility.m
//  EmotionalJourney
//
//  Created by Administrator on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(int) getDateAsInt: (NSDate *) inputDate {
    
    NSTimeInterval interval = [inputDate timeIntervalSince1970];
    NSLog(@"getDateAsInt - Time Interval: %f", interval);
    return (int)interval;
}


+(NSDate *) getIntAsDate: (int) intDate {
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:intDate];
    NSLog(@"getIntAsDate - Date converted from time interval: %@", dateNow);
    return dateNow;
}


/** 
 * Utility method that returns the given 'int' as 'NSString'
 * @param   integer  int   The 'int' that has to be converted to type 'NSString'
 * @return  NSString       The 'int' that's been converted to 'NSString'
 * @created 6th May 2012
 */
+(NSString *) getIntAsString: (int) integer {
    return [[NSNumber numberWithInt:integer] stringValue];
}


/**
 * Utility method to concatenate three given strings
 * @param   string1  NSString  The first string to be concatenated
 * @param   string2  NSString  The second string to be concatenated
 * @param   string3  NSString  The third string to be concatenated
 * @return  NSString           The concatenated string
 * @created 6th May 2012
 */
+(NSString *) concatenateStringsInArray: (NSArray *) stringArray {

    NSMutableString *concatString = [[NSMutableString alloc] init];
    
    for (int index=0; index < [stringArray count]; index++) {
        [concatString appendString:[stringArray objectAtIndex:index]];
        NSLog(@"added string:%@", [stringArray objectAtIndex:index]);
    }    
    NSLog(@"concatenated string: %@", concatString);
    return concatString;
}

@end
