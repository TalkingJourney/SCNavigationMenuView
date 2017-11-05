
#import <Foundation/Foundation.h>

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

// 例如：@(44)
+ (NSNumber *)cellHeightWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem;
+ (NSString *)reuseID;

- (void)configCellWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem selected:(BOOL)selected;

@end

