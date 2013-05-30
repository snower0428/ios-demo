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
    @"\U0001F604",@"\U0001F60A",@"\U0001F603",@"\U0000263A",@"\U0001F609",
    @"\U0001F60D",@"\U0001F618",@"\U0001F61A",@"\U0001F633",@"\U0001F60C",
    @"\U0001F601",@"\U0001F61C",@"\U0001F61D",@"\U0001F612",@"\U0001F60F",
    @"\U0001F613",@"\U0001F614",@"\U0001F61E",@"\U0001F616",@"\U0001F625",
    @"\U0001F630",@"\U0001F628",@"\U0001F623",@"\U0001F622",@"\U0001F62D",
    @"\U0001F602",@"\U0001F632",@"\U0001F631",@"\U0001F620",@"\U0001F621",
    @"\U0001F62A",@"\U0001F637",@"\U0001F47F",@"\U0001F47D",@"\U0001F49B",
    @"\U0001F499",@"\U0001F49C",@"\U0001F497",@"\U0001F49A",@"\U00002764",
    @"\U0001F494",@"\U0001F493",@"\U0001F498",@"\U00002728",@"\U0001F31F",
    @"\U0001F4A2",@"\U00002755",@"\U00002754",@"\U0001F4A4",@"\U0001F4A8",
    @"\U0001F4A6",@"\U0001F3B6",@"\U0001F3B5",@"\U0001F525",@"\U0001F4A9",
    @"\U0001F44D",@"\U0001F44E",@"\U0001F44C",@"\U0001F44A",@"\U0000270A",
    @"\U0000270C",@"\U0001F44B",@"\U0000270B",@"\U0001F450",@"\U0001F446",
    @"\U0001F447",@"\U0001F449",@"\U0001F448",@"\U0001F64C",@"\U0001F64F",
    @"\U0000261D",@"\U0001F44F",@"\U0001F4AA",@"\U0001F6B6",@"\U0001F3C3",
    @"\U0001F46B",@"\U0001F483",@"\U0001F46F",@"\U0001F646",@"\U0001F645",
    @"\U0001F481",@"\U0001F647",@"\U0001F48F",@"\U0001F491",@"\U0001F486",
    @"\U0001F487",@"\U0001F485",@"\U0001F466",@"\U0001F467",@"\U0001F469",
    @"\U0001F468",@"\U0001F476",@"\U0001F475",@"\U0001F474",@"\U0001F471",
    @"\U0001F472",@"\U0001F473",@"\U0001F477",@"\U0001F46E",@"\U0001F47C",
    @"\U0001F478",@"\U0001F482",@"\U0001F480",@"\U0001F463",@"\U0001F48B",
    @"\U0001F444",@"\U0001F442",@"\U0001F440",@"\U0001F443"
};

static NSString *flower[] = {
    @"\U00002600",@"\U00002614",@"\U00002601",@"\U000026C4",@"\U0001F319",
    @"\U000026A1",@"\U0001F300",@"\U0001F30A",@"\U0001F431",@"\U0001F436",
    @"\U0001F42D",@"\U0001F439",@"\U0001F430",@"\U0001F43A",@"\U0001F438",
    @"\U0001F42F",@"\U0001F428",@"\U0001F43B",@"\U0001F437",@"\U0001F42E",
    @"\U0001F417",@"\U0001F435",@"\U0001F412",@"\U0001F434",@"\U0001F40E",
    @"\U0001F42B",@"\U0001F411",@"\U0001F418",@"\U0001F40D",@"\U0001F426",
    @"\U0001F424",@"\U0001F414",@"\U0001F427",@"\U0001F41B",@"\U0001F419",
    @"\U0001F420",@"\U0001F41F",@"\U0001F433",@"\U0001F42C",@"\U0001F490",
    @"\U0001F338",@"\U0001F337",@"\U0001F340",@"\U0001F339",@"\U0001F33B",
    @"\U0001F33A",@"\U0001F341",@"\U0001F343",@"\U0001F342",@"\U0001F334",
    @"\U0001F335",@"\U0001F33E",@"\U0001F41A"
};

static NSString *bell[] = {
    @"\U0001F38D",@"\U0001F49D",@"\U0001F38E",@"\U0001F392",@"\U0001F393",
    @"\U0001F38F",@"\U0001F386",@"\U0001F387",@"\U0001F390",@"\U0001F391",
    @"\U0001F383",@"\U0001F47B",@"\U0001F385",@"\U0001F384",@"\U0001F381",
    @"\U0001F514",@"\U0001F389",@"\U0001F388",@"\U0001F4BF",@"\U0001F4C0",
    @"\U0001F4F7",@"\U0001F3A5",@"\U0001F4BB",@"\U0001F4FA",@"\U0001F4F1",
    @"\U0001F4E0",@"\U0000260E",@"\U0001F4BD",@"\U0001F4FC",@"\U0001F50A",
    @"\U0001F4E2",@"\U0001F4E3",@"\U0001F4FB",@"\U0001F4E1",@"\U000027BF",
    @"\U0001F50D",@"\U0001F513",@"\U0001F512",@"\U0001F511",@"\U00002702",
    @"\U0001F528",@"\U0001F4A1",@"\U0001F4F2",@"\U0001F4E9",@"\U0001F4EB",
    @"\U0001F4EE",@"\U0001F6C0",@"\U0001F6BD",@"\U0001F4BA",@"\U0001F4B0",
    @"\U0001F531",@"\U0001F6AC",@"\U0001F4A3",@"\U0001F52B",@"\U0001F48A",
    @"\U0001F489",@"\U0001F3C8",@"\U0001F3C0",@"\U000026BD",@"\U000026BE",
    @"\U0001F3BE",@"\U000026F3",@"\U0001F3B1",@"\U0001F3CA",@"\U0001F3C4",
    @"\U0001F3BF",@"\U00002660",@"\U00002665",@"\U00002663",@"\U00002666",
    @"\U0001F3C6",@"\U0001F47E",@"\U0001F3AF",@"\U0001F004",@"\U0001F3AC",
    @"\U0001F4DD",@"\U0001F4D6",@"\U0001F3A8",@"\U0001F3A4",@"\U0001F3A7",
    @"\U0001F3BA",@"\U0001F3B7",@"\U0001F3B8",@"\U0000303D",@"\U0001F45F",
    @"\U0001F461",@"\U0001F460",@"\U0001F462",@"\U0001F455",@"\U0001F454",
    @"\U0001F457",@"\U0001F458",@"\U0001F459",@"\U0001F380",@"\U0001F3A9",
    @"\U0001F451",@"\U0001F452",@"\U0001F302",@"\U0001F4BC",@"\U0001F45C",
    @"\U0001F484",@"\U0001F48D",@"\U0001F48E",@"\U00002615",@"\U0001F375",
    @"\U0001F37A",@"\U0001F37B",@"\U0001F378",@"\U0001F376",@"\U0001F374",
    @"\U0001F354",@"\U0001F35F",@"\U0001F35D",@"\U0001F35B",@"\U0001F371",
    @"\U0001F363",@"\U0001F359",@"\U0001F358",@"\U0001F35A",@"\U0001F35C",
    @"\U0001F372",@"\U0001F35E",@"\U0001F373",@"\U0001F362",@"\U0001F361",
    @"\U0001F366",@"\U0001F367",@"\U0001F382",@"\U0001F370",@"\U0001F34E",
    @"\U0001F34A",@"\U0001F349",@"\U0001F353",@"\U0001F346",@"\U0001F345"
};

static NSString *vehicle[] = {
    @"\U0001F3E0",@"\U0001F3EB",@"\U0001F3E2",@"\U0001F3E3",@"\U0001F3E5",
    @"\U0001F3E6",@"\U0001F3EA",@"\U0001F3E9",@"\U0001F3E8",@"\U0001F492",
    @"\U000026EA",@"\U0001F3EC",@"\U0001F307",@"\U0001F306",@"\U0001F3E7",
    @"\U0001F3EF",@"\U0001F3F0",@"\U000026FA",@"\U0001F3ED",@"\U0001F5FC",
    @"\U0001F5FB",@"\U0001F304",@"\U0001F305",@"\U0001F303",@"\U0001F5FD",
    @"\U0001F308",@"\U0001F3A1",@"\U000026F2",@"\U0001F3A2",@"\U0001F6A2",
    @"\U0001F6A4",@"\U000026F5",@"\U00002708",@"\U0001F680",@"\U0001F6B2",
    @"\U0001F699",@"\U0001F697",@"\U0001F695",@"\U0001F68C",@"\U0001F693",
    @"\U0001F692",@"\U0001F691",@"\U0001F69A",@"\U0001F683",@"\U0001F689",
    @"\U0001F684",@"\U0001F685",@"\U0001F3AB",@"\U000026FD",@"\U0001F6A5",
    @"\U000026A0",@"\U0001F6A7",@"\U0001F530",@"\U0001F3B0",@"\U0001F68F",
    @"\U0001F488",@"\U00002668",@"\U0001F3C1",@"\U0001F38C",
//    @"\U0001F1EF\U0001F1F5",
//    @"\U0001F1F0\U0001F1F7",
//    @"\U0001F1E8\U0001F1F3",
//    @"\U0001F1FA\U0001F1F8",
//    @"\U0001F1EB\U0001F1F7",
//    @"\U0001F1EA\U0001F1F8",
//    @"\U0001F1EE\U0001F1F9",
//    
//    @"\U0001F1F7\U0001F1FA",
//    @"\U0001F1EC\U0001F1E7",
//    @"\U0001F1E9\U0001F1EA"
};

static NSString *number[] = {
//    @"\U00000031\U000020E3",
//    @"\U00000032\U000020E3",
//    @"\U00000033\U000020E3",
//    @"\U00000034\U000020E3",
//    @"\U00000035\U000020E3",
//    @"\U00000036\U000020E3",
//    @"\U00000037\U000020E3",
//    @"\U00000038\U000020E3",
//    @"\U00000039\U000020E3",
//    @"\U00000030\U000020E3",
//    @"\U00000023\U000020E3",
    
    @"\U00002B06",@"\U00002B07",@"\U00002B05",@"\U000027A1",@"\U00002197",
    @"\U00002196",@"\U00002198",@"\U00002199",@"\U000025C0",@"\U000025B6",
    @"\U000023EA",@"\U000023E9",@"\U0001F197",@"\U0001F195",@"\U0001F51D",
    @"\U0001F199",@"\U0001F192",@"\U0001F3A6",@"\U0001F201",@"\U0001F4F6",
    @"\U0001F235",@"\U0001F233",@"\U0001F250",@"\U0001F239",@"\U0001F22F",
    @"\U0001F23A",@"\U0001F236",@"\U0001F21A",@"\U0001F237",@"\U0001F238",
    @"\U0001F202",@"\U0001F6BB",@"\U0001F6B9",@"\U0001f6ba",@"\U0001f6bc",
    @"\U0001f6ad",@"\U0001f17f",@"\U0000267F",@"\U0001f687",@"\U0001f6be",
    @"\U00003299",@"\U00003297",@"\U0001f51e",@"\U0001f194",@"\U00002733",
    @"\U00002734",@"\U0001F49F",@"\U0001F19A",@"\U0001F4F3",@"\U0001F4F4",
    @"\U0001F4B9",@"\U0001F4B1",@"\U00002648",@"\U00002649",@"\U0000264A",
    @"\U0000264B",@"\U0000264C",@"\U0000264D",@"\U0000264E",@"\U0000264F",
    @"\U00002650",@"\U00002651",@"\U00002652",@"\U00002653",@"\U000026CE",
    @"\U0001F52F",@"\U0001F170",@"\U0001F171",@"\U0001F18E",@"\U0001F17E",
    @"\U0001F532",@"\U0001F534",@"\U0001F533",@"\U0001F55B",@"\U0001F550",
    @"\U0001F551",@"\U0001F552",@"\U0001F553",@"\U0001F554",@"\U0001F555",
    @"\U0001F556",@"\U0001F557",@"\U0001F558",@"\U0001F559",@"\U0001F55A",
    @"\U00002B55",@"\U0000274C",@"\U000000A9",@"\U000000AE",@"\U00002122"
};

static NSString *smiley2[] = {
    @"\uE415",@"\uE056",@"\uE057",@"\uE414",@"\uE405",
    @"\uE106",@"\uE418",@"\uE417",@"\uE40D",@"\uE40A",
    @"\uE404",@"\uE105",@"\uE409",@"\uE40E",@"\uE402",
    @"\uE108",@"\uE403",@"\uE058",@"\uE407",@"\uE401",
    @"\uE40F",@"\uE40B",@"\uE406",@"\uE413",@"\uE411",
    @"\uE412",@"\uE410",@"\uE107",@"\uE059",@"\uE416",
    @"\uE408",@"\uE40C",@"\uE11A",@"\uE10C",@"\uE32C",
    @"\uE32A",@"\uE32D",@"\uE328",@"\uE32B",@"\uE022",
    @"\uE023",@"\uE027",@"\uE029",@"\uE32E",@"\uE335",
    @"\uE334",@"\uE337",@"\uE336",@"\uE13C",@"\uE330",
    @"\uE331",@"\uE326",@"\uE03E",@"\uE11D",@"\uE05A",
    @"\uE00E",@"\uE421",@"\uE420",@"\uE00D",@"\uE010",
    @"\uE011",@"\uE41E",@"\uE012",@"\uE422",@"\uE22E",
    @"\uE22F",@"\uE231",@"\uE230",@"\uE427",@"\uE41D",
    @"\uE00F",@"\uE41F",@"\uE14C",@"\uE201",@"\uE115",
    @"\uE428",@"\uE51F",@"\uE429",@"\uE424",@"\uE423",
    @"\uE253",@"\uE426",@"\uE111",@"\uE425",@"\uE31E",
    @"\uE31F",@"\uE31D",@"\uE001",@"\uE002",@"\uE005",
    @"\uE004",@"\uE51A",@"\uE519",@"\uE518",@"\uE515",
    @"\uE516",@"\uE517",@"\uE51B",@"\uE152",@"\uE04E",
    @"\uE51C",@"\uE51E",@"\uE11C",@"\uE536",@"\uE003",
    @"\uE41C",@"\uE41B",@"\uE419",@"\uE41A"
};

static NSString *flower2[] = {
    @"\uE04A",@"\uE04B",@"\uE049",@"\uE048",@"\uE04C",
    @"\uE13D",@"\uE443",@"\uE43E",@"\uE04F",@"\uE052",
    @"\uE053",@"\uE524",@"\uE52C",@"\uE52A",@"\uE531",
    @"\uE050",@"\uE527",@"\uE051",@"\uE10B",@"\uE52B",
    @"\uE52F",@"\uE109",@"\uE528",@"\uE01A",@"\uE134",
    @"\uE530",@"\uE529",@"\uE526",@"\uE52D",@"\uE521",
    @"\uE523",@"\uE52E",@"\uE055",@"\uE525",@"\uE10A",
    @"\uE522",@"\uE019",@"\uE054",@"\uE520",@"\uE306",
    @"\uE030",@"\uE304",@"\uE110",@"\uE032",@"\uE305",
    @"\uE303",@"\uE118",@"\uE447",@"\uE119",@"\uE307",
    @"\uE308",@"\uE444",@"\uE441"
};

static NSString *bell2[] = {
    @"\uE436",@"\uE437",@"\uE438",@"\uE43A",@"\uE439",
    @"\uE43B",@"\uE117",@"\uE440",@"\uE442",@"\uE446",
    @"\uE445",@"\uE11B",@"\uE448",@"\uE033",@"\uE112",
    @"\uE325",@"\uE312",@"\uE310",@"\uE126",@"\uE127",
    @"\uE008",@"\uE03D",@"\uE00C",@"\uE12A",@"\uE00A",
    @"\uE00B",@"\uE009",@"\uE316",@"\uE129",@"\uE141",
    @"\uE142",@"\uE317",@"\uE128",@"\uE14B",@"\uE211",
    @"\uE114",@"\uE145",@"\uE144",@"\uE03F",@"\uE313",
    @"\uE116",@"\uE10F",@"\uE104",@"\uE103",@"\uE101",
    @"\uE102",@"\uE13F",@"\uE140",@"\uE11F",@"\uE12F",
    @"\uE031",@"\uE30E",@"\uE311",@"\uE113",@"\uE30F",
    @"\uE13B",@"\uE42B",@"\uE42A",@"\uE018",@"\uE016",
    @"\uE015",@"\uE014",@"\uE42C",@"\uE42D",@"\uE017",
    @"\uE013",@"\uE20E",@"\uE20C",@"\uE20F",@"\uE20D",
    @"\uE131",@"\uE12B",@"\uE130",@"\uE12D",@"\uE324",
    @"\uE301",@"\uE148",@"\uE502",@"\uE03C",@"\uE30A",
    @"\uE042",@"\uE040",@"\uE041",@"\uE12C",@"\uE007",
    @"\uE31A",@"\uE13E",@"\uE31B",@"\uE006",@"\uE302",
    @"\uE319",@"\uE321",@"\uE322",@"\uE314",@"\uE503",
    @"\uE10E",@"\uE318",@"\uE43C",@"\uE11E",@"\uE323",
    @"\uE31C",@"\uE034",@"\uE035",@"\uE045",@"\uE338",
    @"\uE047",@"\uE30C",@"\uE044",@"\uE30B",@"\uE043",
    @"\uE120",@"\uE33B",@"\uE33F",@"\uE341",@"\uE34C",
    @"\uE344",@"\uE342",@"\uE33D",@"\uE33E",@"\uE340",
    @"\uE34D",@"\uE339",@"\uE147",@"\uE343",@"\uE33C",
    @"\uE33A",@"\uE43F",@"\uE34B",@"\uE046",@"\uE345",
    @"\uE346",@"\uE348",@"\uE347",@"\uE34A",@"\uE349"
};

static NSString *vehicle2[] = {
    @"\uE036",@"\uE157",@"\uE038",@"\uE153",@"\uE155",
    @"\uE14D",@"\uE156",@"\uE501",@"\uE158",@"\uE43D",
    @"\uE037",@"\uE504",@"\uE44A",@"\uE146",@"\uE154",
    @"\uE505",@"\uE506",@"\uE122",@"\uE508",@"\uE509",
    @"\uE03B",@"\uE04D",@"\uE449",@"\uE44B",@"\uE51D",
    @"\uE44C",@"\uE124",@"\uE121",@"\uE433",@"\uE202",
    @"\uE135",@"\uE01C",@"\uE01D",@"\uE10D",@"\uE136",
    @"\uE42E",@"\uE01B",@"\uE15A",@"\uE159",@"\uE432",
    @"\uE430",@"\uE431",@"\uE42F",@"\uE01E",@"\uE039",
    @"\uE435",@"\uE01F",@"\uE125",@"\uE03A",@"\uE14E",
    @"\uE252",@"\uE137",@"\uE209",@"\uE133",@"\uE150",
    @"\uE320",@"\uE123",@"\uE132",@"\uE143",@"\uE50B",
    @"\uE514",@"\uE513",@"\uE50C",@"\uE50D",@"\uE511",
    @"\uE50F",@"\uE512",@"\uE510",@"\uE50E"
};

static NSString *number2[] = {
    @"\uE21C",@"\uE21D",@"\uE21E",@"\uE21F",@"\uE220",
    @"\uE221",@"\uE222",@"\uE223",@"\uE224",@"\uE225",
    @"\uE210",@"\uE232",@"\uE233",@"\uE235",@"\uE234",
    @"\uE236",@"\uE237",@"\uE238",@"\uE239",@"\uE23B",
    @"\uE23A",@"\uE23D",@"\uE23C",@"\uE24D",@"\uE212",
    @"\uE24C",@"\uE213",@"\uE214",@"\uE507",@"\uE203",
    @"\uE20B",@"\uE22A",@"\uE22B",@"\uE226",@"\uE227",
    @"\uE22C",@"\uE22D",@"\uE215",@"\uE216",@"\uE217",
    @"\uE218",@"\uE228",@"\uE151",@"\uE138",@"\uE139",
    @"\uE13A",@"\uE208",@"\uE14F",@"\uE20A",@"\uE434",
    @"\uE309",@"\uE315",@"\uE30D",@"\uE207",@"\uE229",
    @"\uE206",@"\uE205",@"\uE204",@"\uE12E",@"\uE250",
    @"\uE251",@"\uE14A",@"\uE149",@"\uE23F",@"\uE240",
    @"\uE241",@"\uE242",@"\uE243",@"\uE244",@"\uE245",
    @"\uE246",@"\uE247",@"\uE248",@"\uE249",@"\uE24A",
    @"\uE24B",@"\uE24E",@"\uE532",@"\uE533",@"\uE534",
    @"\uE535",@"\uE21A",@"\uE219",@"\uE21B",@"\uE02F",
    @"\uE024",@"\uE025",@"\uE026",@"\uE027",@"\uE028",
    @"\uE029",@"\uE02A",@"\uE02B",@"\uE02C",@"\uE02D",
    @"\uE02E",@"\uE332",@"\uE333",@"\uE24E",@"\uE24F",
    @"\uE537"
};

+ (NSMutableArray *)emojiAll
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[EmojiCoding emojiSmiley]];
    [array addObject:[EmojiCoding emojiFlower]];
    [array addObject:[EmojiCoding emojiBell]];
    [array addObject:[EmojiCoding emojiVehicle]];
    [array addObject:[EmojiCoding emojiNumber]];
    
    return array;
}

+ (NSMutableArray *)emojiSmiley
{
    int count = 0;
    NSMutableArray *array = nil;
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion < 5.0) {
        count = sizeof(smiley2)/sizeof(smiley2[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:smiley2[i]];
        }
    } else {
        count = sizeof(smiley)/sizeof(smiley[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:smiley[i]];
        }
    }
    
    return array;
}

+ (NSMutableArray *)emojiFlower
{
    int count = 0;
    NSMutableArray *array = nil;
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion < 5.0) {
        count = sizeof(flower2)/sizeof(flower2[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:flower2[i]];
        }
    } else {
        count = sizeof(flower)/sizeof(flower[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:flower[i]];
        }
    }
    
    return array;
}

+ (NSMutableArray *)emojiBell
{
    int count = 0;
    NSMutableArray *array = nil;
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion < 5.0) {
        count = sizeof(bell2)/sizeof(bell2[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:bell2[i]];
        }
    } else {
        count = sizeof(bell)/sizeof(bell[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:bell[i]];
        }
    }
    
    return array;
}

+ (NSMutableArray *)emojiVehicle
{
    int count = 0;
    NSMutableArray *array = nil;
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion < 5.0) {
        count = sizeof(vehicle2)/sizeof(vehicle2[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:vehicle2[i]];
        }
    } else {
        count = sizeof(vehicle)/sizeof(vehicle[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:vehicle[i]];
        }
    }
    
    return array;
}

+ (NSMutableArray *)emojiNumber
{
    int count = 0;
    NSMutableArray *array = nil;
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion < 5.0) {
        count = sizeof(number2)/sizeof(number2[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:number2[i]];
        }
    } else {
        count = sizeof(number)/sizeof(number[0]);
        array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:number[i]];
        }
    }
    
    return array;
}

@end
