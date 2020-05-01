#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";


@protocol PhoneProtocol <NSObject>
-(NSString*)passData:(NSString*)str;
@end

@interface CountryClass : NSObject <PhoneProtocol>
@end
@implementation CountryClass
- (NSString*)passData:(NSString *)str {
    NSDictionary *dict = @{@"7" : @"RU",
                           @"77" : @"KZ",
                           @"373" : @"MD",
                           @"374" : @"AM",
                           @"375" : @"BY",
                           @"380" : @"UA",
                           @"992" : @"TJ",
                           @"993" : @"TM",
                           @"994" : @"AZ",
                           @"996" : @"KG",
                           @"998" : @"UZ"
    };
    int toIndex = 0;
    if (str.length <= 3)
        toIndex = @(str.length).intValue;
    else
        toIndex = 3;
    NSString *name = [str substringToIndex:toIndex];
    NSArray *numbs = [dict allKeys];
    
    if ([name characterAtIndex:0] == '7' && toIndex > 1)
    {
        if ([name characterAtIndex:1] == '7')
            name = [str substringToIndex:2];
        else
            name = [str substringToIndex:1];
    }

    for (NSString *num in numbs)
    {
        if ([name isEqualToString:num])
            return [dict objectForKey:num];
    }
    
    NSLog(@"%@", name);
    return @"no name";
}
@end

@interface PNConverter ()
@property (nonatomic) id <PhoneProtocol> phone;
@end
@implementation PNConverter

- (int)getCountryLength:(NSString *)name {
    
    NSDictionary *dict = @{@"RU" : @10,
                           @"KZ" : @10,
                           @"MD" : @8,
                           @"AM" : @8,
                           @"BY" : @9,
                           @"UA" : @9,
                           @"TJ" : @9,
                           @"TM" : @8,
                           @"AZ" : @9,
                           @"KG" : @9,
                           @"UZ" : @9,
    };
    NSNumber *i = [dict objectForKey:name];
    return i.intValue;
}
- (NSMutableString*)converterPhones:(NSMutableString *)string andCountry:(NSNumber *)countryLength {

    NSMutableArray *numbers = [NSMutableArray array];
    
    for (int i = 0; i < string.length; i++) {
        switch (i) {
            case 0:
                [numbers addObject:@" ("];
                break;
            case 2:
                if (countryLength.intValue != 10)
                {
                    [numbers addObject:@") "];
                    break;
                }
                else
                    break;
            case 3:
                if (countryLength.intValue == 10)
                    [numbers addObject:@") "];
                break;
            case 5:
                if (countryLength.intValue != 10)
                {
                    [numbers addObject:@"-"];
                    break;
                }
                else
                    break;
            case 6:
                if (countryLength.intValue == 10)
                    [numbers addObject:@"-"];
                break;
            case 7:
                if (countryLength.intValue == 9)
                    [numbers addObject:@"-"];
                break;
            case 8:
                if (countryLength.intValue == 10)
                {
                    [numbers addObject:@"-"];
                    break;
                }
                else
                    break;
            default:
                break;
        }
        
        NSString *ch = [string substringWithRange:NSMakeRange(i, 1)];
        [numbers addObject:ch];
    }
    
    NSString *result = [[numbers valueForKey:@"description"] componentsJoinedByString:@""];
    NSLog(@"%@", result);
    return result.mutableCopy;
}

- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    self.phone = [CountryClass new];  
    NSString *country = [NSString new];
    NSMutableString *phoneNumber = string.mutableCopy;
    
    if ([string characterAtIndex:0] == '+')
         string = [string substringFromIndex:1];
    
    if (phoneNumber.length >= 12)
         string = [string substringToIndex:12];

    NSString *patternString = [NSString new];
    NSMutableString *firstPart = [NSMutableString new];
    country = [self.phone passData:string];
      
    if ([country isEqualToString:@"no name"])
    {
        country = @"";
        firstPart = string.mutableCopy;
    }
    else {
        if ([country isEqualToString:@"RU"] || [country isEqualToString:@"KZ"])
        {
            patternString = [string substringFromIndex:1];
            firstPart = [string substringWithRange:NSMakeRange(0, 1)].mutableCopy;
        }
        else
        {
            patternString = [string substringFromIndex:3];
            firstPart = [string substringWithRange:NSMakeRange(0, 3)].mutableCopy;
        }
        
        int len = [self getCountryLength:country];
        phoneNumber = [self converterPhones:patternString.mutableCopy andCountry: @(len)];
        [firstPart appendString:phoneNumber];

    }
    
    if ([firstPart.copy characterAtIndex:0] != '+')
         [firstPart insertString:@"+" atIndex:0];
  
    return @{KeyPhoneNumber: firstPart.copy,
             KeyCountry: country};
}
@end


