//
//  MLFaqTableViewController.m
//  MaxLeap
//

#import "HCFaqViewController.h"
#import "HCFaqItemViewController.h"
#import "HCFaqCient.h"
#import "HCFaqItem.h"
#import "UIImage+Color.h"
#import "HCLocalizable.h"

@interface HCSearchBar : UISearchBar
@end

@implementation HCSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITextField *tf = [UITextField appearanceWhenContainedIn:[self class], nil];
        tf.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        tf.textColor = [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1.f];
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:HCLocalizedString(@"search", nil) attributes:@{NSFontAttributeName:tf.font, NSForegroundColorAttributeName:[UIColor colorWithRed:222/255.5 green:220/255.f blue:220/255.f alpha:1.f]}];
        
        UIBarButtonItem *button = [UIBarButtonItem appearanceWhenContainedIn:[self class], nil];
        [button setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:100/255.f green:167/255.f blue:235/255.f alpha:1.f]}
                              forState:UIControlStateNormal];
    }
    return self;
}

@end



@interface HCFaqViewController ()
<UISearchBarDelegate>
{
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong) NSArray */* <LCFaqItem> */searchResults;

@end

@implementation HCFaqViewController

- (void)dealloc {
    searchDisplayController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HCLocalizedString(@"FAQ", nil);
    
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    [self setupTableView];
    [self setupSearchBar];
    [self setupSearchDisplayController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.view.bounds;
    if (!self.navigationController) {
        frame.origin.y = [self.topLayoutGuide length];
    }
    self.tableView.frame = frame;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.separatorColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1.f];
    tableView.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:243/255.f alpha:1.f];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupSearchBar {
    UIColor *searchBarBackgroundColor = [UIColor colorWithRed:235/255.5 green:235/255.f blue:235/255.f alpha:1.f];
    HCSearchBar *searchBar = [[HCSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.f)];
    searchBar.placeholder = HCLocalizedString(@"search", nil);
    searchBar.backgroundImage = [UIImage hc_imageWithColor:searchBarBackgroundColor];
    searchBar.delegate = self;
    UIImage *searchFieldBgImage = [[UIImage hc_imageWithColor:[UIColor whiteColor] withSize:CGSizeMake(24, 24) cornerRadius:12] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [searchBar setSearchFieldBackgroundImage:searchFieldBgImage forState:UIControlStateNormal];
    [searchBar setImage:HCImageNamed(@"icon_searchbar_search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.tableView.tableHeaderView = searchBar;
}

- (void)setupSearchDisplayController {
    HCSearchBar *searchBar = (HCSearchBar *)self.tableView.tableHeaderView;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsTableView.separatorColor = self.tableView.separatorColor;
    searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        searchDisplayController.searchResultsTableView.separatorInset = self.tableView.separatorInset;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:searchDisplayController.searchResultsTableView]) {
        return self.searchResults.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *searchCellId = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1.f];
        cell.indentationLevel = 1;
        cell.indentationWidth = 13;
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:HCImageNamed(@"btn_arrow_nomal") highlightedImage:HCImageNamed(@"btn_arrow_selected")];
        [imgView sizeToFit];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imgView.bounds.size.width +10, imgView.bounds.size.height)];
        [view addSubview:imgView];
        cell.accessoryView = view;
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    if ([tableView isEqual:searchDisplayController.searchResultsTableView]) {
        HCFaqItem *item = self.searchResults[indexPath.row];
        cell.textLabel.text = item.title;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:searchDisplayController.searchResultsTableView]) {
        HCFaqItemViewController *itemvc = [HCFaqItemViewController new];
        itemvc.faqItem = self.searchResults[indexPath.row];
        [self.navigationController pushViewController:itemvc animated:YES];
    }
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self showMessage:HCLocalizedString(@"Searching...", nil) onlyText:NO];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [HCFaqCient searchFaqItemWithString:searchBar.text block:^(NSArray *results, NSError *error) {
        
        if (error) {
            [self showError:HCLocalizedString(@"failed to search faq item", nil)];
        } else {
            self.searchResults = results;
            [searchDisplayController.searchResultsTableView reloadData];
        }
        
        [self stopActivity];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end


