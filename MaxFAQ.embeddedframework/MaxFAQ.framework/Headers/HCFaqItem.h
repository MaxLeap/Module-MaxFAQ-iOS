//
//  MLFaqItem.h
//  MaxLeap
//

#import <MaxLeap/MLObject.h>
#import <MaxLeap/MLSubclassing.h>
#import <MaxLeap/MLObject+Subclass.h>

@interface HCFaqItem : MLObject <MLSubclassing>

@property (nonatomic) NSString *sectionId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSArray *attach;

@property (nonatomic) NSArray *platform;
@property (nonatomic) NSArray *tags;

@property (nonatomic) NSString *langName;
@property (nonatomic) NSString *langCode;

@property (nonatomic) double seq;

+ (instancetype)itemFromDictionsry:(NSDictionary *)dictionary;

+ (void)sortFaqItems:(NSMutableArray *)items;

@end
