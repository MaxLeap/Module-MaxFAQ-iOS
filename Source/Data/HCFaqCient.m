//
//  MLFaqManager.m
//  MaxLeap
//

#import "HCFaqCient.h"
#import "MLRequest.h"
#import "HCFaqItem.h"
#import "MLLogging.h"
#import <MaxLeap/MLQuery.h>

@interface MLDevice : NSObject
+ (instancetype)currentDevice;
@property (readonly, nonatomic, strong) NSString *preferredLanguageId;
@end

@implementation HCFaqCient

+ (void)getFaqSectionsWithBlock:(MLArrayResultBlock)block {
    
    MLRequest *request = [MLRequest new];
    request.method = MLConnectMethodPost;
    request.path = @"/help/faq/section/app";
    request.body = @{@"langCode":[MLDevice currentDevice].preferredLanguageId,
                     @"platform":@"0"};
    [request sendWithCompletion:^(id object, NSError *error) {
        
        NSMutableArray *sectionList = nil;
        if ( ! error) {
            if ([object isKindOfClass:[NSArray class]]) {
                
                sectionList = [NSMutableArray arrayWithCapacity:[object count]];
                [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        HCFaqSection *section = [HCFaqSection sectionFromDictionary:obj];
                        if (section) {
                            [sectionList addObject:section];
                        }
                    }
                }];
                
            } else {
                MLLogErrorF(@"Unexpected response for app faqs, expected a array, but got %@", [object class]);
            }
        }
        [HCFaqSection sortFaqSections:sectionList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(sectionList, error);
            }
        });
    }];
}

+ (NSMutableDictionary *)paramsFromQuery:(MLQuery *)query {
    NSMutableDictionary *dict = [[query performSelector:@selector(queryParams)] mutableCopy];
    if ([query valueForKey:@"where"]) {
        dict[@"where"] = [query valueForKey:@"where"];
    }
    return dict;
}

+ (void)findFaqItemsWithQuery:(MLQuery *)query block:(MLArrayResultBlock)block {
    
    MLRequest *request = [MLRequest new];
    request.method = MLConnectMethodPost;
    request.path = @"/help/faq/item/find";
    NSMutableDictionary *params = [self paramsFromQuery:query];
    params[@"langCode"] = [MLDevice currentDevice].preferredLanguageId;
    params[@"platform"] = @"0";
    request.body = params;
    [request sendWithCompletion:^(id object, NSError *error) {
        
        NSMutableArray *itemList = nil;
        
        if ( ! error) {
            if ([object isKindOfClass:[NSArray class]]) {
                
                itemList = [NSMutableArray arrayWithCapacity:[object count]];
                [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        HCFaqItem *item = [HCFaqItem itemFromDictionsry:obj];
                        if (item) {
                            [itemList addObject:item];
                        }
                    }
                }];
            } else {
                MLLogErrorF(@"Unexpected response for app faqs, expected a array, but got %@", [object class]);
            }
        }
        [HCFaqItem sortFaqItems:itemList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(itemList, error);
            }
        });
    }];
}

+ (void)getFaqItemWithItemId:(NSString *)itemId block:(void (^)(HCFaqItem *, NSError *))block {
    if (itemId.length) {
        MLQuery *query = [HCFaqItem query];
        [query whereKey:@"objectId" equalTo:itemId];
        [self findFaqItemsWithQuery:query block:^(NSArray *objects, NSError *error) {
            if (block) {
                block(objects.firstObject, error);
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:MLErrorDomain code:kMLErrorMissingObjectId userInfo:@{NSLocalizedDescriptionKey:@"ItemId missing."}];
            if (block) block(nil, error);
        });
    }
}

+ (void)getFaqItemsInSection:(HCFaqSection *)section block:(MLArrayResultBlock)block {
    [self getFaqItemsWithSectionId:section.objectId block:block];
}

+ (void)getFaqItemsWithSectionId:(NSString *)sectionId block:(MLArrayResultBlock)block {
    if (sectionId.length) {
        MLQuery *query = [HCFaqItem query];
        [query whereKey:@"sectionId" equalTo:sectionId];
        [query orderByAscending:@"seq"];
        [self findFaqItemsWithQuery:query block:block];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block([NSArray array], nil);
        });
    }
}

+ (void)getAllFaqItemsWithBlock:(MLArrayResultBlock)block {
    MLQuery *query = [HCFaqItem query];
    [query orderByAscending:@"seq"];
    [self findFaqItemsWithQuery:query block:block];
}

+ (void)searchFaqItemWithString:(NSString *)string block:(MLArrayResultBlock)block {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"langCode"] = [MLDevice currentDevice].preferredLanguageId;
    param[@"platform"] = @"0";
    if (string) param[@"q"] = string;
    
    MLRequest *request = [MLRequest new];
    request.path = @"/help/faq/searchItem";
    request.queryParams = param;
    [request sendWithCompletion:^(id object, NSError *error) {
        
        NSMutableArray *itemList = nil;
        
        if ( ! error) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSArray *hits = object[@"hits"];
                itemList = [NSMutableArray arrayWithCapacity:hits.count];
                [hits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        HCFaqItem *item = [HCFaqItem itemFromDictionsry:obj[@"doc"]];
                        if (item) {
                            [itemList addObject:item];
                        }
                    }
                }];
            } else {
                MLLogErrorF(@"Unexpected response for app faqs, expected a array, but got %@", [object class]);
            }
        }
        [HCFaqItem sortFaqItems:itemList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(itemList, error);
            }
        });
    }];
}

@end
