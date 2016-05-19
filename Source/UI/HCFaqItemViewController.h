//
//  MLFaqItemViewController.h
//  MaxLeap
//

#import "HCFaqBaseViewController.h"

@class HCFaqItem;

@interface HCFaqItemViewController : HCFaqBaseViewController

@property (nonatomic, strong) HCFaqItem *faqItem;
@property (nonatomic, strong) NSString *faqItemId;

@end
