# SwipeTableView

博客：http://blog.csdn.net/qq244596/article/details/52037253

本文参考：https://github.com/MortimerGoro/MGSwipeTableCell

自定义右滑、左滑tableView时显示的按钮，可以只显示文字、只显示图片或文字图片同时显示。

使用起来也很简单，将Swipe文件夹拖入你的工程中，实现SwipeTableViewDelegate的代理方法，返回左滑或右滑时显示的按钮和按钮的样式。

创建左滑、右滑按钮只需传入文字、图片，按钮会根据文字和图片的大小自适应宽高。swipeView上按钮的位置和系统自带UITableViewRowAction一样，右滑时返回数组的第一个元素在swipeView的最右侧显示，最后一个元素在最左侧显示；左滑时swipeView上按钮的顺序和数组一致。

效果如下

![image](https://github.com/zhaoName/SwipeTableView/blob/master/SwipeTableView.gif)
