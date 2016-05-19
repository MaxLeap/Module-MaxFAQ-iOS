//
//  MLFaqSection.m
//  MaxLeap
//

#import "HCFaqSection.h"
#import "MLAssert.h"

// used to remove warnings
@interface MLObject ()
- (BOOL)handleFetchResult:(NSDictionary *)result;
@end

@implementation HCFaqSection

@dynamic title, appId, langName, langCode, seq;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)leapClassName {
    return @"_FaqSection";
}

+ (void)assertValidLeapClassName:(NSString *)className {
    MLParameterAssert([className isEqualToString:[HCFaqSection leapClassName]],
                      @"Cannot initialize HCFaqSection with the custom class name `%@`", className);
}

+ (instancetype)sectionFromDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        
        NSString *objectId = dictionary[@"objectId"];
        HCFaqSection *section = [HCFaqSection objectWithoutDataWithObjectId:objectId];
        [section handleFetchResult:dictionary];
        
        return section;
    }
    return nil;
}

+ (void)sortFaqSections:(NSMutableArray *)sections {
    
    // 2015 5.4 约定 https://app.ilegendsoft.com/confluence/pages/viewpage.action?pageId=22089736
    // 1. 按 seq 从大到小排序
    // 2. seq 相等的情况下按 updateAt 从大到小（最新更新的排在前面）排序
    // 3. updateAt 一样的情况下（一般不会出现）按 title 0->9->a->z 排序
    [sections sortUsingComparator:^NSComparisonResult(HCFaqSection *sec1, HCFaqSection *sec2) {
        if (sec1.seq > sec2.seq) {
            return NSOrderedAscending;
        } else if (sec1.seq < sec2.seq) {
            return NSOrderedDescending;
        } else {
            NSComparisonResult result = [sec1.updatedAt compare:sec2.updatedAt];
            if (result == NSOrderedAscending) {
                return NSOrderedDescending;
            } else if (result == NSOrderedDescending) {
                return NSOrderedAscending;
            } else {
                return [sec1.title compare:sec2.title];
            }
        }
    }];
}

@end
