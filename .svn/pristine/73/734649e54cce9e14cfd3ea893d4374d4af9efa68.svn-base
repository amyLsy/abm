//
//  ShowingTopicController.m
//  sisitv_ios
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "ShowingTopicController.h"
#import "ShowingTopicDataSource.h"
#import "TopicRequest.h"
@interface ShowingTopicController ()

@property (nonatomic , strong) TopicRowItem *selectRowItem;

@end

@implementation ShowingTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"节目类型";
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(20);
        make.right.bottom.offset(-20);
    }];
    
    TopicRequest *requset = [[TopicRequest alloc]init];
    [requset startWithCompletionBlockWithSuccess:^(__kindof YZGRequest * _Nonnull request) {
        YZGCollectionSectionItem *sectionItem =  [self.dataSource.sectionItems objectAtIndex:0];
        [sectionItem.rowItems addObjectsFromArray:request.item];
        [self.collectionView reloadData];
    } failure:nil];
}
 
-(void)createDataSourceAndLayout{
    self.dataSource = [[ShowingTopicDataSource alloc]init];
    YZGCollectionSectionItem *sectionItem0 = [[YZGCollectionSectionItem alloc]init];
    
    [self.dataSource.sectionItems addObject:sectionItem0];
    
    CGFloat margin = 5.0;
    YZGCollectionViewFlowLayout *layout = [[YZGCollectionViewFlowLayout alloc] initWithRowSpacing:margin columnSpacing:margin];
    self.layout = layout;
    self.cellClassName = @[@"ShowingTopicCollectionCell"];
}

-(void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    self.selectRowItem.selected = NO;
    self.selectRowItem = item;
    self.selectRowItem.selected = YES;
    [self.collectionView reloadData];
}

-(void)dealloc{
    NSString *term_id = self.selectRowItem.term_id;
    NSString *name = self.selectRowItem.name;
    if (term_id) {
        self.selectedTopic(term_id,name);
    }
}

@end
