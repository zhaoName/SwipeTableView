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
        [self.dataArray addObject:[NSString stringWithFormat:@"测试数据%4d", i]];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = self.dataArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了section:%lu row:%lu", indexPath.section, indexPath.row);
}


#pragma mark -- SwipeTableViewDelegate

- (SwipeTableCellStyle)tableView:(UITableView *)tableView styleOfSwipeButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        return SwipeTableCellStyleRightToLeft;
    }
    else{
        return SwipeTableCellStyleLeftToRight;
    }
}

- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView leftSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSArray<SwipeButton *> *)tableView:(UITableView *)tableView rightSwipeButtonsAtIndexPath:(NSIndexPath *)indexPath
{
    SwipeButton *checkBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"check"] touchBlock:^{
        
        NSLog(@"点击了check按钮");
    }];
    checkBtn.frame = CGRectMake(0, 0, 60, 23);
    
    SwipeButton *favBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"fav"] touchBlock:^{
        
        NSLog(@"点击了fav按钮");
    }];
    favBtn.frame = CGRectMake(0, 0, 50, 23);
    
    SwipeButton *menuBtn = [SwipeButton createSwipeButtonWithImage:[UIImage imageNamed:@"menu"] touchBlock:^{
        
        NSLog(@"点击了menu按钮");
    }];
    return @[checkBtn, favBtn, menuBtn];
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
