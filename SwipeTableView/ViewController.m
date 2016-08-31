//
//  ViewController.m
//  SwipeTableView
//
//  Created by zhao on 16/8/11.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "ViewController.h"
#import "SwipeTableCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SwipeTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator= NO;
    [self.view addSubview:self.tableView];
    
    for(int i=0; i<10; i++)
    {
        [self.dataArray addObject:[NSString stringWithFormat:@"测试数据%10d", i+100]];
    }
}

#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell ==  nil)
    {
        cell = [[SwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    cell.swipeDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了section:%lu row:%lu", indexPath.section, indexPath.row);
}


#pragma mark -- SwipeTableViewDelegate

//cell的滑动样式
- (SwipeTableCellStyle)tableView:(UITableView *)tableView styleOfSwipeButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return SwipeTableCellStyleBoth;
    }
    else if(indexPath.row % 2 == 0){
        return SwipeTableCellStyleRightToLeft;
    }
    else{
        return SwipeTableCellStyleLeftToRight;
    }
}

//左滑buttons
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView leftSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath
{
    SwipeButton *checkBtn = [SwipeButton createSwipeButtonWithTitle:@"删除峰删除" font:16 textColor:[UIColor blackColor] backgroundColor:[UIColor redColor] image:[UIImage imageNamed:@"check"] touchBlock:^{
        
        NSLog(@"点击了check按钮");
    }];
    SwipeButton *menuBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"menu"] backgroundColor:[UIColor blueColor] touchBlock:^{
        
        NSLog(@"点击了menu按钮");
    }];
    return @[checkBtn, menuBtn];
}

//右滑buttons
- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView rightSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath
{
    //删除操作
    SwipeButton *checkBtn = [SwipeButton createSwipeButtonWithTitle:@"删除峰删除" font:16 textColor:[UIColor blackColor] backgroundColor:[UIColor redColor] image:[UIImage imageNamed:@"check"] touchBlock:^{
        
        //NSLog(@"%lu, %lu", indexPath.section, indexPath.row);
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        NSLog(@"点击了check按钮");
    }];
    
    SwipeButton *favBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"fav"] backgroundColor:[UIColor greenColor] touchBlock:^{
        
        NSLog(@"点击了fav按钮");
    }];
    
    SwipeButton *menuBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"menu"] backgroundColor:[UIColor blueColor] touchBlock:^{
        
        NSLog(@"点击了menu按钮");
    }];
    
    if(indexPath.row == 0){
        return @[checkBtn, favBtn, menuBtn];
    }
    else if(indexPath.row == 2){
        return @[favBtn, menuBtn];
    }
    else{
        return @[checkBtn, menuBtn];
    }
}

//swipeView的弹出样式 **也可以不实现协议方法 直接修改cell.transformMode**
- (SwipeViewTransfromMode)tableView:(UITableView *)tableView swipeViewTransformModeAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 3){
        return  SwipeViewTransfromModeBorder;
    }
    else if (indexPath.row > 7){
        return SwipeViewTransfromMode3D;
    }
    return SwipeViewTransfromModeDefault;
}

#pragma mark -- getter

- (NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
