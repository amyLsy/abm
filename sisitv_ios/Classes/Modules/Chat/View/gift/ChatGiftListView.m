//
//  ChatGiftView.m
//  liveFrame
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatGiftListView.h"
#import "ChatGiftCollectionViewLayout.h"
#import "YZGCollectionViewLayout.h"

#import "ChatGiftCollectionViewCell.h"
#import "BaseButton.h"
#import "Account.h"
#import "GiftInfo.h"
#import "GiftCache.h"
#import "YZGAppSetting.h"
@interface ChatGiftListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) NSArray *giftDataArray;

@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;

@property (nonatomic , strong) GiftInfo *selectedGiftInfo;
@property (weak, nonatomic) IBOutlet BaseButton *balanceButton;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *hostName;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UIButton *sendGift;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation ChatGiftListView

+(instancetype)giftListView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self collectionView];

    [self.balanceButton setTitleColor:kNavColor forState:UIControlStateNormal];
    self.labelMoney.text = [NSString stringWithFormat:@"%@%@",kBalance,[Account shareInstance].balance];
    
    [[Account shareInstance] addObserver:self forKeyPath:@"balance" options:NSKeyValueObservingOptionNew context:nil];

    [[GiftCache sharedInstance] addObserver:self forKeyPath:@"timeOfInterval" options:NSKeyValueObservingOptionNew context:nil];

    self.giftDataArray = [NSArray arrayWithArray:[YZGAppSetting sharedInstance].giftList];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"balance"] && change[@"new"]){
        self.labelMoney.text = [NSString stringWithFormat:@"%@%@",kBalance,change[@"new"]];
    }else if([keyPath isEqualToString:@"timeOfInterval"]){
        int downCount = [change[NSKeyValueChangeNewKey] intValue];
        if (downCount<=0) {
            [self.sendGift setTitle:@"赠送" forState:UIControlStateNormal];
            [self.sendGift setBackgroundColor:kNavColor];
        }else{
            [self.sendGift setTitle:[NSString stringWithFormat:@"%d",downCount] forState:UIControlStateNormal];
        }
    }
}

-(void)buttonSteTitle:(BaseButton *)button withString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"充值: %@ ",string];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName value:kNavColor range:NSMakeRange(0, 3)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(4, string.length)];
    [button  setAttributedTitle:att forState:UIControlStateNormal];
    [button adjustTitleAtImageViewLeft];
}

-(void)collectionView
{
    ChatGiftCollectionViewLayout *layout = [[ChatGiftCollectionViewLayout alloc ]init];
    layout.scrollDirection = YZGGiftCollectionViewScrollHorizontal;
    layout.horizontalSpacing = 0;
    layout.numberOfLines = 2;
    layout.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.giftCollectionView.collectionViewLayout = layout;
    self.giftCollectionView.pagingEnabled = YES;
    self.giftCollectionView.delegate = self;
    self.giftCollectionView.dataSource = self;
    self.giftCollectionView.showsHorizontalScrollIndicator = NO;
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"ChatGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatGiftCollectionViewCell"];
}

- (IBAction)chongzhi {
    if (self.clickChongZhi) {
        self.clickChongZhi();
    }
}

- (IBAction)sendGiftClick:(UIButton *)button {
    if (!self.didSendedGift) return;
    if (!self.selectedGiftInfo) return;
    self.didSendedGift(self.selectedGiftInfo);
    //self.sendGift.userInteractionEnabled = NO;
}

-(void)giftSendSuccess:(BOOL)success{
    self.sendGift.userInteractionEnabled = YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (collectionView.width)/4;
    CGFloat height = (collectionView.height - 5)/2;

    return CGSizeMake(width, height);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatGiftCollectionViewCell" forIndexPath:indexPath];
    cell.giftInfo = self.giftDataArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedGiftInfo.selected = NO;
    GiftInfo * giftInfo = self.giftDataArray[indexPath.row] ;
    self.selectedGiftInfo = giftInfo;
    self.selectedGiftInfo.selected = YES;
    [self.giftCollectionView reloadData];
}

-(void)removeFromSuperview{

    [super removeFromSuperview];
}
- (IBAction)closeBtn:(id)sender {
    self.removeGiftListView();
    [self removeFromSuperview];
}

-(void)dealloc{
    self.selectedGiftInfo.selected = NO;
    Account *account =  [Account shareInstance];
    [account removeObserver:self forKeyPath:@"balance"];
    [[GiftCache sharedInstance] removeObserver:self forKeyPath:@"timeOfInterval"];
    [GiftCache  destroyInstance];
    YZGLog(@"%@",self);
}
 

@end
