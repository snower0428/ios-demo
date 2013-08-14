//
//  LHUtility.m
//  Demo
//
//  Created by leihui on 13-8-13.
//
//

#import "LHUtility.h"

BOOL stringIsEmpty(NSString *str)
{
	if (str == nil) {
		return YES;
	}
	if (![str isKindOfClass:[NSString class]]) {
		return YES;
	}
	if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

NSString *addDays(int days, NSString *fromDate)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:fromDate];
    [formatter release];
    
    NSString *strDate = @"";
    
    if (date != nil) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:days];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
        [components release];
        
        NSDateComponents *newComps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:newDate];
        strDate = [NSString stringWithFormat:@"%d-%02d-%02d", [newComps year], [newComps month], [newComps day]];
        [calendar release];
    }
    
    return strDate;
}

NSDate *addDaysFromDate(int days, NSDate *fromDate)
{
    NSDate *newDate = nil;
    
    if (fromDate != nil) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:days];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        newDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        [calendar release];
        [components release];
    }
    
    return newDate;
}

NSString *urlEncodeString(NSString *str)
{
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    [tempStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

long get_file_size( NSString *filenameStr)
{
    if (!filenameStr)
        return -1;
    const char *filename = [filenameStr UTF8String];
    FILE* fp = fopen( filename, "r" );
    if (fp==NULL) return -1;
    fseek( fp, 0L, SEEK_END );
    return ftell(fp);
}
