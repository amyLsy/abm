//
//  YZGRefreshCollectionController.h
//  sisitv_ios
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "YZGCollectionViewController.h"
#import "YZGListModel.h"

@interface YZGRefreshCollectionController : YZGCollectionViewController<YZGListModelProtocol>

@property (nonatomic, strong) YZGListModel *listModel;
/**
 创建Model,子类必须实现
 */
- (void)createModel;
/**
 子类请求完成后的处理方法,子类必须实现
 */
- (void)requestDidSuccess;
/**
 配置网络请求,子类必须实现
 */
- (void)configForRequest;

/**
 子类可以不处理,则默认alert错误信息
 */
-(void)requestFaileAlert;
@end
