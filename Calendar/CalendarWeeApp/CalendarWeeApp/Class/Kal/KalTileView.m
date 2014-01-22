/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "KalSkinManager.h"
#import "CnCalendar.h"
#import "UIImage+Category.h"

extern const CGSize kTileSize;

@implementation KalTileView

@synthesize date;
@synthesize style;
@synthesize isInDiyMode;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        origin = frame.origin;
        [self resetState];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:kChangeSkinNotification object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    double start = [[NSDate date] timeIntervalSince1970];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat fontSize = 16.0f*kScaleFactor;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *shadowColor = nil;
    UIColor *textColor = nil;
//    UIImage *markerImage = nil;
//    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    
//    CGContextTranslateCTM(ctx, 0, kTileSize.height);
//    CGContextScaleCTM(ctx, 1, -1);
    
    if (!isInDiyMode) {
        if ([self isToday] && self.selected) {
//            UIImage *image = [[UIImageManager shareInstance] imageWithFileName:@"Calendar/tile_today_selected.png"];
//            [[image stretchableImageWithLeftCapWidth:8 topCapHeight:0] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
//            markerImage = [UIImage imageNamed:@"Kal.bundle/vaccine_btn_mark.png"];
        }
        else if ([self isToday] && !self.selected) {
//            UIImage *image = [[UIImageManager shareInstance] imageWithFileName:@"Calendar/tile_today.png"];
//            [[image stretchableImageWithLeftCapWidth:8 topCapHeight:0] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
            [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
//            markerImage = [UIImage imageNamed:@"Kal.bundle/vaccine_btn_mark.png"];
        }
        else if (self.selected) {
//            UIImage *image = [[UIImageManager shareInstance] imageWithFileName:@"Calendar/tile_selected.png"];
//            [[image stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor blackColor];
//            markerImage = [UIImage imageNamed:@"Kal.bundle/vaccine_btn_mark.png"];
        }
        else if (self.belongsToAdjacentMonth) {
            textColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
            shadowColor = nil;
//            markerImage = [UIImage imageNamed:@"Kal.bundle/vaccine_btn_mark.png"];
        }
        else {
            textColor = [UIColor whiteColor];
            shadowColor = [UIColor whiteColor];
//            markerImage = [UIImage imageNamed:@"Kal.bundle/vaccine_btn_mark.png"];
        }
    }
    else {
        if (self.belongsToAdjacentMonth) {
            return;
            textColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
        } else {
            textColor = [KalSkinManager shareInstance].solarColor;
        }
    }
    
    NSString *dayText = nil;
    NSString *lunarText = nil;
    BOOL specialDay = NO;
    //只显示农历
    if (self.style == KalTileStyleLunar) {
        font = [UIFont systemFontOfSize:12*kScaleFactor];
        
        NSString *lunarDay = [CnCalendar getLunarOnlyDay:[self.date NSDate]];
        dayText = lunarDay;
        
        if ([CnCalendar getLunarSpecialDay:[self.date NSDate]] != nil) {
            dayText = [CnCalendar getLunarSpecialDay:[self.date NSDate]];
        }
        else if ([CnCalendar getLunarHolidayDay:[self.date NSDate]] != nil) {
            dayText = [CnCalendar getLunarHolidayDay:[self.date NSDate]];
            specialDay = YES;
        }
        else if ([CnCalendar getSolarHolidayDay:[self.date NSDate]] != nil) {
            dayText = [CnCalendar getSolarHolidayDay:[self.date NSDate]];
            specialDay = YES;
        }
    }
    else if (self.style == KalTileStyleSolarAndLunar) {
        font = [UIFont systemFontOfSize:12*kScaleFactor];
        
        NSUInteger n = [self.date day];
        dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
        lunarText = [CnCalendar getLunarOnlyDay:[self.date NSDate]];
        
        if ([CnCalendar getLunarSpecialDay:[self.date NSDate]] != nil) {
            lunarText = [CnCalendar getLunarSpecialDay:[self.date NSDate]];
        }
        else if ([CnCalendar getLunarHolidayDay:[self.date NSDate]] != nil) {
            lunarText = [CnCalendar getLunarHolidayDay:[self.date NSDate]];
            specialDay = YES;
        }
        else if ([CnCalendar getSolarHolidayDay:[self.date NSDate]] != nil) {
            lunarText = [CnCalendar getSolarHolidayDay:[self.date NSDate]];
            specialDay = YES;
        }
    }
    else {
        NSUInteger n = [self.date day];
        dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    }
    
//    NSLog(@"dayText:%@, getLunarHolidayDay:%@, getSolarHolidayDay:%@",dayText, [CnCalendar getLunarHolidayDay:[self.date NSDate]], [CnCalendar getSolarHolidayDay:[self.date NSDate]]);
    
//    const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
    CGSize textSize = [dayText sizeWithFont:font];
    CGFloat textX, textY;
    textX = roundf(0.5f * (rect.size.width - textSize.width));
    textY = 0.f + roundf(0.5f * (rect.size.height - textSize.height));
//    if (shadowColor) {
//        [shadowColor setFill];
//        CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
//        textY += 1.f;
//    }
    [textColor setFill];
//    CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
    
    if (lunarText != nil) {
//        [dayText drawAtPoint:CGPointMake(textX, textY-textSize.height/2) withFont:font];
//        [lunarText drawAtPoint:CGPointMake(textX, textY+textSize.height/2) withFont:font];
        
        CGRect topFrame = self.bounds;
        topFrame.size.height = self.bounds.size.height/2;
        
        CGRect bottomFrame = self.bounds;
        bottomFrame.origin.y = self.bounds.size.height/2 + 2;
        bottomFrame.size.height = self.bounds.size.height/2 - 2;
        
        [dayText drawInRect:topFrame withFont:[UIFont boldSystemFontOfSize:15*kScaleFactor] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
        
        if (specialDay) {
            textColor = [KalSkinManager shareInstance].specialDayColor;
        }
        else {
            textColor = [KalSkinManager shareInstance].lunarColor;
        }
        
        [textColor setFill];
        [lunarText drawInRect:bottomFrame withFont:[UIFont systemFontOfSize:10*kScaleFactor] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
    }
    else {
        [dayText drawAtPoint:CGPointMake(textX, textY) withFont:font];
    }
    
    if (self.highlighted) {
        [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, rect.size.width, rect.size.height));
    }
    
//    flags.marked = YES;
//    if (flags.marked) {
//        CGRect markerRect = CGRectMake(0.f, 0.f, 41.f, 15.f);
//        [markerImage drawInRect:markerRect];
//        
//        NSString *babyBirthday = [[CommBusiness getInstance] babyInfo].babyBirthday;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *dateBirthday = [formatter dateFromString:babyBirthday];
//        [formatter release];
//        
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
//                                                                       fromDate:dateBirthday
//                                                                         toDate:[self.date NSDate]
//                                                                        options:0];
//        NSString *strMarker = nil;
//        if (components.year < 1) {
//            strMarker = [NSString stringWithFormat:@"%d月%d周", components.month, components.day/7];
//        } else {
//            strMarker = [NSString stringWithFormat:@"%d岁%d月", components.year, components.month];
//        }
//        
//        UIFont *markerFont = FZY4JW_FONT(8);
//        CGSize markTextSize = [strMarker sizeWithFont:markerFont];
//        CGPoint markTextPoint = CGPointMake(markerRect.origin.x + (markerRect.size.width - markTextSize.width)/2,
//                                            markerRect.origin.y + (markerRect.size.height - markTextSize.height)/2 - 1);
//        [strMarker drawAtPoint:markTextPoint withFont:markerFont];
//    }
    
//    double end = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"time = %f", end - start);
}

- (void)changeSkin:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)resetState
{
    // realign to the grid
    CGRect frame = self.frame;
    frame.origin = origin;
    frame.size = CGSizeMake(kTileSize.width*kScaleFactor, kTileSize.height*kScaleFactor);
    self.frame = frame;
    
    [date release];
    date = nil;
    flags.type = KalTileTypeRegular;
    flags.highlighted = NO;
    flags.selected = NO;
    flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
    if (date == aDate)
        return;
    
    [date release];
    date = [aDate retain];
    
    [self setNeedsDisplay];
}

- (BOOL)isSelected
{
    return flags.selected;
}

- (void)setSelected:(BOOL)selected
{
    if (flags.selected == selected)
        return;
#if 0
    // workaround since I cannot draw outside of the frame in drawRect:
    if (![self isToday]) {
        CGRect rect = self.frame;
        if (selected) {
            rect.origin.x--;
            rect.size.width++;
            rect.size.height++;
        } else {
            rect.origin.x++;
            rect.size.width--;
            rect.size.height--;
        }
        self.frame = rect;
    }
#endif
    flags.selected = selected;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted
{
    return flags.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (flags.highlighted == highlighted)
        return;
    
    flags.highlighted = highlighted;
    [self setNeedsDisplay];
}

- (BOOL)isMarked
{
    return flags.marked;
}

- (void)setMarked:(BOOL)marked
{
    if (flags.marked == marked)
        return;
    
    flags.marked = marked;
    [self setNeedsDisplay];
}

- (KalTileType)type
{
    return flags.type;
}

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
#if 0
    // workaround since I cannot draw outside of the frame in drawRect:
    CGRect rect = self.frame;
    if (tileType == KalTileTypeToday) {
        rect.origin.x--;
        rect.size.width++;
        rect.size.height++;
    } else if (flags.type == KalTileTypeToday) {
        rect.origin.x++;
        rect.size.width--;
        rect.size.height--;
    }
    self.frame = rect;
#endif
    flags.type = tileType;
    [self setNeedsDisplay];
}

- (BOOL)isToday
{
    return flags.type == KalTileTypeToday;
}

- (BOOL)belongsToAdjacentMonth
{
    return flags.type == KalTileTypeAdjacent;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [date release];
    
    [super dealloc];
}

@end
