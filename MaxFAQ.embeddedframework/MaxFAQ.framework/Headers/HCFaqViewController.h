//
//  MLFaqTableViewController.h
//  MaxLeap
//

#import "HCFaqBaseViewController.h"

@interface HCFaqViewController : HCFaqBaseViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@end
