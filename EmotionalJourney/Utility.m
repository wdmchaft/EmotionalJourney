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

@end
