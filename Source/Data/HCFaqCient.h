//
//  MLFaqManager.h
//  MaxLeap
//

#import "HCFaqSection.h"
#import "HCFaqItem.h"
#import <MaxLeap/MLConstants.h>

@class MLQuery;

@interface HCFaqCient : NSObject

+ (void)getFaqSectionsWithBlock:(MLArrayResultBlock)block;

+ (void)findFaqItemsWithQuery:(MLQuery *)query block:(MLArrayResultBlock)block;
+ (void)getFaqItemWithItemId:(NSString *)itemId block:(void(^)(HCFaqItem *item, NSError *error))block;
+ (void)getFaqItemsInSection:(HCFaqSection *)section block:(MLArrayResultBlock)block;
+ (void)getFaqItemsWithSectionId:(NSString *)sectionId block:(MLArrayResultBlock)block;
+ (void)getAllFaqItemsWithBlock:(MLArrayResultBlock)block;

+ (void)searchFaqItemWithString:(NSString *)string block:(MLArrayResultBlock)block;

@end
