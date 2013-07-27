/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame style:(KalTileStyle)theStyle
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j*kTileSize.width+j, i*kTileSize.height+i, kTileSize.width, kTileSize.height);
                KalTileView *tileView = [[[KalTileView alloc] initWithFrame:r] autorelease];
                tileView.style = theStyle;
//                int random = arc4random()%255;
//                tileView.backgroundColor = [UIColor colorWithRed:(float)random/255.0 green:(float)random/255.0 blue:(float)random/255.0 alpha:1.0];
                [self addSubview:tileView];
            }
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:KalTileStyleSolar];
    if (self) {
        //
    }
    
    return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
    int tileNum = 0;
    NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
    
    for (int i=0; i<3; i++) {
        for (KalDate *d in dates[i]) {
            KalTileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            tile.type = dates[i] != mainDates ? KalTileTypeAdjacent : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
            tileNum++;
        }
    }
    
    numWeeks = ceilf(tileNum / 7.f);
    [self sizeToFit];
}

- (KalTileView *)firstTileOfMonth
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if (!t.belongsToAdjacentMonth) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if ([t.date isEqual:date]) {
            tile = t;
            break;
        }
    }
//    NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
    
    return tile;
}

- (void)sizeToFit
{
    self.height = 5.f + kTileSize.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
    for (KalTileView *tile in self.subviews) {
        tile.marked = [dates containsObject:tile.date];
    }
}

@end
