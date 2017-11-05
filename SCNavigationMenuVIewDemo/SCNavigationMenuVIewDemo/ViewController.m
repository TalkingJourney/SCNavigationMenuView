
#import "ViewController.h"
#import "SCNavigationMenuView.h"

@interface SCMenuItem : NSObject <SCNavigationMenuItemProtocol>

@property (nonatomic, strong) NSString *title1;
@property (nonatomic, strong) NSString *title2;

@end

@implementation SCMenuItem

- (NSString *)navigationTitle
{
    return self.title1 ?: @"";
}

- (NSString *)menuTitle
{
    return self.title2 ?: @"";
}

@end

@interface ViewController () <SCNavigationMenuViewDelegate>

@property (nonatomic, strong) SCNavigationMenuView *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.titleView = self.menuView;
    
    NSMutableArray *array = [NSMutableArray array];
    SCMenuItem *item1 = [SCMenuItem new];
    item1.title1 = @"体育内容";
    item1.title2 = @"体育";
    [array addObject:item1];
    
    SCMenuItem *item2 = [SCMenuItem new];
    item2.title1 = @"科技内容";
    item2.title2 = @"科技";
    [array addObject:item2];
    
    [self.menuView setNavigationMenuItems:array];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    static int i = 0;
    i++;
    
    NSMutableArray *array = [NSMutableArray array];
    SCMenuItem *item1 = [SCMenuItem new];
    item1.title1 = @"体育内容";
    item1.title2 = @"体育";
    [array addObject:item1];
    
    if (i % 2 == 0) {
        SCMenuItem *item2 = [SCMenuItem new];
        item2.title1 = @"科技内容";
        item2.title2 = @"科技";
        [array addObject:item2];
    }
    
    [self.menuView setNavigationMenuItems:array];
}

#pragma mark - SCNavigationMenuViewDelegate

- (void)navigationMenuView:(SCNavigationMenuView *)navigationMenuView didSelectItemAtIndex:(NSUInteger)index
{
    if (index % 2 == 0) {
        self.view.backgroundColor = [UIColor blueColor];
    } else {
        self.view.backgroundColor = [UIColor redColor];
    }
}

- (SCNavigationMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[SCNavigationMenuView alloc] initWithNavigationMenuItems:nil];
        _menuView.delegate = self;
        [_menuView displayMenuInView:self.view];
    }
    return _menuView;
}

@end
