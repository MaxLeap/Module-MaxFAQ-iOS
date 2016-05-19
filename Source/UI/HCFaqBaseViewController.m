//
//  MLBaseViewController.m
//  MaxLeap
//

#import "HCFaqBaseViewController.h"
#import "MLFaqDejalStatusView.h"
#import "HCFaqTheme.h"
#import "HCLocalizable.h"

@interface HCFaqBaseViewController ()

@property (nonatomic) UIOffset offset;

@end

@implementation HCFaqBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    
    if ([self isEqual:self.navigationController.viewControllers.firstObject]) {
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:HCImageRenderingOriginal(@"ml_btn_navigationbar_close") style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
        [closeItem setImageInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
        self.navigationItem.leftBarButtonItem = closeItem;
    }
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)startActivity {
    [self showMessage:nil onlyText:NO withDuration:-1];
}

- (void)showError:(NSString *)errorMessage {
    [self showMessage:errorMessage onlyText:YES];
}

- (void)showMessage:(NSString *)messge onlyText:(BOOL)onlyText {
    NSTimeInterval duration = [self displayDurationForString:messge];
    [self showMessage:messge onlyText:onlyText withDuration:duration];
}

- (void)showMessage:(NSString *)messge onlyText:(BOOL)onlyText withDuration:(NSTimeInterval)duration {
    [MLFaqDejalBezelActivityView showInView:self.view withText:messge onlyText:onlyText];
    if (duration >= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MLFaqDejalBezelActivityView removeViewAnimated:YES];
        });
    }
}

- (void)stopActivity {
    [MLFaqDejalBezelActivityView removeViewAnimated:YES];
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return MIN((float)string.length*0.06 + 0.5, 5.0);
}

@end
