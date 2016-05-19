//
//  HCLocalizable.h
//  MaxLeap
//

#ifndef MaxLeap_HCLocalizable_h
#define MaxLeap_HCLocalizable_h

#import <Foundation/Foundation.h>
#import "MLLogging.h"

static inline NSBundle * faq_localizable_bundle() {
    static NSBundle *_bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MLFaqLocalizable" ofType:@"bundle"];
        _bundle = [NSBundle bundleWithPath:bundlePath];
        if (!_bundle) {
            MLLogInfoF(@"MLFaqLocalizable.bundle not found, please include it in your project.");
        }
    });
    return _bundle;
}
#define HCLocalizedString(key, comment) \
        NSLocalizedStringFromTableInBundle(key, @"localizable", faq_localizable_bundle(), comment)

#endif
