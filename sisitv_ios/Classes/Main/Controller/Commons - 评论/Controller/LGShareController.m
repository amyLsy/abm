//
//  LGShareController.m
//  ifaxian
//
//  Created by ming on 16/12/1.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGShareController.h"
#import "HSYTopicCell.h"
#import "LGHeaderFooterView.h"
#import "LGUserMediaViewController.h"
#import "LGCommentCell.h"
#import "HttpTool.h"
#import "Account.h"
#import "AlertTool.h"
#import "LGSubCommt.h"

@interface LGShareController ()
@property(nonatomic, weak) HSYTopicCell *cellView;

@end

@implementation LGShareController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
  
    

}

- (void)sendComments:(LGButtont *)butn{
     LGComment *commentModel = butn.object;
    if (butn.object) {
        //回复评论的评论
       
        if (!self.commentTextField.text.length) {
            [AlertTool ShowErrorInView:self.view withTitle:@"评论不能为空"];
            return;
        }
        [self.commentTextField resignFirstResponder];
       
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"type"] = @(3);
        param[@"item_id"] = commentModel.id;
        param[@"owner_id"] = self.model.owner_id;
        param[@"content"] = self.commentTextField.text;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagComment param:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [AlertTool ShowErrorInView:self.view.superview withTitle:@"评论成功"];
                [self.commentTextField resignFirstResponder];
                self.commentTextField.text = nil;
                self.limit_end = 0;
                [self loadOldData];
                [self.tableView reloadData];
                butn.object = nil;
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
                butn.object = nil;
                
            }
            
        } faile:^{
            [AlertTool ShowErrorInView:self.view withTitle:@"评论失败"];
            butn.object = nil;
        }];
        
        
        
    }else{
        
        
        //回复评论
        if (!self.commentTextField.text.length) {
            [AlertTool ShowErrorInView:self.view withTitle:@"评论不能为空"];
            return;
        }
        [self.commentTextField resignFirstResponder];
       
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"token"] = [Account shareInstance].token;
        param[@"type"] = @(3);
        param[@"item_id"] = self.commentModel.id;
        param[@"owner_id"] = self.model.owner_id;
        param[@"content"] = self.commentTextField.text;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagComment param:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [AlertTool ShowErrorInView:self.view.superview withTitle:@"评论成功"];
                [self.commentTextField resignFirstResponder];
                self.commentTextField.text = nil;
                self.limit_end = 0;
                [self loadOldData];
                
            }else{
                [AlertTool ShowErrorInView:self.view withTitle:responseObject[@"descrp"]];
                
                
            }
            
        } faile:^{
            [AlertTool ShowErrorInView:self.view withTitle:@"评论失败"];
        }];
        
        
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.limit_end = 0;
    self.navigationController.navigationBar.hidden = NO;
    
}


#pragma mark - 添加一个头部的view
- (void)setupTableView{
    
    [super setupTableView];
    [self.navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    UIView *headerView = [[UIView alloc] init];
    LGCommentCell *cellView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LGCommentCell class]) owner:nil options:nil] firstObject];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 84, 0);
    self.tableView.frame = self.view.bounds;
    headerView.frame = CGRectMake(0, 0, KScreenWidth, self.commentModel.rowHeght - 46);
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.comment = self.commentModel;
    cellView.subComentView.hidden = YES;
    cellView.frame = headerView.bounds;
    [headerView addSubview:cellView];
    self.tableView.tableHeaderView = headerView;
    
   
    
}


- (void)loadOldData{
    
    

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    param[@"id"] = _commentModel.id;
    param[@"limit_begin"] = @(self.limit_end);
    param[@"limit_num"] = @"20";
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetSubComments param:param success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 200) {

            if ([responseObject[@"limit_end"] integerValue] < 20) {

                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.limit_end == 0) {
                [self.comments removeAllObjects];
            }
            self.limit_end += 20;
            [self.comments addObjectsFromArray:[LGSubCommt mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            [self.tableView reloadData];
        }

    } faile:^{
        [AlertTool ShowErrorInView:self.view withTitle:@"获取数据失败"];
        [self.tableView.mj_footer endRefreshing];
    }];

    
}




- (void)dealloc{
    [self.cellView removeFromSuperview];
    
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return self.comments.count;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    LGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replyCellID"];
//    //传递当前评论和父评论
//    cell.comment = self.comments[indexPath.row];
//
//
//    return cell;
//
//
//}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == self.tableView) {
//            // 圆角弧度半径
//            CGFloat cornerRadius = 5.f;
//            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
//            cell.backgroundColor = UIColor.clearColor;
//            
//            // 创建一个shapeLayer
//            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//            CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
//            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
//            CGMutablePathRef pathRef = CGPathCreateMutable();
//            // 获取cell的size
//            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
//            
//            // CGRectGetMinY：返回对象顶点坐标
//            // CGRectGetMaxY：返回对象底点坐标
//            // CGRectGetMinX：返回对象左边缘坐标
//            // CGRectGetMaxX：返回对象右边缘坐标
//            
//            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
//            BOOL addLine = NO;
//            // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//            if (indexPath.row == 0) {
//                // 初始起点为cell的左下角坐标
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//                addLine = YES;
//            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//                // 初始起点为cell的左上角坐标
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//            } else {
//                // 添加cell的rectangle信息到path中（不包括圆角）
//                CGPathAddRect(pathRef, nil, bounds);
//                addLine = YES;
//            }
//            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
//            layer.path = pathRef;
//            backgroundLayer.path = pathRef;
//            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
//            CFRelease(pathRef);
//            // 按照shape layer的path填充颜色，类似于渲染render
//            // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
//            layer.fillColor = [UIColor whiteColor].CGColor;
//            // 添加分隔线图层
//            if (addLine == YES) {
//                CALayer *lineLayer = [[CALayer alloc] init];
//                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//                // 分隔线颜色取自于原来tableview的分隔线颜色
//                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//                [layer addSublayer:lineLayer];
//            }
//            
//            // view大小与cell一致
//            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
//            // 添加自定义圆角后的图层到roundView中
//            [roundView.layer insertSublayer:layer atIndex:0];
//            roundView.backgroundColor = UIColor.clearColor;
//            //cell的背景view
//            //cell.selectedBackgroundView = roundView;
//            cell.backgroundView = roundView;
//            
//            //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
//            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//            backgroundLayer.fillColor = tableView.separatorColor.CGColor;
//            [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//            selectedBackgroundView.backgroundColor = UIColor.clearColor;
//            cell.selectedBackgroundView = selectedBackgroundView;
//        }
//    }
//}


@end
