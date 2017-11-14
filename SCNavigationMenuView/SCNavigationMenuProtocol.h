
#import <Foundation/Foundation.h>

// 数据源item需要实现的协议
@protocol SCNavigationMenuItemProtocol <NSObject>

@required

- (NSString *)navigationTitle;
- (NSString *)menuTitle;

@optional

- (NSString *)menuSelectedTitle;

@end

// 自定义MenuCell，需要实现这个协议
@protocol SCNavigationMenuCellProtocol <NSObject>

@required

// 返回cell的高度  例如：@(44)
+ (NSNumber *)cellHeightWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem;

// 返回cell重用ID
+ (NSString *)reuseID;


/**
 配置cell的样式和内容

 @param navigationMenuItem 数据源
 @param selected cell是否被选中
 */
- (void)configCellWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem selected:(BOOL)selected;

@end

