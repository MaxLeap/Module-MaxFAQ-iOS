//
//  MLFaqItem.m
//  MaxLeap
//

#import "HCFaqItem.h"
#import "MLLogging.h"
#import "MLAssert.h"

// used to remove warnings
@interface MLObject ()
- (BOOL)handleFetchResult:(NSDictionary *)result;
@end

@implementation HCFaqItem

@dynamic sectionId, title, content, attach, platform, tags, langCode, langName, seq;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)leapClassName {
    return @"_FaqItem";
}

+ (void)assertValidLeapClassName:(NSString *)className {
    MLParameterAssert([className isEqualToString:[HCFaqItem leapClassName]],
                      @"Cannot initialize HCFaqItem with the custom class name `%@`", className);
}

+ (instancetype)itemFromDictionsry:(NSDictionary *)dictionary {
    if (dictionary) {
        
        NSString *objectId = dictionary[@"objectId"];
        HCFaqItem *item = [HCFaqItem objectWithoutDataWithObjectId:objectId];
        [item handleFetchResult:dictionary];
        
        return item;
    }
    return nil;
}

+ (void)sortFaqItems:(NSMutableArray *)items {
    
    // 2015 5.4 约定 https://app.ilegendsoft.com/confluence/pages/viewpage.action?pageId=22089736
    // 1. 按 seq 从大到小排序
    // 2. seq 相等的情况下按 updateAt 从大到小（最新更新的排在前面）排序
    // 3. updateAt 一样的情况下（一般不会出现）按 title 0->9->a->z 排序
    [items sortUsingComparator:^NSComparisonResult(HCFaqItem *item1, HCFaqItem *item2) {
        if (item1.seq > item2.seq) {
            return NSOrderedAscending;
        } else if (item1.seq < item2.seq) {
            return NSOrderedDescending;
        } else {
            NSComparisonResult result = [item1.updatedAt compare:item2.updatedAt];
            if (result == NSOrderedAscending) {
                return NSOrderedDescending;
            } else if (result == NSOrderedDescending) {
                return NSOrderedAscending;
            } else {
                return [item1.title compare:item2.title];
            }
        }
    }];
}

@end
