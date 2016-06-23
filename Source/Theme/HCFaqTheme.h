//
//  HCTheme.h
//  MaxLeap
//

#import <Foundation/Foundation.h>

@interface HCFaqNavigationBarAttributes : NSObject

@property (nonatomic) UIBarStyle barStyle; // Status Bar Style

@property (nonatomic, strong) UIFont *titleFont;            // Title font name + Title font size
@property (nonatomic, strong) UIColor *titleColor;          // Title color
@property (nonatomic, strong) UIColor *backgroundColor;     // Background color

@property (nonatomic, strong) UIColor *buttonTextColor;     // Bar button text color
//@property (nonatomic, strong) UIColor *buttonTextColorHighlited;// Bar button text color
@property (nonatomic, strong) UIFont *buttonTextFont;       // Bar button font name + Bar button font size

@property (nonatomic, strong) UIImage *contactUsImage;      // Contact us button image
@property (nonatomic, strong) UIImage *contactUsImageHighlighted;// Contact us button image highlighted

@end

@interface HCFaqSectionListViewAttributes : NSObject
@property (nonatomic, strong) UIImage *titleImage;          // Title image
@end

@interface HCFaqItemListViewAttributes : NSObject
@property (nonatomic, strong) UIImage *titleImage;          // Title image
@end

@interface HCFaqItemContentViewAttributes : NSObject
@property (nonatomic, strong) UIImage *titleImage;          // Title image
@end

@interface HCFaqTheme : NSObject

+ (instancetype)currentTheme;

@property (nonatomic, strong, readonly) HCFaqNavigationBarAttributes *navigationBarAttributes;
@property (nonatomic, strong, readonly) HCFaqSectionListViewAttributes *sectionListAttr;
@property (nonatomic, strong, readonly) HCFaqItemListViewAttributes *itemListAttr;
@property (nonatomic, strong, readonly) HCFaqItemContentViewAttributes *itemContentAttr;

@end
