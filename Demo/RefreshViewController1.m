//
//  RefreshViewController1.m
//  Demo
//
//  Created by guangbool on 2017/2/16.
//  Copyright © 2017年 guangbool. All rights reserved.
//

#import "RefreshViewController1.h"
#import "BOOLRefreshController.h"
#import "LifeGiftRefreshControl.h"

@interface RefreshViewController1 ()

@property (nonatomic) BOOLRefreshController *refreshController;
@property (nonatomic) LifeGiftRefreshControl *refreshView;

@end

@implementation RefreshViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addSubview:({
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
        tipLabel.font = [UIFont systemFontOfSize:20];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"赶快下拉试试";
        tipLabel;
    })];
    
    self.refreshView = [[LifeGiftRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.refreshView.layout = ({
        LifeGifRefreshControlLayout *l = [[LifeGifRefreshControlLayout alloc] init];
        l.imageTop = 13;
        l.imageHeight = 32;
        l.lastUpdateDateLabelTop = 13;
        l.lastUpdateDateLabelheight = 18;
        l.lastUpdateDateLabelBottom = 8;
        l;
    });
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"life_refresh_%@", @(i)]];
        [idleImages addObject:image];
    }
    [self.refreshView setGifImages:idleImages forState:BOOLRefreshControlStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 9; i<=21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"life_refresh_%@", @(i)]];
        [refreshingImages addObject:image];
    }
    [self.refreshView setGifImages:refreshingImages forState:BOOLRefreshControlPulling];
    
    // 设置正在刷新状态的动画图片
    [self.refreshView setGifImages:refreshingImages forState:BOOLRefreshControlRefreshing];
    
    [self.tableView addSubview:self.refreshView];
    CGFloat refreshViewHeight = [self.refreshView intrinsicContentSize].height;
    [self.refreshView setFrame:CGRectMake(0, -refreshViewHeight, CGRectGetWidth([UIScreen mainScreen].bounds), refreshViewHeight)];
    
    __weak typeof(self)weakSelf = self;
    self.refreshController = [[BOOLRefreshController alloc] initWithObservable:self.tableView];
    self.refreshController.refreshThreshold = refreshViewHeight;
    self.refreshController.stateWillChangeBlock = ^(BOOLRefreshController *controller, BOOLRefreshControlState current, BOOLRefreshControlState willState) {
        if ([weakSelf.refreshView respondsToSelector:@selector(stateWillChangeFromCurrent:toState:)]) {
            [weakSelf.refreshView stateWillChangeFromCurrent:current toState:willState];
        }
    };
    
    self.refreshController.stateDidChangedBlock = ^(BOOLRefreshController *controller, BOOLRefreshControlState old, BOOLRefreshControlState currentState) {
        
        if ([weakSelf.refreshView respondsToSelector:@selector(stateDidChangedFromOld:toCurrentState:)]) {
            [weakSelf.refreshView stateDidChangedFromOld:old toCurrentState:currentState];
        }
    };
    
    self.refreshController.pullingPercentChangeBlock = ^(BOOLRefreshController *refreshController, CGFloat pullingPercent){
        if ([weakSelf.refreshView respondsToSelector:@selector(pullingPercentChangeTo:)]) {
            [weakSelf.refreshView pullingPercentChangeTo:pullingPercent];
        }
    };
    
    _refreshController.finishRefreshAnimationBlock = ^(BOOLRefreshController *controller){
        if ([weakSelf.refreshView respondsToSelector:@selector(animateWhenFinishRefresh)]) {
            [weakSelf.refreshView animateWhenFinishRefresh];
        }
    };
    
    self.refreshController.refreshExecuteBlock = ^(BOOLRefreshController *controller){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!weakSelf) return;
            [weakSelf.refreshController finishRefreshing];
        });
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
