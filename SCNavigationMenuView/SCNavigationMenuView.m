
#import "SCNavigationMenuView.h"
#import "SCNavigationMenuTitleCell.h"

#pragma mark - _SCMenuTableView

@interface _SCMenuTableView : UIControl

@property (nonatomic, strong) UITableView *tableView;

- (void)showWithDuration:(NSTimeInterval)duration animations:(MenuBlock)animations completion:(MenuBlock)completion;
- (void)hideWithDuration:(NSTimeInterval)duration animations:(MenuBlock)animations completion:(MenuBlock)completion;

- (void)setTableViewHeight:(CGFloat)height;
- (void)setMenuCellClass:(Class<SCNavigationMenuCellProtocol>)menuCellClass delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate;
- (void)reloadTableViewData;

@end

@implementation _SCMenuTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)showWithDuration:(NSTimeInterval)duration animations:(MenuBlock)animations completion:(MenuBlock)completion
{
    CGRect frame = self.tableView.frame;
    frame.origin.y = -frame.size.height;
    self.tableView.frame = frame;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y = 0;
        self.tableView.frame = frame;
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)hideWithDuration:(NSTimeInterval)duration animations:(MenuBlock)animations completion:(MenuBlock)completion
{
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y = -frame.size.height;
        self.tableView.frame = frame;
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)setTableViewHeight:(CGFloat)height
{
    self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
}

- (void)setMenuCellClass:(Class<SCNavigationMenuCellProtocol>)menuCellClass delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate
{
    NSString *reuseID = [menuCellClass reuseID];
    [self.tableView registerClass:menuCellClass forCellReuseIdentifier:reuseID];
    
    self.tableView.dataSource = delegate;
    self.tableView.delegate = delegate;
}

- (void)reloadTableViewData
{
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end


#pragma mark - SCNavigationMenuView

#define ImageAndTitleDistance   8
#define NavigationTitleDefaultFont [UIFont systemFontOfSize:15]
#define NavigationTitleDefaultColor [UIColor whiteColor]

@interface SCNavigationMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) _SCMenuTableView *menuTableView;

@property (nonatomic, assign) Class<SCNavigationMenuCellProtocol> menuCellClass;
@property (nonatomic, assign) NSUInteger maxTitleWidth;

@property (nonatomic, strong) UIView *menuContainer;

@end

@implementation SCNavigationMenuView

#pragma mark - NavigationMenuButton

- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems menuCellClass:(Class)menuCellClass
{
    self = [super init];
    if (!self) return nil;
    
    if (![menuCellClass conformsToProtocol:@protocol(SCNavigationMenuCellProtocol)]) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _menuCellClass = menuCellClass;
    _currentIndex = NSUIntegerMax;
    _maxTitleWidth = 0;
    _navigationTitleFont = NavigationTitleDefaultFont;
    _navigationTitleColor = NavigationTitleDefaultColor;
    self.navigationMenuItems = navigationMenuItems;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self addTarget:self action:@selector(onActionTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuTableView addTarget:self action:@selector(onActionDimmingView:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems
{
    return [self initWithNavigationMenuItems:navigationMenuItems menuCellClass:[SCNavigationMenuTitleCell class]];
}

- (void)setNavigationMenuItems:(NSArray<id<SCNavigationMenuItemProtocol>> *)navigationMenuItems
{
    [self hideMenuWithCompletion:nil];
    
    for (id<SCNavigationMenuItemProtocol> item in navigationMenuItems) {
        if (![item conformsToProtocol:@protocol(SCNavigationMenuItemProtocol)]) return;
        if (![item respondsToSelector:@selector(navigationTitle)]) return;
    }
    
    _navigationMenuItems = navigationMenuItems;
    
    self.arrowImageView.hidden = navigationMenuItems.count <= 1;
    if (!navigationMenuItems || navigationMenuItems.count == 0) {
        _maxTitleWidth = [self sizeForFont:self.titleLabel.font text:self.navigationTitle ?: @""].width;
        _currentIndex = NSUIntegerMax;
    } else {
        [self reloadMaxTitleWidth];
        _currentIndex = 0;
    }
    [self reloadSubviews];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (currentIndex >= self.navigationMenuItems.count) return;
    
    _currentIndex = currentIndex;
    [self reloadSubviews];
}

- (void)reloadMaxTitleWidth
{
    self.maxTitleWidth = 0;
    for (id<SCNavigationMenuItemProtocol> navigationMenuItem in self.navigationMenuItems) {
        CGFloat width = [self sizeForFont:self.titleLabel.font text:navigationMenuItem.navigationTitle].width;
        if (width > self.maxTitleWidth) {
            self.maxTitleWidth = width;
        }
    }
}

- (void)reloadSubviews
{
    NSString *title;
    if (self.currentIndex >= self.navigationMenuItems.count) {
        title = self.navigationTitle ?: @"";
    } else {
        title = self.navigationMenuItems[self.currentIndex].navigationTitle;
    }
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    CGFloat height = self.titleLabel.bounds.size.height > self.arrowImageView.bounds.size.height ? self.titleLabel.bounds.size.height : self.arrowImageView.bounds.size.height;
    CGFloat width = self.maxTitleWidth + ImageAndTitleDistance + self.arrowImageView.bounds.size.width;
    
    CGFloat spaceAndTitle = self.arrowImageView.hidden ? width : self.maxTitleWidth;
    CGRect titleLabelFrame = self.titleLabel.frame;
    titleLabelFrame.origin.x = (spaceAndTitle - titleLabelFrame.size.width) / 2;
    titleLabelFrame.origin.y = 0;
    titleLabelFrame.size.height = height;
    self.titleLabel.frame = titleLabelFrame;
    
    if (!self.arrowImageView.hidden) {
        self.arrowImageView.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + ImageAndTitleDistance + self.arrowImageView.bounds.size.width / 2, height / 2);
    }
    
    self.bounds = CGRectMake(0, 0, width, height);
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (CGSize)sizeForFont:(UIFont *)font text:(NSString *)text
{
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    return [text boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 44) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
}

- (CGSize)intrinsicContentSize
{
    CGSize size;
    if (@available(iOS 11.0, *)) {
        size = self.bounds.size;
    } else {
        size = [super intrinsicContentSize];
    }
    return size;
}

#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.navigationMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.navigationMenuItems.count) return nil;
    
    NSString *reuseID = [self.menuCellClass reuseID];
    UITableViewCell<SCNavigationMenuCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    id<SCNavigationMenuItemProtocol> item = self.navigationMenuItems[indexPath.row];
    BOOL selected = indexPath.row == self.currentIndex;
    [cell configCellWithNavigationMenuItem:item selected:selected];
    
    return cell;
}

#pragma mark - UITableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.navigationMenuItems.count) return CGFLOAT_MIN;
    
    id<SCNavigationMenuItemProtocol> item = self.navigationMenuItems[indexPath.row];
    NSNumber *cellHeight = [self.menuCellClass cellHeightWithNavigationMenuItem:item];
    
    return cellHeight.floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self hideMenuWithCompletion:^{
        if (indexPath.row >= self.navigationMenuItems.count) return;
        if (indexPath.row == self.currentIndex) return;
        
        self.currentIndex = indexPath.row;
        if ([self.delegate respondsToSelector:@selector(navigationMenuView:didSelectItemAtIndex:)]) {
            [self.delegate navigationMenuView:self didSelectItemAtIndex:indexPath.row];
        }
    }];
}

#pragma mark - Event Response

- (void)onActionTouch:(UIControl *)control
{
    if (self.navigationMenuItems.count <= 1) return;
    
    if (self.selected) {
        [self hideMenuWithCompletion:nil];
    } else {
        [self showMenuWithCompletion:nil];
    }
}

- (void)onActionDimmingView:(UIControl *)control
{
    [self hideMenuWithCompletion:nil];
}

#pragma mark - Public Method

- (void)displayMenuInView:(UIView *)view
{
    self.menuContainer = view;
}

- (void)showMenuWithCompletion:(MenuBlock)completion
{
    if (self.selected) return;
    
    self.menuTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.menuTableView.frame = self.menuContainer.bounds;
    [self.menuContainer addSubview:self.menuTableView];
    CGFloat tableViewHeight = 0;
    for (id<SCNavigationMenuItemProtocol> item in self.navigationMenuItems) {
        NSNumber *cellHeight = [self.menuCellClass cellHeightWithNavigationMenuItem:item];
        tableViewHeight += cellHeight.floatValue;
    }
    [self.menuTableView setTableViewHeight:tableViewHeight];
    [self.menuTableView reloadTableViewData];
    
    [self.menuTableView showWithDuration:0.15 animations:^{
        [self rotateArrow:M_PI];
    } completion:completion];
    
    self.selected = YES;
}

- (void)hideMenuWithCompletion:(MenuBlock)completion
{
    if (!self.selected) return;
    
    [self.menuTableView hideWithDuration:0.15 animations:^{
        self.menuTableView.backgroundColor = [UIColor clearColor];
        [self rotateArrow:0];
    } completion:^{
        [self.menuTableView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    
    self.selected = NO;
}

- (void)rotateArrow:(float)degrees
{
    self.arrowImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
}

#pragma mark - Getter and Setter

- (void)setNavigationTitleFont:(UIFont *)navigationTitleFont
{
    _navigationTitleFont = navigationTitleFont ?: NavigationTitleDefaultFont;
    
    self.titleLabel.font = _navigationTitleFont;
    [self reloadMaxTitleWidth];
    [self reloadSubviews];
}

- (void)setNavigationTitleColor:(UIColor *)navigationTitleColor
{
    _navigationTitleColor = navigationTitleColor ?: NavigationTitleDefaultColor;
    
    self.titleLabel.textColor = _navigationTitleColor;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = self.navigationTitleColor;
        _titleLabel.font = self.navigationTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_down"];
        [_arrowImageView sizeToFit];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

- (_SCMenuTableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[_SCMenuTableView alloc] init];
        [_menuTableView setMenuCellClass:self.menuCellClass delegate:self];
    }
    return _menuTableView;
}

@end
