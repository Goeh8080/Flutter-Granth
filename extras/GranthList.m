// Standalone sample; not part of the app build.
#import <Foundation/Foundation.h>

@interface GranthList : NSObject
+ (void)print;
@end

@implementation GranthList
+ (void)print {
    NSArray *granths = @[@"Gita", @"Kabir Sagar", @"Ved"];
    [granths enumerateObjectsUsingBlock:^(id g, NSUInteger i, BOOL *stop) { NSLog(@"%lu. %@", i + 1, g); }];
}
@end
