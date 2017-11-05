
#import "SCNavigationMenuTitleCell.h"

@interface SCNavigationMenuTitleCell ()

@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SCNavigationMenuTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView.layer addSublayer:self.lineLayer];
        
        [self.contentView addSubview:self.titleLabel];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.contentView addConstraints:@[top, left, right, bottom]];
    }
    return self;
}

+ (NSNumber *)cellHeightWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem
{
    return @(43);
}

+ (NSString *)reuseID
{
    return NSStringFromClass(self);
}

- (void)configCellWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem selected:(BOOL)selected
{
    NSString *title;
    UIColor *color;
    if (selected) {
        NSString *selectedTitle;
        if ([navigationMenuItem respondsToSelector:@selector(menuSelectedTitle)]) {
            selectedTitle = [navigationMenuItem menuSelectedTitle];
        }
        title = selectedTitle.length > 0 ? selectedTitle : [navigationMenuItem menuTitle];
        color = [UIColor orangeColor];
    } else {
        title = [navigationMenuItem menuTitle];
        color = [UIColor darkGrayColor];
    }
    self.titleLabel.text = title ?: @"";
    self.titleLabel.textColor = color;
}

- (CALayer *)lineLayer
{
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [UIColor grayColor].CGColor;
        CGFloat height = 1 / UIScreen.mainScreen.scale;
        _lineLayer.frame = CGRectMake(45, 0, UIScreen.mainScreen.bounds.size.width - 90, height);
    }
    return _lineLayer;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

@end
