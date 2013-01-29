//
//  UIVCCalendarSetDay.m
//  Weather
//
//  Created by nd on 11-6-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIVCCalendarSetDay.h"
#import "Calendar.h"

#pragma mark -
@implementation UIVCCalendarSetDay

@synthesize dbYear, dbMonth, dbDay;

static UIVCCalendarSetDay *wi = nil;
static BOOL isGongLi = YES;

+ (UIVCCalendarSetDay*)getInstance
{
	if (!wi)
	{		
		wi = [[UIVCCalendarSetDay alloc] initWithNibName:@"UIVCCalendarSetDay" bundle:nil]; 
	}
	return wi;
}

+ (void) free
{
	if (wi)
	{
		[wi release];
		wi = nil;
	}
}

//公历转农历
- (void) Gong2Nong
{
	Calendar dar;
	DateInfo info_gl(nCurYear, nCurMonth, nCurDay);
	DateInfo info_nl;
	info_nl = dar.Lunar(info_gl);
	nCurYear_nl = info_nl.year;
	nCurMonth_nl = info_nl.month;
	nCurDay_nl = info_nl.day;	
}

//农历转公历
- (void) Nong2Gong
{
	Calendar dar;
	DateInfo info_gl;
	DateInfo info_nl(nCurYear_nl, nCurMonth_nl, nCurDay_nl);
	info_gl = dar.GetGlDate(info_nl);
	nCurYear = info_gl.year;
	nCurMonth = info_gl.month;
	nCurDay = info_gl.day;		
}

- (void) showDateInfo
{	
	Calendar dar;
	
	DateInfo info(nCurYear, nCurMonth, nCurDay);
	NSString *week =[NSString stringWithCString:dar.DayOfWeekZhou(info) encoding: NSUTF8StringEncoding];
	 
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(tabYear.tag+2) inSection:0];
	[tabYear scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; 
	[tabYear selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	
	scrollIndexPath = [NSIndexPath indexPathForRow:(tabMonth.tag+2) inSection:0];
	[tabMonth scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	[tabMonth selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	
	scrollIndexPath = [NSIndexPath indexPathForRow:(tabDay.tag+2) inSection:0];
	[tabDay scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	[tabDay selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];	
	
	lbGongli.text = [NSString stringWithFormat:@"%d年%d月%d日 周%@", 
					  nCurYear,
					  nCurMonth,
					  nCurDay,
					  week
					  ];
	if (isGongLi)
	{
		[btnGongli setBackgroundImage:[UIImage imageNamed:@"gongnong-2.png"] forState:UIControlStateNormal]; 
		[btnNongli setBackgroundImage:[UIImage imageNamed:@"gongnong-1.png"] forState:UIControlStateNormal]; 
	}
	else {
		[btnGongli setBackgroundImage:[UIImage imageNamed:@"gongnong-1.png"] forState:UIControlStateNormal]; 
		[btnNongli setBackgroundImage:[UIImage imageNamed:@"gongnong-2.png"] forState:UIControlStateNormal]; 
	}

}

const char *cDayName[]  = { "*","初一","初二","初三","初四","初五", /*农历日期名*/
	"初六","初七","初八","初九","初十",
	"十一","十二","十三","十四","十五",
	"十六","十七","十八","十九","二十",
	"廿一","廿二","廿三","廿四","廿五",
	"廿六","廿七","廿八","廿九","三十"};
const char *cMonName[]  = {"*","正月","二月","三月","四月","五月","六月", "七月","八月","九月","十月","十一","腊月"};

- (void) InitDay
{
	if (isGongLi)
	{
		tabYear.tag = nCurYear - 1950;
		tabMonth.tag = nCurMonth - 1;
		tabDay.tag = nCurDay - 1;		
		[self Gong2Nong];
	}
	else {
		tabYear.tag = nCurYear_nl - 1950;
		tabMonth.tag = nCurMonth_nl - 1;
		tabDay.tag = nCurDay_nl - 1;		
		[self Nong2Gong];
	}
	
	
	Calendar dar;
	int maxDay = 0;
	if (isGongLi)
		maxDay = dar.GetMonthDays(nCurYear, nCurMonth);
	else {
		maxDay = dar.MonthDays(nCurYear_nl, nCurMonth_nl);
	}
	
	[dbDay removeAllObjects];
	for (int i=1; i<=maxDay+4; i++) {
		if ((i<3)||(i>maxDay+2))
			[dbDay insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1]; 
		else
			if (isGongLi)
			{
				[dbDay insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];  
			}
			else
				[dbDay insertObject:[NSString stringWithCString:cDayName[i-2] encoding:NSUTF8StringEncoding]
								  atIndex:i-1];
	} 
	
	[tabDay reloadData];
	if (tabDay.tag>=maxDay) 
	{
		tabDay.tag = maxDay - 1;
	}
	NSLog(@"tabDay.tag=%d", tabDay.tag);
	
}


- (void) InitDB
{
	[self.dbYear removeAllObjects];
	[self.dbMonth removeAllObjects];
	for (int i=1950; i<=2050+4; i++) {
		if ((i<1950+2)||(i>2050+2))
			[dbYear insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1950]; 
		else
			[dbYear	insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1950];
	}
	for (int i=1; i<=12+4; i++) {
		if ((i<3)||(i>12+2))
			[dbMonth insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1]; 
		else
			if (isGongLi)
			{
				[dbMonth insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];  
			}
			else
				[dbMonth insertObject:[NSString stringWithCString:cMonName[i-2] encoding:NSUTF8StringEncoding]
							  atIndex:i-1]; 
	}
}


- (void) showSetDay: (NSInteger) _nCurYear  
			  month: (NSInteger) _nCurMonth 
				day: (NSInteger) _nCurDay 
		 parentView: (UIView *) FParentView
		parentClass: (NSObject*) FParentClass
	 responseMethod: (SEL) FResponseMethod
{
	nCurRili = 0;
	class_func_owner = FParentClass;
	class_func_responseData = FResponseMethod;
    [FParentView addSubview:self.view];	

	nCurYear = _nCurYear;
	nCurMonth = _nCurMonth;
	nCurDay = _nCurDay;
	[self Gong2Nong];
	
	[tabYear reloadData];
	[tabMonth reloadData];
	
	if (nCurYear < 1950)
		nCurYear = 1950;
	if (nCurYear > 2050)
		nCurYear = 2050;
	
	[self InitDay];	
	[self showDateInfo];
}

- (void) showSetSpecDay: (NSInteger) _nCurRili
                   year: (NSInteger) _nCurYear  
				  month: (NSInteger) _nCurMonth 
					day: (NSInteger) _nCurDay 
			 parentView: (UIView *) FParentView
			parentClass: (NSObject*) FParentClass
		 responseMethod: (SEL) FResponseMethod
{
	nCurRili = _nCurRili;
	class_func_owner = FParentClass;
	class_func_responseData = FResponseMethod;
    [FParentView addSubview:self.view];
	
	if (nCurRili == 1)
	{
		nCurYear = _nCurYear;
		nCurMonth = _nCurMonth;
		nCurDay = _nCurDay;
		btnGongli.selected = YES;
		btnNongli.selected = NO;
		isGongLi = YES;
		[self Gong2Nong];
	}
	else {
		nCurYear_nl = _nCurYear;
		nCurMonth_nl = _nCurMonth;
		nCurDay_nl = _nCurDay;
		btnGongli.selected = NO;
		btnNongli.selected = YES;
		isGongLi = NO;
		[self Nong2Gong];
	}
	
	[self InitDB];
	[tabYear reloadData];
	[tabMonth reloadData];
	
	[self InitDay];
	[self showDateInfo];
}

- (IBAction)returnBtnPress:(id)sender
{ 
    // 释放窗口
    [self.view removeFromSuperview]; 	
}
 


- (IBAction)btnGongliClick:(id)sender
{
	if (isGongLi)
		return;
	
	isGongLi = YES;
	[dbMonth removeAllObjects];
	for (int i=1; i<=12+4; i++) {
		if ((i<3)||(i>12+2))
			[dbMonth insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1]; 
		else
			if (isGongLi)
			{
				[dbMonth insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];  
			}
			else
				[dbMonth insertObject:[NSString stringWithCString:cMonName[i-2] encoding:NSUTF8StringEncoding]
							  atIndex:i-1]; 
	}
	[tabMonth reloadData];
	[self InitDay];
	[self showDateInfo];
}

- (IBAction)btnNongliClick:(id)sender
{
	if (!isGongLi)
		return;
	
	isGongLi = NO;
	[dbMonth removeAllObjects];
	for (int i=1; i<=12+4; i++) {
		if ((i<3)||(i>12+2))
			[dbMonth insertObject:[NSString stringWithFormat:@"%d", 0] atIndex:i-1]; 
		else
			if (isGongLi)
			{
				[dbMonth insertObject:[NSString stringWithFormat:@"%d", i-2] atIndex:i-1];  
			}
			else
				[dbMonth insertObject:[NSString stringWithCString:cMonName[i-2] encoding:NSUTF8StringEncoding]
							  atIndex:i-1]; 
	}
	[tabMonth reloadData];
	[self InitDay];
	[self showDateInfo];
}


- (IBAction)pressCurDay:(id)sender
{
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps;
	
	// 年月日获得
	comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
						fromDate:date];
	nCurYear = [comps year];
	nCurMonth = [comps month];
	nCurDay = [comps day];
	[self Gong2Nong];
	
	[self InitDay];

	[self showDateInfo];	
}

- (IBAction)pressSetDay:(id)sender
{		
	NSString* newDate;
	
    if (isGongLi)
    {
        nCurDay = tabDay.tag + 1;
        [self Gong2Nong];
    }
    else {
        nCurDay_nl = tabDay.tag + 1;
        [self Nong2Gong];
    }
    
	[self showDateInfo];
    
	if (nCurRili == 0)
		newDate = [NSString stringWithFormat:@"%d", nCurYear * 100 * 100 + nCurMonth * 100 + nCurDay];
	else if (isGongLi)
		newDate = [NSString stringWithFormat:@"1%d", nCurYear * 100 * 100 + nCurMonth * 100 + nCurDay];
	else
		newDate = [NSString stringWithFormat:@"2%d", nCurYear_nl * 100 * 100 + nCurMonth_nl * 100 + nCurDay_nl];
	
	// 释放窗口
	[self.view removeFromSuperview];	

	[class_func_owner performSelector:class_func_responseData withObject:newDate];	  
}
 
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		dbYear = [[NSMutableArray alloc] init];
		dbMonth = [[NSMutableArray alloc] init];
		dbDay = [[NSMutableArray alloc] init];
        [self InitDB];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    btnGongli.hidden = YES;
    btnNongli.hidden = YES;
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dbYear release];
	[dbMonth release];
	[dbDay release];
	self.dbYear = nil;
	self.dbMonth = nil;
	self.dbDay = nil;
	
	[tabYear release];
	[tabMonth release];
	[tabDay release];
	[lbGongli release];
	[btnGongli release];
	[btnNongli release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (tableView == tabYear)
	{
		NSInteger n = dbYear.count;//[self.dbData count];
		return n;
	}
	else if (tableView == tabMonth)
	{
		NSInteger n = dbMonth.count;//[self.dbData count];
		return n;
	}
	else {
		NSInteger n = dbDay.count;//[self.dbData count];
		return n;
	}
	
}




-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier ";     
		
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
	NSInteger  index = indexPath.row;
	
    if (cell == nil) {
		//UITableViewCellStyleDefault UITableViewCellStyleSubtitle
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease]; 
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	 
	}	
	
	
	if (tableView == tabYear)
	{
		NSString *oneCity = (NSString*)[dbYear objectAtIndex:index];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.text = oneCity; 	 
		
		return cell;
	}
	else if (tableView == tabMonth)
	{
		NSString *oneCity = (NSString*)[dbMonth objectAtIndex:index];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.text = oneCity; 		
		return cell;
	}
	else {
		NSString *oneCity = (NSString*)[dbDay objectAtIndex:index];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.text = oneCity; 					
		return cell;
	}
	
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {   
    NSLog(@"ROW clicked");
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (tableView == tabYear) 
	{
		if (indexPath.row < 3)
			tableView.tag = 0;
		else if (indexPath.row >= dbYear.count - 2)
			tableView.tag = dbYear.count - 5;
		else 
			tableView.tag = indexPath.row - 2;
	}	
	if (tableView == tabMonth) 
	{
		if (indexPath.row < 3)
			tableView.tag = 0;
		else if (indexPath.row >= dbMonth.count - 2)
			tableView.tag = dbMonth.count - 5;
		else 
			tableView.tag = indexPath.row - 2;
	}	
	if (tableView == tabDay) 
	{
		if (indexPath.row < 3)
			tableView.tag = 0;
		else if (indexPath.row >= dbDay.count - 2)
			tableView.tag = dbDay.count - 5;
		else 
			tableView.tag = indexPath.row - 2;
	}
	
	if ((tableView == tabYear) || (tableView == tabMonth))
	{ 
		if (isGongLi)
		{
			nCurYear = tabYear.tag + 1950;
			nCurMonth = tabMonth.tag + 1;
			nCurDay = tabDay.tag + 1;
			[self Gong2Nong];
		}
		else {
			nCurYear_nl = tabYear.tag + 1950;
			nCurMonth_nl = tabMonth.tag + 1;
			nCurDay_nl = tabDay.tag + 1;
			[self Nong2Gong];
		}
		[self InitDay];
	}
	else {
		if (isGongLi)
		{
			nCurDay = tabDay.tag + 1;
			[self Gong2Nong];
		}
		else {
			nCurDay_nl = tabDay.tag + 1;
			[self Nong2Gong];
		}

	}
	
	[self showDateInfo];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	BOOL bDir = scrollView.contentOffset.y > lastTableViewYContentOffset;
	BOOL bDiff = fabs(scrollView.contentOffset.y - lastTableViewYContentOffset) > 15;
	NSLog(@"scrollViewDidEndDecelerating new.y=%f old.y=%f diff=%f ", scrollView.contentOffset.y, lastTableViewYContentOffset,
		  scrollView.contentOffset.y - lastTableViewYContentOffset); 
	
	UITableView *tableView = (id)scrollView; 
	
	NSArray *visibleCells;	
	NSIndexPath *indexPath; 
	
	visibleCells = [NSArray arrayWithArray:[tableView indexPathsForVisibleRows]];
	NSLog(@"visibleCells.count=%d scrollView.contentOffset.y=%f", visibleCells.count, scrollView.contentOffset.y);
	if (visibleCells.count % 2 == 1)
		indexPath = [visibleCells objectAtIndex:(visibleCells.count)/2];
	else {
		if (visibleCells.count>=3)
		{
			if (bDir && bDiff)
				indexPath = [visibleCells objectAtIndex:2];
			else if (!bDir && bDiff)
				indexPath = [visibleCells objectAtIndex:1];
			else if (bDir && !bDiff)
				indexPath = [visibleCells objectAtIndex:1];
			else {				
				indexPath = [visibleCells objectAtIndex:2];
			} 
		}
	}
	
	if (visibleCells.count>=3)
	{
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"contentOffset: %f", scrollView.contentOffset.y);
	lastTableViewYContentOffset = scrollView.contentOffset.y;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView            
                  willDecelerate:(BOOL)decelerate
{
	NSLog(@"%@", @"scrollViewDidEndDragging");
	if (!decelerate)
		[self scrollViewDidEndDecelerating: scrollView]; 
}

@end


