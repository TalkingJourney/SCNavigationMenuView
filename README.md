# SCNavigationMenuView
#功能
通过点击NavigationTitle，我们可以切换不同的内容，写了一个控件[SCNavigationMenuView](https://github.com/TalkingJourney/SCNavigationMenuView)，实现如下图效果。
![Demo动图.gif](http://upload-images.jianshu.io/upload_images/1635692-e9c09e2f1697abbf.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#优点
1. 可以通过更改数据源，动态的改变选项数量和文字内容；
2. 当数据源数量小于等于1时，自动隐藏小三角图标，文字自动居中，且title不可点击；
3. 下拉出的Menu的Cell样式可以自定义。

#使用方法
####1.初始化
```
SCNavigationMenuView  *menuView = [[SCNavigationMenuView alloc] initWithNavigationMenuItems:nil];
menuView.delegate = self;  // 设置点击menuCell回调的代理
[menuView displayMenuInView:self.view];  // 将menuView展示在哪个view上，self指当前ViwController
```
####2. 设置数据源
```
NSMutableArray *array = [NSMutableArray array];
SCMenuItem *item1 = [SCMenuItem new];
item1.title1 = @"体育内容";
item1.title2 = @"体育";
[array addObject:item1];
    
SCMenuItem *item2 = [SCMenuItem new];
item2.title1 = @"科技内容";
item2.title2 = @"科技";
[array addObject:item2];

// 设置数据源（数据源格式为实现SCNavigationMenuItemProtocol的对象，）后
// 控件会自动更新navigationTitle和menuCell的数据内容
// 数据源可以多次设置
[self.menuView setNavigationMenuItems:array];
```
####3.回调方法
```
#pragma mark - SCNavigationMenuViewDelegate
// 点击menuCell的回调方法
- (void)navigationMenuView:(SCNavigationMenuView *)navigationMenuView didSelectItemAtIndex:(NSUInteger)index
{
    if (index % 2 == 0) {
        self.view.backgroundColor = [UIColor blueColor];
    } else {
        self.view.backgroundColor = [UIColor redColor];
    }
}
```
####4.自定义menuCell需要使用的初始化方法
```
// 初始化方法
// navigationMenuItems为数据源
// menuCellClass自定义menuCell的Class，这个类需要实现SCNavigationMenuCellProtocol协议
- (instancetype)initWithNavigationMenuItems:(NSArray<SCNavigationMenuItemProtocol> *)navigationMenuItems menuCellClass:(Class)menuCellClass;
```
####5.协议
######5.1 数据源需要实现这个协议
```
@protocol SCNavigationMenuItemProtocol <NSObject>

@required

- (NSString *)navigationTitle;
- (NSString *)menuTitle;

@optional

- (NSString *)menuSelectedTitle;

@end
```
######5.2 自定义MenuCell，需要实现这个协议
```
@protocol SCNavigationMenuCellProtocol <NSObject>

@required

// 返回cell的高度  例如：@(44)
// navigationMenuItem 数据源
// reuseID cell重用ID
+ (NSNumber *)cellHeightWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem;
+ (NSString *)reuseID;

// 配置cell的样式和内容
// navigationMenuItem 数据源
// selected cell是否被选中
- (void)configCellWithNavigationMenuItem:(id<SCNavigationMenuItemProtocol>)navigationMenuItem selected:(BOOL)selected;

@end
```
#结束
[SCNavigationMenuView](https://github.com/TalkingJourney/SCNavigationMenuView)使用接口简单方便，可以通过Pod导入到项目中。对于这个小控件有什么建议或者意见的话，可以向我反馈，喜欢的话，也可以通过star来鼓励下我，谢谢大家捧场。
