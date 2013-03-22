//
//  EmojiCoding.m
//  Demo
//
//  Created by leihui on 13-3-22.
//
//

#import "EmojiCoding.h"

@implementation EmojiCoding

static NSString *smiley[] = {
    @"\U0001F604",
	@"\U0001F60A",
    @"\U0001F603",
    @"\U0000263A",
    @"\U0001F609",
    @"\U0001F60D",
    @"\U0001F618",
    @"\U0001F61A",
    @"\U0001F633",
    @"\U0001F60C",
    @"\U0001F601",
    
    @"\U0001F61C",
    @"\U0001F61D",
    @"\U0001F612",
    @"\U0001F60F",
    @"\U0001F613",
    @"\U0001F614",
    @"\U0001F61E",
    @"\U0001F616",
    @"\U0001F625",
    @"\U0001F630",
    @"\U0001F628",
    
    @"\U0001F623",
    @"\U0001F622",
    @"\U0001F62D",
    @"\U0001F602",
    @"\U0001F632",
    @"\U0001F631",
    @"\U0001F620",
    @"\U0001F621",
    @"\U0001F62A",
    @"\U0001F637",
    @"\U0001F47F",
    
    @"\U0001F47D",
    @"\U0001F49B",
    @"\U0001F499",
    @"\U0001F49C",
    @"\U0001F497",
    @"\U0001F49A",
    @"\U00002764",
    @"\U0001F494",
    @"\U0001F493",
    @"\U0001F498",
    @"\U00002728",
    
    @"\U0001F31F",
    @"\U0001F4A2",
    @"\U00002755",
    @"\U00002754",
    @"\U0001F4A4",
    @"\U0001F4A8",
    @"\U0001F4A6",
    @"\U0001F3B6",
    @"\U0001F3B5",
    @"\U0001F525",
    @"\U0001F4A9",
    
    @"\U0001F44D",
    @"\U0001F44E",
    @"\U0001F44C",
    @"\U0001F44A",
    @"\U0000270A",
    @"\U0000270C",
    @"\U0001F44B",
    @"\U0000270B",
    @"\U0001F450",
    @"\U0001F446",
    @"\U0001F447",
    
    @"\U0001F449",
    @"\U0001F448",
    @"\U0001F64C",
    @"\U0001F64F",
    @"\U0000261D",
    @"\U0001F44F",
    @"\U0001F4AA",
    @"\U0001F6B6",
    @"\U0001F3C3",
    @"\U0001F46B",
    @"\U0001F483",
    
    @"\U0001F46F",
    @"\U0001F646",
    @"\U0001F645",
    @"\U0001F481",
    @"\U0001F647",
    @"\U0001F48F",
    @"\U0001F491",
    @"\U0001F486",
    @"\U0001F487",
    @"\U0001F485",
    @"\U0001F466",
    
    @"\U0001F467",
    @"\U0001F469",
    @"\U0001F468",
    @"\U0001F476",
    @"\U0001F475",
    @"\U0001F474",
    @"\U0001F471",
    @"\U0001F472",
    @"\U0001F473",
    @"\U0001F477",
    @"\U0001F46E",
    
    @"\U0001F47C",
    @"\U0001F478",
    @"\U0001F482",
    @"\U0001F480",
    @"\U0001F463",
    @"\U0001F48B",
    @"\U0001F444",
    @"\U0001F442",
    @"\U0001F440",
    @"\U0001F443"
};

static NSString *flower[] = {
    @"\U00002600",
    @"\U00002614",
    @"\U00002601",
    @"\U000026C4",
    @"\U0001F319",
    @"\U000026A1",
    @"\U0001F300",
    @"\U0001F30A",
    @"\U0001F431",
    @"\U0001F436",
    @"\U0001F42D",
    
    @"\U0001F439",
    @"\U0001F430",
    @"\U0001F43A",
    @"\U0001F438",
    @"\U0001F42F",
    @"\U0001F428",
    @"\U0001F43B",
    @"\U0001F437",
    @"\U0001F42E",
    @"\U0001F417",
    @"\U0001F435",
    
    @"\U0001F412",
    @"\U0001F434",
    @"\U0001F40E",
    @"\U0001F42B",
    @"\U0001F411",
    @"\U0001F418",
    @"\U0001F40D",
    @"\U0001F426",
    @"\U0001F424",
    @"\U0001F414",
    @"\U0001F427",
    
    @"\U0001F41B",
    @"\U0001F419",
    @"\U0001F420",
    @"\U0001F41F",
    @"\U0001F433",
    @"\U0001F42C",
    @"\U0001F490",
    @"\U0001F338",
    @"\U0001F337",
    @"\U0001F340",
    @"\U0001F339",
    
    @"\U0001F33B",
    @"\U0001F33A",
    @"\U0001F341",
    @"\U0001F343",
    @"\U0001F342",
    @"\U0001F334",
    @"\U0001F335",
    @"\U0001F33E",
    @"\U0001F41A"
};

+ (NSMutableArray *)emojiAll
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[EmojiCoding emojiSmiley]];
    [array addObject:[EmojiCoding emojiFlower]];
    
    return array;
}

+ (NSMutableArray *)emojiSmiley
{
    int count = sizeof(smiley)/sizeof(smiley[0]);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        [array addObject:smiley[i]];
    }
    
    return array;
}

+ (NSMutableArray *)emojiFlower
{
    int count = sizeof(flower)/sizeof(flower[0]);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        [array addObject:flower[i]];
    }
    
    return array;
}

@end
