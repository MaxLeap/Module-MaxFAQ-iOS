//
//  MLFaqSection.h
//  MaxLeap
//

#import <MaxLeap/MLObject.h>
#import <MaxLeap/MLSubclassing.h>
#import <MaxLeap/MLObject+Subclass.h>

@interface HCFaqSection : MLObject <MLSubclassing>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *langName;
@property (nonatomic) NSString *langCode;
@property (nonatomic) double seq;

+ (instancetype)sectionFromDictionary:(NSDictionary *)dictionary;

+ (void)sortFaqSections:(NSMutableArray *)sections;

@end
