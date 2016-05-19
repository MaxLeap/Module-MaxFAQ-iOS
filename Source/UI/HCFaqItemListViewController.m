//
//  MLFaqSectionTableViewController.m
//  MaxLeap
//

#import "HCFaqItemListViewController.h"
#import "HCFaqItemViewController.h"
#import "HCFaqCient.h"
#import "HCFaqTheme.h"
#import "HCLocalizable.h"

@interface HCFaqItemListViewController ()

@property (nonatomic, strong) NSArray *faqItems;

@end

@implementation HCFaqItemListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *titleImage = [HCFaqTheme currentTheme].itemListAttr.titleImage;
    if (titleImage) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    }
    
    self.title = HCLocalizedString(@"Questions", nil);
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self loadFaqItems];
}

- (void)loadFaqItems {
    [self startActivity];
    
    NSString *sectionId = self.faqSectionId;
    if (!sectionId.length) {
        sectionId = self.faqSection.objectId;
    }
    [HCFaqCient getFaqItemsWithSectionId:sectionId block:^(NSArray *objects, NSError *error) {
        if (error) {
            [self showError:HCLocalizedString(@"failed to load faq items", nil)];
        } else {
            self.faqItems = objects;
            [self.tableView reloadData];
            [self stopActivity];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.faqItems.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([tableView isEqual:self.tableView]) {
        HCFaqItem *item = self.faqItems[indexPath.row];
        cell.textLabel.text = item.title;
        cell.indentationLevel = 0;
        cell.accessoryView = nil;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        HCFaqItemViewController *sectionvc = [[HCFaqItemViewController alloc] init];
        sectionvc.faqItem = self.faqItems[indexPath.row];
        [self.navigationController pushViewController:sectionvc animated:YES];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
