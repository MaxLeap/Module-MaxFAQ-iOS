//
//  HCTheme.h
//  MaxLeap
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, strong, readonly) HCFaqSectionListViewAttributes *sectionListAttr;
@property (nonatomic, strong, readonly) HCFaqItemListViewAttributes *itemListAttr;
@property (nonatomic, strong, readonly) HCFaqItemContentViewAttributes *itemContentAttr;

@end
