//
//  HCTheme.m
//  MaxLeap
//


#import "MLFaqImageHelper.h"
#import "HCFaqTheme.h"
#import "MLLogging.h"
#import "HEXRGBColor.h"
#import "MLAssert.h"

#define DEFAULT_IMAGE_BUNDLE @"MLFaqImages.bundle"

@interface HCFaqSectionListViewAttributes ()
@property (nonatomic, strong) NSString *titleImageName;
@end

@implementation HCFaqSectionListViewAttributes

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.titleImageName = dictionary[@"Title image"];
    }
    return self;
}

- (UIImage *)titleImage {
    return HCImageNamed(self.titleImageName);
}

@end

#pragma mark -

@interface HCFaqItemListViewAttributes ()
@property (nonatomic, strong) NSString *titleImageName;
@end

@implementation HCFaqItemListViewAttributes

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.titleImageName = dictionary[@"Title image"];
    }
    return self;
}

- (UIImage *)titleImage {
    return HCImageNamed(self.titleImageName);
}

@end

#pragma mark -

@interface HCFaqItemContentViewAttributes ()
@property (nonatomic, strong) NSString *titleImageName;
@end

@implementation HCFaqItemContentViewAttributes

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.titleImageName = dictionary[@"Title image"];
    }
    return self;
}

- (UIImage *)titleImage {
    return HCImageNamed(self.titleImageName);
}

@end

#pragma mark -


@implementation HCFaqTheme

+ (instancetype)currentTheme {
    static HCFaqTheme *_currentTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MLFaqThemes" ofType:@"bundle"];
        NSString *path = [bundlePath stringByAppendingPathComponent:@"Default.plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        MLConsistencyAssert(dict.count > 0, @"Invalid file in path `main_bundle/MLFaqThemes.bundle/Default.plist`");
        _currentTheme = [[HCFaqTheme alloc] initWithConfig:dict];
    });
    return _currentTheme;
}

- (instancetype)init {
    if (self = [super init]) {
        [self applyDefaultConfigs];
    }
    return self;
}

- (instancetype)initWithConfig:(NSDictionary *)config {
    if (self = [self init]) {
        NSDictionary *dict = [self dictionaryByRemovingEmptyValues:config];
        [self applyConfig:dict];
    }
    return self;
}

- (NSDictionary *)dictionaryByRemovingEmptyValues:(NSDictionary *)config {
    if (!config) {
        return nil;
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [config enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([(NSString *)obj length] > 0) {
                result[key] = obj;
            }
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            result[key] = [self dictionaryByRemovingEmptyValues:obj];
        } else {
            result[key] = obj;
        }
    }];
    return result;
}

- (void)applyDefaultConfigs {
    [MLFaqImageHelper registerBundleWithPath:DEFAULT_IMAGE_BUNDLE];
}

- (void)applyConfig:(NSDictionary *)config {
    if (!config) return;
    
    NSString *imgBundleName = config[@"Image bundle name"];
    if (imgBundleName.length > 0) {
        if (NO == [imgBundleName hasSuffix:@".bundle"]) {
            imgBundleName = [imgBundleName stringByAppendingPathExtension:@"bundle"];
        }
        [MLFaqImageHelper registerBundleWithPath:imgBundleName];
    }
    
    _sectionListAttr = [[HCFaqSectionListViewAttributes alloc] initWithDictionary:config[@"FAQ section list view"]];
    _itemListAttr = [[HCFaqItemListViewAttributes alloc] initWithDictionary:config[@"FAQ item list view"]];
    _itemContentAttr = [[HCFaqItemContentViewAttributes alloc] initWithDictionary:config[@"FAQ item content view"]];
}

@end
