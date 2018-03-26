//
//  PersonalInformationViewController.m
//  liveFrame
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "PhoneBindingController.h"
#import "BaseWebViewController.h"
#import "Account.h"
#import "HttpTool.h"
#import "AlertTool.h"
 #import "UIImageView+Rouding.h"
#import "YZGAppSetting.h"
@interface PersonalInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signatureViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonToTop;

@property (weak, nonatomic) IBOutlet UIView *avtarView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *tureNameView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UIButton *selecMale;
@property (weak, nonatomic) IBOutlet UIButton *selecFemale;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *phoneStatus;
@property (weak, nonatomic) IBOutlet UITextView *signature;
@property (weak, nonatomic) IBOutlet UIButton *tureName;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *promoteCodeLabel;
//临时变量
@property (nonatomic , strong) UIButton *selectedGenderButton;
@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基本信息";
    self.signature.delegate = self;
    self.saveButton.backgroundColor = kNavColor;
    self.saveButton.layer.cornerRadius = self.saveButton.height/2.0;
    [self.saveButton setBackgroundColor:[UIColor darkGrayColor]];
    [self viewAddTapGestureRecognizer:self.avtarView];
    [self viewAddTapGestureRecognizer:self.phoneView];
    [self viewAddTapGestureRecognizer:self.tureNameView];
    [self viewAddTapGestureRecognizer:self.codeView];
    [self setLayout];
    [self setInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 50)
    {
        textView.text = [textView.text substringToIndex:50];
    }
}

-(void)viewAddTapGestureRecognizer:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewiewClick:)];
    [view addGestureRecognizer:tap];
}

-(void)setLayout{
    self.signatureViewHeight.constant = self.signatureViewHeight.constant *KHeightScale;
    self.otherViewHeight.constant = self.otherViewHeight.constant *KHeightScale;
    self.saveButtonToTop.constant = self.saveButtonToTop.constant *KHeightScale;
    [self.avatar roundingImage];
}
- (void)setInfo{
    Account *account =[Account shareInstance];
    self.name.text = account.user_nicename;
    self.signature.text = account.signature;
    self.ID.text = account.ID;
    [self.avatar sd_setImageWithURL: account.avatar];
    self.phoneStatus.text = account.mobile_status;
    self.promoteCodeLabel.text = account.promote_code;
    self.phoneStatus.textColor = account.mobileStatusColor;
    [self.tureName setTitle:account.is_truename forState:UIControlStateNormal];
    [self.tureName setBackgroundImage:[UIImage imageNamed:account.is_truename] forState:UIControlStateNormal];
    if ([account.sex isEqualToString:@"男性"]) {
        self.selecMale.selected = YES;
        self.selectedGenderButton = self.selecMale;
    }else{
        self.selecFemale.selected = YES;
        self.selectedGenderButton = self.selecFemale;
    }
}

-  (IBAction)genderButtonClick:(UIButton *)button {
    self.selectedGenderButton.selected = NO;
    self.selectedGenderButton = button;
    self.selectedGenderButton.selected = YES;
}
-(void)tapViewiewClick:(UIGestureRecognizer *)tap{
    if (tap.view == self.avtarView) {
        [self avtarViewiewTaped];
    }else if(tap.view == self.phoneView){
        PhoneBindingController *binding = [[PhoneBindingController alloc]init];
        binding.bindingStatus = [Account shareInstance].mobile_status;
        [self.navigationController pushViewController:binding animated:YES];
    }else if(tap.view == self.codeView){
     
        UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"复制推荐码" preferredStyle:UIAlertControllerStyleActionSheet];
        [alerVc addAction:[UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.promoteCodeLabel.text];
            [AlertTool ShowErrorInView:self.view withTitle:@"已经复制到粘贴板"];
        }]];
        [alerVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }]];
        
        [self presentViewController:alerVc animated:YES completion:nil];
    }else{
        NSString *tureNameUrl = [NSString stringWithFormat:@"%@/Appweb/index?token=%@",[YZGAppSetting sharedInstance].appUrl,[[Account shareInstance] token]];
        BaseWebViewController *tureName = [[BaseWebViewController alloc]init];
        tureName.title = @"实名认证";
        tureName.url = [NSURL URLWithString:tureNameUrl];
        [self.navigationController pushViewController:tureName animated:YES];
    }
}
-(void)avtarViewiewTaped{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

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

- (IBAction)saveButtonClick {
    Account *account =[Account shareInstance];
    if (self.name.text.length <=0)
    {
        return;
    }
    NSString *sex = [NSString stringWithFormat:@"%ld",self.selectedGenderButton.tag];
    NSDictionary *param = @{@"token":account.token,
                            @"user_nicename":self.name.text,
                            @"sex":sex,
                            @"signature":self.signature.text,
                            };
    
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagwChangeUserInfo param:param.mutableCopy  success:^(id responseObject) {
        [AlertTool ShowInView:self.view onlyWithTitle:responseObject[@"descrp"] hiddenAfter:1.0];
        [self performSelector:@selector(backToPre) withObject:nil afterDelay:1.0];
    } faile:nil];
}


-(void)backToPre{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    CGSize newSize = CGSizeMake(200.0, 200.0);
    UIImage *newImage =  [self  imageByScalingAndCroppingForSize:newSize WithImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    Account *account = [Account shareInstance];
    [AlertTool ShowInView:self.view withTitle:nil];
    KWeakSelf;
    [account changeAvtar:newImage success:^(BOOL successGetInfo,id responseObj) {
            [AlertTool ShowInView:ws.view onlyWithTitle:responseObj hiddenAfter:1.0];
        if (successGetInfo) {
            ws.avatar.image = newImage;
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize WithImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat orginWidth = imageSize.width;
    CGFloat orginHeight = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / orginWidth;
        CGFloat heightFactor = targetHeight / orginHeight;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= orginHeight * scaleFactor;
        scaledHeight = orginWidth * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
