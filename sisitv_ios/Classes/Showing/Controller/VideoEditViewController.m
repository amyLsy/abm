//
//  VideoEditViewController.m
//  sisitv_ios
//
//  Created by Ming on 2017/12/21.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#import "VideoEditViewController.h"
#import "AliyunCoverPickViewController.h"
#import "UITextField+LGTextField.h"
#import "YZGAppSetting.h"
#import "AVAsset+VideoInfo.h"
#import "LGAliYunOssUpload.h"
#import "AlertTool.h"
#import "MBProgressHUD.h"
#import "HttpTool.h"
#import "Account.h"
#import <VODUpload/VODUploadSVideoClient.h>
#import "LGAliAccessToken.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZImagePickerController.h"
#import "LGPhotoImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <VODUpload/VODUploadClient.h>
#import "AlertTool.h"
#import "LGUploadTermsModel.h"
#import "NSURL+LGGetVideoImage.h"



@interface VideoEditViewController ()<LGAliYunOssUploadDelegate,VODUploadSVideoClientDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UIButton *pikConverImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *converImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (weak, nonatomic) IBOutlet UIImageView *bacView;
@property (nonatomic, strong) LGAliYunOssUpload *uploadManager;
@property (nonatomic, strong) VODUploadSVideoClient *client;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *imageUrls;
@property (weak, nonatomic) UITextView *textView;
@property (strong, nonatomic) LGPhotoImage *lastImage;
@property (nonatomic,strong) UIButton *sendButton;
@property (assign, nonatomic)  CGFloat maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *types;

@property (nonatomic, copy) OnUploadStartedListener testUploadStartedCallbackFunc;
@property (nonatomic, copy) OnUploadSucceedListener testSuccessCallbackFunc;
@property (nonatomic, copy) OnUploadFailedListener testFailedCallbackFunc;
@property (nonatomic, copy) OnUploadProgressListener testProgressCallbackFunc;
@property (nonatomic, copy) OnUploadTokenExpiredListener testTokenExpiredCallbackFunc;
@property (nonatomic, copy) OnUploadRertyListener testUploadRertyListener;
@property (nonatomic, copy) OnUploadRertyResumeListener testUploadRertyResumeListener;

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *selectType;
@property (strong, nonatomic) UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (copy, nonatomic) NSString *curItemID;
@property (copy, nonatomic) NSString *locationStr;
@property (strong, nonatomic) UIView *pickBgView;
@end

@implementation VideoEditViewController{
    
      BOOL _isSelectOriginalPhoto;
    //选择的图片数组
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSString *imageFileName;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
     self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uploadManager = [[LGAliYunOssUpload alloc] init];
    self.uploadManager.delegate = self;
    self.pikConverImageBtn.backgroundColor = rgba(0, 0, 0, 0.5);
    self.pikConverImageBtn.layer.cornerRadius = 2;
    self.pikConverImageBtn.layer.masksToBounds = YES;
    [self.pikConverImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendString;
     [self addNoti];
    if (_vcType == 1) {
        
       appendString = [[NSAttributedString alloc] initWithString:@"   选择封面" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
       
        [self loadImage];
        _titleLabel.text = @"视频";
        
        //1.初始化短视频上传对象
        _client = [[VODUploadSVideoClient alloc] init];
        _client.delegate = self;
        _client.transcode = NO;//是否转码，建议开启转码
        //上传图片
        _titleTextField.placeholder = @"请输入视频描述";
        _descTextField.placeholder = @"请输入视频描述";
    }else{
       appendString  = [[NSAttributedString alloc] initWithString:@"   选择图片" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        _maxCountTF = 1;
        _titleLabel.text = @"发布图片";
        _titleTextField.placeholder = @"请输入图片描述";
        _descTextField.placeholder = @"请输入图片描述";
    }
    [attributedString appendAttributedString:appendString];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icon_cover"];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    [self.pikConverImageBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.pikConverImageBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    self.view.backgroundColor = RGB_COLOR(26, 31, 50, 1);
    self.titleTextField.lg_placeholderColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.descTextField.lg_placeholderColor = [UIColor colorWithWhite:1 alpha:0.8];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateMessage) name:kAppUpDateCurrentPosition object:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self updateLocation];
    
   
    
    
}

- (void)updateLocation{
    
    [[YZGAppSetting sharedInstance] getCurrentLocation];
    //更新地理位置
  
    
}


-(void)receiveLocationUpdateMessage{
    
    
    [[YZGAppSetting sharedInstance] updateCurrentLocationToServer:^(BOOL isSuccess ,NSString *location) {
        
        //更新位置成功
        NSLog(@"%@",location);
        _locationStr = location;
    }];
}




- (UIImage *)coverImageAtTime:(CMTime)time {
    CGImageRef image = [self.imageGenerator copyCGImageAtTime:time actualTime:NULL error:nil];
    UIImage *picture = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    return picture;
}


- (void)loadImage{
    
    
    [NSURL thumbnailImageForVideo:[NSURL fileURLWithPath:_videoPath] atTime:1.0 completion:^(UIImage *thumbnailImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (thumbnailImage) {
                self.converImageView.image = thumbnailImage;
                
            }
            
        });
    }];
   
    
}
- (void)keyboardWillShow:(NSNotification *)note {
    CGRect end = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat containerHeight = StatusBarHeight+44+ScreenWidth+52+62;
    
    CGFloat offset = ScreenHeight-CGRectGetHeight(end)-containerHeight;
    if (offset<0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, offset, ScreenWidth, ScreenHeight);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

- (void)applicationDidBecomeActive {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)userLocation:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"开启定位"]) {
        sender.userInteractionEnabled = NO;
        [sender setTitle:@"定位中..." forState:UIControlStateNormal];
        [[YZGAppSetting sharedInstance] getCurrentLocation];
    }else{
        [sender setTitle:@"开启定位" forState:UIControlStateNormal];
    }
    
}

- (void)aliyunOssUploa:(LGAliYunOssUpload *)upload Progress:(CGFloat)progress{
    
    
    [SVProgressHUD showProgress:progress/100.0];
    
}


#pragma mark 选择视频封面或者图片
- (IBAction)pickImage:(id)sender {
    
    if (_vcType == 1) {
        
        AliyunCoverPickViewController *vc = [[AliyunCoverPickViewController alloc] init];
        vc.videoPath = self.videoPath;
        vc.outputSize = self.outputSize;
        
        vc.finishHandler = ^(UIImage *image){
            
            _converImageView.image = image;
            
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self pushImagePickerController];
        
    }
   
    
    
    
}

/**
 上传成功
 @param vid 视频vid
 @param imageUrl 图片路径
 */
- (void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl;{
    NSLog(@"%@--%@",vid,imageUrl);
    
  
    dispatch_async(dispatch_get_main_queue(), ^{
        //得到视频的video
        [SVProgressHUD showWithStatus:@"正在提交数据.."];
//        NSString *title = self.titleTextField.text;
        NSString *des = self.titleTextField.text;
        NSString *location = @"";
        NSString *longitude = @"";
        NSString *latitude = @"";
        if (1) {
            //位置
            location = _locationStr;
            
            //纬度
            latitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].latitude];
            //经度
            longitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].longitude];
        }
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyMMddhhmmss"];
        NSString *timeTitle = [NSString stringWithFormat:@"%@.mp4",[fmt stringFromDate:[NSDate date]]];
        
        //视频时间
        NSInteger duration = [self durationWithVideo:[NSURL fileURLWithPath:self.videoPath]];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"video_id"] = vid;
        param[@"title"] = timeTitle;
        param[@"thumb"] = imageUrl;
        param[@"desc"] = des;
        param[@"duration"] = @(duration);
        param[@"location"] = location;
        param[@"latitude"] = latitude;
        param[@"longitude"] = longitude;
        param[@"type"] = @"1";
        param[@"term_id"] = self.curItemID;
        param[@"token"] = [Account shareInstance].token;
        [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserUpload param:param success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue] == 200) {
                 [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LGUploadVideoSuccess" object:nil];
                [_presenVc dismissViewControllerAnimated:YES completion:nil];
               
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"发布失败"];
            }
            
        } faile:^{
            [SVProgressHUD dismiss];
        }];
        ///上传封面
    });
    
   


    
    
}
//上传失败
- (void)uploadFailedWithCode:(NSString *)code message:(NSString *)message;{
    
    [SVProgressHUD showErrorWithStatus:@"上传失败"];
}

/**
 上传进度
 @param uploadedSize 已上传的文件大小
 @param totalSize 文件总大小
 */
- (void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"%f",(uploadedSize * 0.1)/(totalSize * 0.1));
        CGFloat progress = (uploadedSize * 0.1)/(totalSize * 0.1);
        NSLog(@"%f",progress);
        self.progressView.progress = progress;
    });
    
}


#pragma mark - 开始上传
- (IBAction)submit:(id)sender {
    
    if (!_titleTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"描述不能为空"];
        return;
    }
     [SVProgressHUD show];
    if (_vcType == 1) {
        
       //视频
        NSURL * urlk = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_upload_auth",AppApi]];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlk];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [[NSString stringWithFormat:@"token=%@",[Account shareInstance].token] dataUsingEncoding:NSUTF8StringEncoding];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        
        // 发送请求
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            return;
                                                        }
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            LGAliAccessToken *accessToken = [LGAliAccessToken mj_objectWithKeyValues:object[@"data"]];
            
            UIImage *imagesave = self.converImageView.image;
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
            [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
            //
            VodSVideoInfo *videoInfo = [[VodSVideoInfo alloc] init];
            videoInfo.title = self.titleTextField.text;
            videoInfo.desc = self.descTextField.text;
            
//            LGAliYunOssUpload *upload = [[LGAliYunOssUpload alloc] init];
            
//            [upload uploadfilePath:_videoPath fileName:@"125368.mp4" bucketName:nil completion:^(BOOL isSuccess, NSString *url) {
//
//                if (isSuccess) {
//                    NSLog(@"%@",url);
//                }
//
//            }];
//
//            return;
            [SVProgressHUD showWithStatus:@"正在上传...."];
            [self.client uploadWithVideoPath:_videoPath imagePath:imagePath svideoInfo:videoInfo accessKeyId:accessToken.AccessKeyId accessKeySecret:accessToken.AccessKeySecret accessToken:accessToken.SecurityToken];
        }

    }else{
        //上传图片
        [SVProgressHUD showWithStatus:@"正在上传...."];
        OnUploadSucceedListener testSuccessCallbackFunc = ^(UploadFileInfo* fileInfo){
          [SVProgressHUD showWithStatus:@"图片上传成功"];
            NSString *endpoint = @"";
            if ([fileInfo.endpoint hasPrefix:@"https://"]) {
                NSString *hasPrefix = @"https://";
                endpoint = [fileInfo.endpoint substringFromIndex:hasPrefix.length];
            }else if ([fileInfo.endpoint hasPrefix:@"http://"]){
                NSString *hasPrefix = @"http://";
                endpoint = [fileInfo.endpoint substringFromIndex:hasPrefix.length];
                
            }else{
                
                endpoint = fileInfo.endpoint;
            }

            NSString *imageUrlStr = [NSString stringWithFormat:@"http://%@.%@/%@",fileInfo.bucket,endpoint,fileInfo.object];
            dispatch_async(dispatch_get_main_queue(), ^{
                //得到视频的video
                [SVProgressHUD showWithStatus:@"正在提交数据.."];
//                NSString *title = self.titleTextField.text;
                NSString *des = self.titleTextField.text;
                NSString *location = @"";
                NSString *longitude = @"";
                NSString *latitude = @"";
                if (1) {
                    //位置
                    location = _locationStr;
                    
                    //纬度
                    latitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].latitude];
                    //经度
                    longitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].longitude];
                }
                
               
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"uri"] = imageUrlStr;
                param[@"title"] = imageFileName;
                param[@"thumb"] = imageUrlStr;
                param[@"desc"] = des;
                param[@"location"] = location;
                param[@"latitude"] = latitude;
                param[@"longitude"] = longitude;
                param[@"type"] = @(self.vcType);
                param[@"token"] = [Account shareInstance].token;
                param[@"term_id"] = self.curItemID;
                NSLog(@"%@",param);
                [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserUpload param:param success:^(id responseObject) {
                    [SVProgressHUD dismiss];
                    NSLog(@"%@",responseObject);
                    if ([responseObject[@"code"] integerValue] == 200) {
                        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                        //                [self.navigationController popToRootViewControllerAnimated:YES];
                         [[NSNotificationCenter defaultCenter] postNotificationName: @"LGUploadImageSuccess" object:nil];
                        [self dismissViewControllerAnimated:YES completion:^{
                         
                        }];
                    }else{
                        
                        [SVProgressHUD showErrorWithStatus:@"发布失败"];
                    }
                    
                } faile:^{
                    [SVProgressHUD dismiss];
                }];
                ///上传封面
            });
            
            
        };
        OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo* fileInfo, NSString *code, NSString * message){
            NSLog(@"failed code = %@, error message = %@", code, message);
        };
        // 单位：字节
        OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
            self.progressView.progress = (uploadedSize * 0.1) / (uploadedSize *0.1);
        };
        OnUploadTokenExpiredListener testTokenExpiredCallbackFunc = ^{
            NSLog(@"*token expired.");
            // get token and call resmeUploadWithAuth.
        };
        OnUploadRertyListener testUploadRertyListener = ^{
            NSLog(@"retry begin.");
        };
        OnUploadRertyResumeListener testUploadRertyResumeListener = ^{
            NSLog(@"retry resume.");
        };
        

       
       
        
        NSURL * urlk = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_upload_auth",AppApi]];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlk];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [[NSString stringWithFormat:@"token=%@",[Account shareInstance].token] dataUsingEncoding:NSUTF8StringEncoding];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        
        // 发送请求
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            return;
                                                        }
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            LGAliAccessToken *accessToken = [LGAliAccessToken mj_objectWithKeyValues:object[@"data"]];
            
            UIImage *imagesave = self.converImageView.image;
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
            [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
            //
            VodSVideoInfo *videoInfo = [[VodSVideoInfo alloc] init];
            videoInfo.title = self.titleTextField.text;
            videoInfo.desc = self.descTextField.text;
            
            
            
            
            NSString *imageID = [[NSUUID UUID] UUIDString];
            NSString *imageName;
            NSData *data;
            LGPhotoImage *photoImage = self.imagesArray.lastObject;
            if (photoImage == nil) {
                [SVProgressHUD showInfoWithStatus:@"图片不能为空"];
                return;
            }
            if (photoImage.isGif) {
                imageName = [NSString stringWithFormat:@"squareImages/%@.gif",imageID];
                data = photoImage.imageData;
            }else{
                
                data = UIImageJPEGRepresentation(photoImage.image, 0.9);
                imageName = [NSString stringWithFormat:@"squareImages/%@.jpg",imageID];
            }
            
            
            
            UIImage *imgesave = self.converImageView.image;
            NSString *pathsandox = NSHomeDirectory();
            NSString *imgPath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
            [UIImagePNGRepresentation(imgesave) writeToFile:pathsandox atomically:YES];
            
            
            
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"token"] = [Account shareInstance].token;
            param[@"title"] = self.titleTextField.text;
            param[@"name"] = imageName;
            param[@"desc"] = self.descTextField.text;
            param[@"type"] = @(self.vcType);
          
            ///上传图片
//            [self.uploadManager uploadfileData:data fileName:@"test/123.jpg" bucketName:nil completion:^(BOOL isSuccess,NSString *url) {
//                [SVProgressHUD dismiss];
//                if (isSuccess) {
//
//
//                }
//
//            }];
            
            [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUploadInfo param:param success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200) {

                    OnUploadStartedListener testUploadStartedCallbackFunc;
                    VODUploadListener *listener;
                    listener = [[VODUploadListener alloc] init];
                   
                    listener.success = testSuccessCallbackFunc;
                    listener.failure = testFailedCallbackFunc;
                    listener.progress = testProgressCallbackFunc;
                    listener.expire = testTokenExpiredCallbackFunc;
                    listener.retry = testUploadRertyListener;
                    listener.retryResume = testUploadRertyResumeListener;
                    
                    UploadFileInfo *fileInfo = [[UploadFileInfo alloc] init];
                    fileInfo.filePath = responseObject[@"data"][@"imageUrl"];
                    fileInfo.endpoint = accessToken.endpoint;
                    fileInfo.bucket = accessToken.bucket;
                    fileInfo.object = imageName;
                      VODUploadClient *upClient = [[VODUploadClient alloc] init];
                    testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
                      
                      
                           [upClient setUploadAuthAndAddress:fileInfo uploadAuth:responseObject[@"data"][@"uploadAuth"] uploadAddress:responseObject[@"data"][@"uploadAddress"]];
                    };
                    listener.started = testUploadStartedCallbackFunc;
                   BOOL isSuc = [upClient init:accessToken.AccessKeyId accessKeySecret:accessToken.AccessKeySecret secretToken:accessToken.SecurityToken expireTime:accessToken.Expiration listener:listener];
                    [upClient addFile:imgPath endpoint:accessToken.endpoint bucket:accessToken.bucket object:imageName];
                BOOL isSucc = [upClient start];
                    NSLog(@"%zd",isSuc);
                }


            } faile:^{

            }];
            
            
        }
        
        
       
    }
    

}

-(void)uploadImage{
    
    [SVProgressHUD showWithStatus:@"正在提交数据.."];
    ///上传封面
    [self.uploadManager uploadfileData:UIImagePNGRepresentation(self.converImageView.image) fileName:@"123.jpg" bucketName:nil completion:^(BOOL isSuccess,NSString *url) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            
            NSString *title = self.titleTextField.text;
            NSString *des = self.descTextField.text;
            NSString *location = @"";
            NSString *longitude = @"";
            NSString *latitude = @"";
            
            
            if (![self.location.titleLabel.text isEqualToString:@"开启定位"]) {
                //位置
                location = [self.location titleForState:(UIControlStateNormal)];
                //经度
                longitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].longitude];
                //纬度
                latitude = [NSString stringWithFormat:@"%f",[YZGAppSetting sharedInstance].latitude];
            }
            
            //视频时间
            NSInteger duration = [self durationWithVideo:[NSURL fileURLWithPath:self.videoPath]];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"video_id"] = @"kQuINGdPbLOg";
            param[@"title"] = title;
            param[@"thumb"] = self.converImageView;
            param[@"desc"] = des;
            param[@"duration"] = @(duration);
            param[@"location"] = location;
            param[@"latitude"] = latitude;
            param[@"longitude"] = longitude;
            param[@"type"] = @"1";
            param[@"token"] = [Account shareInstance].token;
            param[@"term_id"] = self.curItemID;
            
            [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagUserUpload param:param success:^(id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"code"] integerValue] == 200) {
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"发布失败"];
                }
                
            } faile:^{
                [SVProgressHUD dismiss];
            }];
            
        }
        
    }];
    
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLocationUpdateMessage) name:kAppUpDateCurrentPosition object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}



- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:_videoPath]];
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        _imageGenerator.appliesPreferredTrackTransform = YES;
        _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        _imageGenerator.maximumSize = CGSizeMake(100, 100);
    }
    return _imageGenerator;
}

- (NSUInteger)durationWithVideo:(NSURL *)videoUrl{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoUrl options:opts];
    // 初始化视频媒体文件
    NSUInteger second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale;
    // 获取视频总时长,单位秒
    return second;
    
}



#pragma mark 进入选择图片控制器
- (void)pushImagePickerController {
    
    CGFloat maxCount = self.maxCountTF;
    if (maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.navigationBar.tintColor = [UIColor darkGrayColor];
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //当前为一张图片
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    //    imagePickerVc.showSelectBtn = NO;
    //    imagePickerVc.allowCrop = NO;
    //    imagePickerVc.needCircleCrop = NO;
    //    imagePickerVc.circleCropRadius = 100;
    
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        //如果是原图
//        //对gif进行判断
//        [self getImages:assets];
//
//
//    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - 对是否要拿gif判断
- (void)getImages:(NSArray *)assets{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    // 从asset中获得图片
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    for (PHAsset *asset in assets) {
        
        
        
        KWeakSelf;
        [imageManager requestImageDataForAsset:asset
                                       options:options
                                 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                     //gif 图片
                                     
                                     if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                                         //这里获取gif图片的NSData数据
                                         LGPhotoImage *image = [LGPhotoImage phototisGif:YES image:[UIImage imageWithData:imageData] imageData:imageData];
                                         [ws.imagesArray addObject:image];
                                         
                                         
                                         
                                     } else {
                                         //这里获取其他图片的NSData数据
                                         LGPhotoImage *image = [LGPhotoImage phototisGif:NO image:[UIImage imageWithData:imageData] imageData:imageData];
                                         [ws.imagesArray addObject:image];
                                         
                                     }
                                      LGPhotoImage *pImage = ws.imagesArray.lastObject;
                                     UIImage *imgesave = pImage.image;
                                     UIImage *wateImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo_watermark.png" ofType:nil]];
                                     UIImage *uploadImage = [self addWatemarkImageWithLogoImage:imgesave watemarkImage:wateImage logoImageRect:CGRectMake(0, 0, imgesave.size.width, imgesave.size.height) watemarkImageRect:CGRectMake(-80, -80, wateImage.size.width * 0.15, wateImage.size.height * 0.15)];
                                     
                                     _converImageView.image = uploadImage;
                                 }];
    }
    
}



- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self getImages:assets];
    
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
}




/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        imageFileName = fileName;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage watemarkImage:(UIImage *)watemarkImage logoImageRect:(CGRect)logoImageRect watemarkImageRect:(CGRect)watemarkImageRect{
    // 创建一个graphics context来画我们的东西
    UIGraphicsBeginImageContext(logoImageRect.size);
    // graphics context就像一张能让我们画上任何东西的纸。我们要做的第一件事就是把person画上去
    [logoImage drawInRect:CGRectMake(0, 0, logoImageRect.size.width, logoImageRect.size.height)];
    // 然后在把hat画在合适的位置
    [watemarkImage drawInRect:CGRectMake(watemarkImageRect.origin.x, watemarkImageRect.origin.y, watemarkImageRect.size.width, watemarkImageRect.size.height)];
    // 通过下面的语句创建新的UIImage
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    return newImage;
}




#pragma 发送图片

- (void)sendImage:(id)sender {
    
    
    KWeakSelf;
    dispatch_group_t group = dispatch_group_create();
    //    [SVProgressHUD showWithStatus:@"正在上传图片.."];
    for (LGPhotoImage *photoImage in self.imagesArray) {
        
        NSString *imageID = [[NSUUID UUID] UUIDString];
        NSString *imageName;
        NSData *data;
        if (photoImage.isGif) {
            imageName = [NSString stringWithFormat:@"squareImages/%@.gif",imageID];
            data = photoImage.imageData;
        }else{
            
            data = UIImageJPEGRepresentation(photoImage.image, 0.9);
            imageName = [NSString stringWithFormat:@"squareImages/%@.jpg",imageID];
        }
        dispatch_group_enter(group);
        
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
            [ws.uploadManager uploadfileData:data fileName:imageName bucketName:nil completion:^(BOOL isSuccess ,NSString *url) {
                if (isSuccess) {
                    if (photoImage.isGif) {
                        
                        [ws.imageUrls addObject:[NSString stringWithFormat:@"%@.gif",imageID]] ;
                    }else{
                        [ws.imageUrls addObject:[NSString stringWithFormat:@"%@.jpg",imageID]] ;
                    }
                    dispatch_group_leave(group);
                    
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
                    return ;
                }
            }];
            
        });

}
}

    
- (NSMutableArray *)imagesArray{
    
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;
}

- (UIImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            
            
        }
        //        /Users/ming/Desktop/ifaxan/ifaixan/ifaxian/ifaxian/Classess/Other-其他/Controller/LGWriteController/Controller/LGSenImageController.m:84:42: 'appearanceWhenContainedIn:' is deprecated: first deprecated in iOS 9.0 - Use +appearanceWhenContainedInInstancesOfClasses: instead
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)addPickBgView{
    [self.pickBgView addSubview:self.pickView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickBgView];
}

-(UIView *)pickBgView{
    if (!_pickBgView) {
        _pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hidePickBgView)];
        tapGes.numberOfTapsRequired = 1;
        [_pickBgView addGestureRecognizer:tapGes];
        _pickBgView.backgroundColor = rgba(0, 0, 0, 0.5);
    }
    return _pickBgView;
}

- (void)hidePickBgView{
    [self.pickBgView removeFromSuperview];
    self.pickBgView = nil;
}

- (IBAction)selectType:(id)sender {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @(_vcType);
    KWeakSelf;
    [HttpTool requestWithUrlFlag:HttpRequsetUrlFlagGetUploadTerms param:param success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSMutableArray *dataArray = [NSMutableArray array];
            LGUploadTermsModel *typeName = [[LGUploadTermsModel alloc] init];
            typeName.name = @"请滑动选择分类";
            [dataArray addObject:typeName];
            [dataArray addObjectsFromArray:[LGUploadTermsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            self.types = dataArray;
//            [[UIApplication sharedApplication].keyWindow addSubview:self.pickView];
            [ws addPickBgView];
        }
    } faile:^{
        
    }];
    
    
}


//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.types.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    LGUploadTermsModel *term = [_types objectAtIndex:row];
    return term.name;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    // 使用一个UIAlertView来显示用户选中的列表项
    LGUploadTermsModel *term = [_types objectAtIndex:row];
    if (term.id == nil) {
        
        [self.selectType setTitle:@"请选择分类" forState:UIControlStateNormal];
        [pickerView removeFromSuperview];
        [self hidePickBgView];
        return;
    }
     [self.selectType setTitle:term.name forState:UIControlStateNormal];
    self.curItemID = term.id;
    [pickerView removeFromSuperview];
    [self hidePickBgView];
    
}


- (UIPickerView *)pickView{
    
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        _pickView.center = self.view.center;
        _pickView.layer.cornerRadius = 10;
        _pickView.layer.masksToBounds = YES;
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    
    return _pickView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
