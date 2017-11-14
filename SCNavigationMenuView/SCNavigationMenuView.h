
#import <UIKit/UIKit.h>
#import "SCNavigationMenuProtocol.h"

typedef void(^MenuBlock)(void);

@class SCNavigationMenuView;
@protocol SCNavigationMenuViewDelegate <NSObject>

// 点击menuCell的回调
- (void)navigationMenuView:(SCNavigationMenuView *)navigationMenuView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface SCNavigationMenuView : UIControl

@property (nonatomic, copy) NSString *navigationTitle; // 当数据源为空时，显示的NavigationTitle
@property (nonatomic, strong) UIFont *navigationTitleFont;
@property (nonatomic, strong) UIColor *navigationTitleColor;

@property (nonatomic, strong) NSArray<id<SCNavigationMenuItemProtocol>> *navigationMenuItems; // 数据源
@property (nonatomic, assign) NSUInteger currentIndex;  // 当前选中的位置

@property (nonatomic, weak) id<SCNavigationMenuViewDelegate> delegate;


/**
 初始化方法

 @param navigationMenuItems 数据源
 @param menuCellClass 自定义menuCell的Class，这个类需要实现SCNavigationMenuCellProtocol协议
 */
- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems menuCellClass:(Class)menuCellClass;
- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems;

- (void)displayMenuInView:(UIView *)view;   // 将menu展示在哪个view上

- (void)showMenuWithCompletion:(MenuBlock)completion; // 展示
- (void)hideMenuWithCompletion:(MenuBlock)completion; // 隐藏

@end
