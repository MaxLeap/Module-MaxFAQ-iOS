//
//  MLFaqSectionTableViewController.h
//  MaxLeap
//

#import "HCFaqViewController.h"

@class HCFaqSection;

@interface HCFaqItemListViewController : HCFaqViewController

@property (nonatomic, strong) HCFaqSection *faqSection;
@property (nonatomic, strong) NSString *faqSectionId;

@end
