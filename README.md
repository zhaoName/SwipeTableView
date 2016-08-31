# SwipeTableView

自定义右滑、左滑tableView时显示的按钮，可以只显示文字、只显示图片或文字图片同时显示。

使用起来也很简单，将Swipe文件夹拖入你的工程中，实现SwipeTableViewDelegate的代理方法，返回左滑或右滑时徐亚显示的按钮和按钮的样式。
/**
 *  设置cell的滑动按钮的样式 左滑、右滑、左滑右滑都有
 *
 *  @param indexPath cell的位置
 */
- (SwipeTableCellStyle)tableView:(UITableView *)tableView styleOfSwipeButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  左滑cell时显示的button
 *
 *  @param indexPath cell的位置
 */
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView leftSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  右滑cell时显示的button
 *
 *  @param indexPath cell的位置
 */
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView rightSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath;

创建左滑、右滑按钮只需传入文字、图片，按钮会根据文字和图片的大小自适应宽高。

效果如下
