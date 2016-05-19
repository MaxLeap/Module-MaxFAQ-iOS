//
//  MLSectionListViewController.m
//  MaxLeap
//

#import "HCSectionListViewController.h"
#import "HCFaqItemListViewController.h"
#import "HCFaqCient.h"
#import "HCFaqTheme.h"
#import "HCLocalizable.h"

@interface HCSectionListViewController ()

@property (nonatomic, strong) NSArray *sectionList;

@end

@implementation HCSectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *titleImage = [HCFaqTheme currentTheme].sectionListAttr.titleImage;
    if (titleImage) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadFaqSections];
}

- (void)loadFaqSections {
    
    [self startActivity];
    
    [HCFaqCient getFaqSectionsWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self showError:HCLocalizedString(@"failed to load faq sections", nil)];
        } else {
            self.sectionList = objects;
            [self.tableView reloadData];
            [self stopActivity];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.sectionList.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([tableView isEqual:self.tableView]) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        HCFaqSection *faqSection = self.sectionList[indexPath.row];
        cell.textLabel.text = faqSection.title;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        HCFaqItemListViewController *sectionvc = [[HCFaqItemListViewController alloc] init];
        sectionvc.faqSection = self.sectionList[indexPath.row];
        [self.navigationController pushViewController:sectionvc animated:YES];
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
