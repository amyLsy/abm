//
//  MineViewController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MineViewController.h"
#import "PersonalInformationViewController.h"
#import "CostViewController.h"
#import "SystemConfigViewController.h"
#import "PersonalContributionController.h"
#import "UtilityController.h"
#import "SisiConversationListController.h"
#import "BaseNavgationController.h"
#import "BaseWebViewController.h"
#import "ChagerViewController.h"
#import "AlertTool.h"
#import "MineDataSource.h"
#import "Account.h"
#import "LeanCloudTool.h"
#import "YZGAppSetting.h"
#import "LGVideoAndImageListController.h"
#import "LGImageListController.h"
#import "LGShowListController.h"
#import "LGReferencesViewController.h"
#import "LGUserMediaViewController.h"
#import "MyGiftController.h"

NSString * const LGUploadVideoSuccess  = @"LGUploadVideoSuccess";
NSString * const LGUploadImageSuccess  = @"LGUploadImageSuccess";

@interface MineViewController ()<MineHeaderViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic , copy) NSString *url;
@property (nonatomic , weak)  MineHeaderView *headerView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KOnlyHadTabBarViewHeight);
    self.url = [YZGAppSetting sharedInstance].appUrl;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideoSuccess) name:LGUploadVideoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageSuccess) name:LGUploadImageSuccess object:nil];
}

-(void)createDataSource{
    self.dataSource = [[MineDataSource alloc]initWithController:self];
    YZGTableViewSectionItem *sectionItem = [[YZGTableViewSectionItem alloc]init];
    //    YZGTableViewSectionItem *sectionItem1 = [[YZGTableViewSectionItem alloc]init];
    //    YZGTableViewSectionItem *sectionItem2 = [[YZGTableViewSectionItem alloc]init];
    //    YZGTableViewSectionItem *sectionItem3 = [[YZGTableViewSectionItem alloc]init];
    //    YZGTableViewSectionItem *sectionItem4 = [[YZGTableViewSectionItem alloc]init];
    //添加的数据 开车 魏友臣 17/5/12
    NSArray *descrpArray = @[@"贡献榜",@"我的物品",@"媚力",@"美美",@"家族",@"推荐人列表",@"等级",@"主播特长",@"设置"];
    NSArray *imageArray = @[@"list_contribute",@"list_goods",@"list_meili",@"list_meimei",@"list_family",@"list_recommend",@"list_level",@"list_specialty",@"list_setup"];
    if ([YZGAppSetting sharedInstance].isInAppleStore)  {
        descrpArray = @[@"智力",@"家族",@"等级",@"主播特长",@"推荐人列表",@"设置"];
        //        imageArray = @[@"贡献榜",@"秀豆充值",@"我的等级",@"设置"];
    }
    for (NSInteger i =0; i<descrpArray.count; i++) {
        MineRowItem *rowItem = [[MineRowItem alloc]init];
        rowItem.avatar = imageArray[i];
        rowItem.descrp = descrpArray[i];
        [sectionItem.rowItems addObject:rowItem];
    }
    [self.dataSource.sectionItems addObject:sectionItem];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    KWeakSelf;
    [AlertTool ShowInView:self.view withTitle:@"加载中"];
    [[Account shareInstance] getAccountInfoSuccess:^{
        [AlertTool Hidden];
        [ws reoadHeaderItem];
        [ws.tableView reloadData];
    } faile:^{
        [AlertTool Hidden];
    }];
}

-(void)reoadHeaderItem{
    Account *account = [Account shareInstance];
    self.dataSource.headerItem = account;
}
-(void)headerView:(MineHeaderView *)headerView didClickButton:(MineHeaderViewButtonType)buttonType{
    _headerView = headerView;
    switch (buttonType) {
        case MineHeaderViewButtonEdit:
        {
            PersonalInformationViewController *personalInformation = [[PersonalInformationViewController alloc]init];
            [self presentWithViewController:personalInformation];
        }
            break;
        case MineHeaderViewButtonMessage:
        {
            SisiConversationListController *list = [[SisiConversationListController alloc]init];
            [self presentWithViewController:list];
        }
            break;
        case MineHeaderViewButtonFans:
        {
            UtilityController *utility = [[UtilityController alloc]initWithUtilityStyle:UtilityFans];
            utility.ID = [Account shareInstance].ID;
            [self presentWithViewController:utility];
        }
            break;
        case MineHeaderViewButtonAttention:
        {
            UtilityController *utility = [[UtilityController alloc]initWithUtilityStyle:UtilityAttention];
            utility.ID = [Account shareInstance].ID;
            [self presentWithViewController:utility];
        }
            break;
        case MineHeaderViewButtonVideo:
        {
            //图片
            LGUserMediaViewController *vodeoVc = [[LGUserMediaViewController alloc] initWithVcType:1];
            vodeoVc.navigationItem.title = [Account shareInstance].user_nicename;
            vodeoVc.isME = YES;
            LGMediaListModel *model = [[LGMediaListModel alloc] init];
            model.owner_id = [Account shareInstance].ID;
            vodeoVc.mediaModel = model;
            [self presentWithViewController:vodeoVc];
        }
            break;
        case MineHeaderViewButtonPhoto:
        {
            //图片
            LGUserMediaViewController *imageVc = [[LGUserMediaViewController alloc] initWithVcType:2];
            imageVc.navigationItem.title = [Account shareInstance].user_nicename;
            LGMediaListModel *model = [[LGMediaListModel alloc] init];
            model.owner_id = [Account shareInstance].ID;
            imageVc.mediaModel = model;
            imageVc.isME = YES;
            [self presentWithViewController:imageVc];
        }
            break;
        case MineHeaderViewUploadImage:
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"修改背景图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *photoAssetAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  return;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:photoAssetAction];
            [controller addAction:takePhotoAction];
            [controller addAction:cancleAction];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    NSData *backgroundImageDate = UIImageJPEGRepresentation(selectedImage, 0.7);
    UIImage *backgroundImage = [UIImage imageWithData:backgroundImageDate];
    _headerView.bigImageView.image = backgroundImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    Account *account = [Account shareInstance];
    [AlertTool ShowInView:self.view withTitle:nil];
    KWeakSelf;
    [account changeUserBackground:backgroundImage success:^(BOOL isSuccess, id result) {
        if (isSuccess) {
            ws.headerView.bigImageView.image = backgroundImage;
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    MineRowItem *rowItem = (MineRowItem *)item;
    if( [rowItem.descrp isEqualToString:@"贡献榜"]){
        PersonalContributionController *contribution  = [[PersonalContributionController alloc]initWithID:[Account shareInstance].ID];
        [self presentWithViewController:contribution];
    }else if([rowItem.descrp isEqualToString:@"媚力"]){
        
        NSString *exchangeUrl = [NSString stringWithFormat:@"%@/portal/Appweb/earn?token=%@",self.url,[[Account shareInstance] token]];
        BaseWebViewController *exchange = [[BaseWebViewController alloc]init];
        exchange.title = @"媚力";
        exchange.url = [NSURL URLWithString:exchangeUrl];
        [self presentWithViewController:exchange];
        
        //        NSString *exchangeUrl = [NSString stringWithFormat:@"%@/portal/Appweb/recharge?token=%@",self.url,[[Account shareInstance] token]];
        //        ChagerViewController *chager = [[ChagerViewController alloc]init];
        //        chager.title = @"充值";
        //        chager.url = exchangeUrl;
        //        [self presentWithViewController:chager];
    }else if([rowItem.descrp isEqualToString:@"我的物品"]){//我的礼物页面
        
        MyGiftController *mypvc = [[MyGiftController alloc] init];
        mypvc.title = @"我的物品列表";
        [self presentWithViewController:mypvc];//该行负责跳转
        
        //        LGReferencesViewController *refVc = [[LGReferencesViewController alloc] init];//模仿“推荐人列表”设计礼物列表
        //        refVc.title = @"我的礼物列表";
        //        [self presentWithViewController:refVc];
        
    }else if([rowItem.descrp isEqualToString:@"美美"]){
        CostViewController *costViewController = [[CostViewController alloc]init];
        [self presentWithViewController:costViewController];
    }else if([rowItem.descrp isEqualToString:@"家族"]){
        NSString *familyUrl = [NSString stringWithFormat:@"%@/portal/Family/index?token=%@",self.url,[[Account shareInstance] token]];
        BaseWebViewController *exchange = [[BaseWebViewController alloc]init];
        exchange.title = @"我的家族";
        exchange.url = [NSURL URLWithString:familyUrl];
        [self presentWithViewController:exchange];
    }else if([rowItem.descrp isEqualToString:@"等级"]){
        NSString *levelUrl = [NSString stringWithFormat:@"%@/portal/Appweb/grade?token=%@",self.url,[[Account shareInstance] token]];
        BaseWebViewController *myLevel = [[BaseWebViewController alloc]init];
        myLevel.title = @"我的等级";
        myLevel.url = [NSURL URLWithString:levelUrl];
        [self presentWithViewController:myLevel];
    }else if([rowItem.descrp isEqualToString:@"主播特长"]){
        LGShowListController *showList = [[LGShowListController alloc] init];
        showList.title = @"主播特长";
        [self presentWithViewController:showList];
    }else if([rowItem.descrp isEqualToString:@"推荐人列表"]){
        LGReferencesViewController *refVc = [[LGReferencesViewController alloc] init];
        refVc.title = @"推荐人列表";
        [self presentWithViewController:refVc];
    }else if([rowItem.descrp isEqualToString:@"设置"]){
        SystemConfigViewController *systemConfig = [[SystemConfigViewController alloc]init];
        [self presentWithViewController:systemConfig];
    }else if([rowItem.descrp isEqualToString:@"我的发布"]){
        
    }
}

- (void)uploadVideoSuccess{
    //视频
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LGUserMediaViewController *vodeoVc = [[LGUserMediaViewController alloc] initWithVcType:1];
        vodeoVc.navigationItem.title = [Account shareInstance].user_nicename;
        vodeoVc.isME = YES;
        LGMediaListModel *model = [[LGMediaListModel alloc] init];
        model.owner_id = [Account shareInstance].ID;
        vodeoVc.mediaModel = model;
        [self presentWithViewController:vodeoVc];
    });
}

- (void)uploadImageSuccess{
    //图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LGUserMediaViewController *imageVc = [[LGUserMediaViewController alloc] initWithVcType:2];
        imageVc.navigationItem.title = [Account shareInstance].user_nicename;
        LGMediaListModel *model = [[LGMediaListModel alloc] init];
        model.owner_id = [Account shareInstance].ID;
        imageVc.mediaModel = model;
        imageVc.isME = YES;
        [self presentWithViewController:imageVc];
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)presentWithViewController:(UIViewController *)viewController{
    [self presentNeedNavgation:YES hadLeftBackButton:YES presentendViewController:viewController];
}

@end

