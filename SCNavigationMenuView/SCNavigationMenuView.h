
#import <UIKit/UIKit.h>
#import "SCNavigationMenuProtocol.h"

typedef void(^MenuBlock)(void);

@class SCNavigationMenuView;
@protocol SCNavigationMenuViewDelegate <NSObject>

- (void)navigationMenuView:(SCNavigationMenuView *)navigationMenuView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface SCNavigationMenuView : UIControl

@property (nonatomic, strong) UIFont *navigationTitleFont;
@property (nonatomic, strong) UIColor *navigationTitleColor;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<id<SCNavigationMenuItemProtocol>> *navigationMenuItems;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, weak) id<SCNavigationMenuViewDelegate> delegate;

- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems menuCellClass:(Class)menuCellClass;
- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems;

- (void)displayMenuInView:(UIView *)view;

- (void)showMenuWithCompletion:(MenuBlock)completion;
- (void)hideMenuWithCompletion:(MenuBlock)completion;

@end
