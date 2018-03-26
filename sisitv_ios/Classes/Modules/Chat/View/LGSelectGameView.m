//
//  LGSelectGameView.m
//  sisitv_ios
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGSelectGameView.h"
#import "sCollectionViewCell.h"
#import "GameModelList.h"
#import "HttpTool.h"
#import "Account.h"
#import "AlertTool.h"
#import "GameGiftListCell.h"
#import "LGRightImageButton.h"


//判断当前游戏界面显示的状态状态
typedef NS_ENUM(NSUInteger, GameSelectStatus) {
    //选择游戏模式
    GameSelectNormal = 1,
    //选择游戏分区
    GameSelectArea,
    //显示礼物列表
    GameShowGift,
    
};

@interface LGSelectGameView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSMutableArray *colleViewArray;
@property(nonatomic,strong) NSMutableArray *tableViewArray;

@property(nonatomic,strong) NSArray *homeDataArray;
@property(nonatomic,assign) GameSelectStatus selectGameStatus;
@property(nonatomic,strong) NSArray *areasArray;

@property (weak, nonatomic) IBOutlet LGRightImageButton *nextButton;
@property (strong, nonatomic)  GameArea *selectGameRrea;
@end

@implementation LGSelectGameView

static NSString *colCellID = @"colCellID";
static NSString *tabCellID = @"tabCellID";




- (void)awakeFromNib{
    
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"sCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:colCellID];
    [_tableView registerNib:[UINib nibWithNibName:@"GameGiftListCell" bundle:nil] forCellReuseIdentifier:tabCellID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册cell
//    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JLGameBlanksCell class]) bundle:nil] forCellReuseIdentifier:blanksCellID];
    GameSelectGameTypeModel *typeModel1 = [[GameSelectGameTypeModel alloc] init];
    typeModel1.name = @"普通区域";
    typeModel1.ID = @"1";
    GameSelectGameTypeModel *typeModel2 = [[GameSelectGameTypeModel alloc] init];
    typeModel2.name = @"实物礼品区";
    typeModel2.ID = @"2";
    _homeDataArray = @[typeModel1,typeModel2];
   _colleViewArray = [NSMutableArray arrayWithArray:_homeDataArray];
    
    
}

- (void)resSet{
    
    self.tableView.hidden = YES;
    self.nextButton.hidden = YES;
    self.titleLabel.text = @"请选择游戏模式";
    self.colleViewArray = [NSMutableArray arrayWithArray:_homeDataArray];
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    _selectGameStatus = 0;
    
}

- (IBAction)backAtion:(id)sender {
    
    if (_tableView.hidden == NO) {
        //当前为显示奖励列表
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        _nextButton.hidden = YES;
        self.titleLabel.text = @"请选择游戏大区";
    }else{
        //当前为tableView为隐藏状态那么就是显示选区列表
        //如果是选择分区那么上一步就是选择游戏模式
        if (_selectGameStatus == GameSelectArea) {
            self.titleLabel.text = @"请选择游戏模式";
            self.colleViewArray = [NSMutableArray arrayWithArray:_homeDataArray];
            [self.collectionView reloadData];
            _selectGameStatus = 0;
            
            
        }else{
            
            NSLog(@"关闭游戏对话框");
            //0最后一步关闭游戏
            [self.delegate selectGameView:self selectType:0 didClickItem:nil];
            
        }
        
        
    }
    
     [self.collectionView reloadData];
    
}
- (IBAction)nextButton:(id)sender {
    
    [self.delegate selectGameView:self selectType:2 didClickItem:self.selectGameRrea];
}


#pragma mark ********** collectionView ***********


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [_colleViewArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth-20)/3, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.colleViewArray[indexPath.row];

    for (int i = 0; i < _colleViewArray.count; i++) {
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:i inSection:0];
        sCollectionViewCell *cell = (sCollectionViewCell *)[collectionView cellForItemAtIndexPath:ipath];
        cell.txtImg.hidden=YES;
        if (indexPath.row == i) {
            cell.txtImg.hidden=NO;
            if ([item isKindOfClass:[GameSelectGameTypeModel class]]) {
                
                _selectGameStatus = i + 1;
                //当前从选择游戏模式进去
                [self requestDataType:_selectGameStatus];
                
            }else if ([item isKindOfClass:[GameArea class]]){
                GameArea *itemArea = (GameArea *)item;
               //当前点击选区之后进去一个tableView展示列表
                NSString *message = [NSString stringWithFormat:@"当前所选区为:%@ 价格为:%@活力是否加入该区？",itemArea.name,itemArea.diamond_num];
                [AlertTool alertWithControllerTitle:@"提示" alertMessage:message preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction * _Nullable action) {
                    
                    _selectGameRrea = itemArea;
                    self.tableView.hidden = NO;
                    self.collectionView.hidden = YES;
                    self.titleLabel.text = @"游戏奖励说明";
                    self.nextButton.hidden = NO;
                    self.tableViewArray = [NSMutableArray arrayWithArray:itemArea.rank_present_list];
                    [self.tableView reloadData];
                    
                } cancleHandler:^(UIAlertAction * _Nullable action) {
                    
                } viewController:self.presenController];
                
                
                
            }
           
        }
    }
    
   
}


- (void)requestDataType:(GameSelectStatus)type{
    
    switch (type) {
        case GameSelectNormal:
            NSLog(@"进入普通游戏区域");
            [self.delegate selectGameView:self selectType:1 didClickItem:nil];
            break;
        case GameSelectArea:
            NSLog(@"进入实物游戏区域");
            [self requestAreaData];
            break;
            
        default:
            break;
    }
    

}

- (void)requestAreaData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [Account shareInstance].token;
    [AlertTool ShowInView:self];
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetPresentAreaList param:param success:^(id responseObject) {
        [AlertTool Hidden];
        if ([responseObject[@"code"] integerValue] == 200) {
          self.areasArray = [GameArea mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
          self.colleViewArray = [NSMutableArray arrayWithArray:self.areasArray];
         self.titleLabel.text = @"请选择游戏大区";
          [self.collectionView reloadData];
        }else{
            
            [AlertTool ShowErrorInView:self withTitle:responseObject[@"descrp"]];
        }
        
    } faile:^{
        
    }];
    
    
    
    
}


#pragma mark ********** tableView ***********

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    sCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:colCellID forIndexPath:indexPath];
    cell.txtImg.hidden=YES;
    //1 为主分类 3为子分类 2为价格
    id item;
    if (self.colleViewArray.count) {
        item = self.colleViewArray[indexPath.row];
    }
    if ([item isKindOfClass:[GameSelectGameTypeModel class]]) {
        GameSelectGameTypeModel *typeItem = (GameSelectGameTypeModel *)item;
        cell.txtlab.text = typeItem.name;
        cell.txtlab.hidden = NO;
    }else if ([item isKindOfClass:[GameArea class]]){
        GameArea *areaItem = (GameArea *)item;
        cell.txtlab.text = [NSString stringWithFormat:@"%@",areaItem.name];
        cell.txtlab.hidden = NO;
        
    }
    
    return cell;
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GameGiftListCell *cell = [tableView dequeueReusableCellWithIdentifier:tabCellID];
    
    [cell setItem:self.tableViewArray[indexPath.row] forIndexPath:indexPath];
    
    
    return cell;
    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableViewArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 71;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    self.tableViewArray = [NSMutableArray arrayWithArray:dataArray];
    self.tableView.hidden = NO;
    self.collectionView.hidden = YES;
    [self.tableView reloadData];
    
    
    
}


@end
