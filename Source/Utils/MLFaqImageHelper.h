//
//  HCImageHelper.h
//  MaxLeap
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HCImageNamed(name) [MLFaqImageHelper imageNamed:name]

#define HCImageRenderingOriginal(name) \
        [[UIImage new] respondsToSelector:@selector(imageWithRenderingMode:)] ? [[MLFaqImageHelper imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : [MLFaqImageHelper imageNamed:name]

#define HCImageRenderingTemplate(name) \
        [[UIImage new] respondsToSelector:@selector(imageWithRenderingMode:)] ? [[HCImageHelper imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : [MLFaqImageHelper imageNamed:name]

#define HCStretchableImage(name, width, height) [HCImageNamed(name) stretchableImageWithLeftCapWidth:width topCapHeight:height]

@interface MLFaqImageHelper : NSObject

+ (void)registerBundleWithPath:(NSString *)path; // 可以是绝对路径，也可以是相对于 mainBundle 的路径

+ (UIImage *)imageNamed:(NSString *)name;

@end
