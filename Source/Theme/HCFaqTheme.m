//
//  HCTheme.m
//  MaxLeap
//


#import "MLFaqImageHelper.h"
#import "HCFaqTheme.h"
#import "MLLogging.h"
#import "HEXRGBColor.h"
#import "MLAssert.h"
#import "UIImage+Color.h"

#define DEFAULT_IMAGE_BUNDLE @"MLFaqImages.bundle"


@interface HCFaqNavigationBarAttributes ()

@property (nonatomic, strong) NSString *contactUsImageName;             // Contact us button image
@property (nonatomic, strong) NSString *contactUsImageHighlightedName;  // Contact us button image highlighted
@end

@implementation HCFaqNavigationBarAttributes

+ (void)load {
    maxfaq_load_UIImage_HCColor();
}

- (instancetype)init {
    if (self = [super init]) {
        self.barStyle = UIBarStyleBlack;
        self.titleFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.titleColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:100/255.f green:167/255.f blue:235/255.f alpha:1.00f];
        self.buttonTextColor = [UIColor whiteColor];
        self.buttonTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.barStyle = [dictionary[@"Status Bar Style"] integerValue];
        NSString *fontName = dictionary[@"Title font name"];
        if (fontName) {
            CGFloat fontSize = [dictionary[@"Title font size"] doubleValue];
            UIFont *font = [UIFont fontWithName:fontName size:fontSize];
            if (font) {
                self.titleFont = font;
            } else {
                MLLogInfoF(@"cannot find font with name '%@'", fontName);
            }
        }
        self.titleColor = UIColorFromHEXString(dictionary[@"Title color"])?:self.titleColor;
        self.backgroundColor = UIColorFromHEXString(dictionary[@"Background color"])?:self.backgroundColor;
        self.buttonTextColor = UIColorFromHEXString(dictionary[@"Bar button text color"])?:self.buttonTextColor;
        
        NSString *btnTextFontName = dictionary[@"Bar button font name"];
        if (btnTextFontName.length > 0) {
            CGFloat btnTextFontSize = [dictionary[@"Bar button font size"] doubleValue];
            UIFont *font = [UIFont fontWithName:btnTextFontName size:btnTextFontSize];
            if (font) {
                self.buttonTextFont = font;
            } else {
                MLLogInfoF(@"cannot find font with name '%@'", btnTextFontName);
            }
        }
        
        self.contactUsImageName = dictionary[@"Contact us button image"];
        self.contactUsImageHighlightedName = dictionary[@"Contact us button image highlighted"];
    }
    return self;
}

- (UIImage *)contactUsImage {
    return HCImageNamed(self.contactUsImageName);
}

- (UIImage *)contactUsImageHighlighted {
    return HCImageNamed(self.contactUsImageHighlightedName);
}

@end

#pragma mark -

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

+ (void)load {
    // load current theme
    [HCFaqTheme currentTheme];
}

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
    
    _navigationBarAttributes = [[HCFaqNavigationBarAttributes alloc] initWithDictionary:config[@"Navigation Bar"]];
    _sectionListAttr = [[HCFaqSectionListViewAttributes alloc] initWithDictionary:config[@"FAQ section list view"]];
    _itemListAttr = [[HCFaqItemListViewAttributes alloc] initWithDictionary:config[@"FAQ item list view"]];
    _itemContentAttr = [[HCFaqItemContentViewAttributes alloc] initWithDictionary:config[@"FAQ item content view"]];
}

@end
