//
//  HMShareService.m
//  HiloApp
//
//  Created by wdhy on 2017/9/28.
//  Copyright © 2017年 Happy Time Technology. All rights reserved.
//

#import "HMShareService.h"
static HMShareService *shareService;
@implementation HMShareService

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareService = [[HMShareService alloc] init];
    });
    return shareService;
}

-(BOOL)shareToWXType:(WX_SHARE_TYPE)shareType image:(UIImage *)image{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *mediaMsg = [WXMediaMessage message];
        WXImageObject *imgObj = [WXImageObject object];
        imgObj.imageData = UIImagePNGRepresentation(image);
        mediaMsg.mediaObject = imgObj;
        
        [mediaMsg setThumbImage:image];
        mediaMsg.title = @"直播美——主播陪你high翻天";
        mediaMsg.description = @"春风十里不如在直播美陪你，美女、兄弟、游戏，怎能没有你。";
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = mediaMsg;
        req.bText = NO;
        req.scene = shareType;
        [WXApi sendReq:req];
        return YES;
    }else{
        
        return NO;
    }
}



-(BOOL)shareToWXType:(WX_SHARE_TYPE)shareType headUrl:(NSString *)headUrl{
    NSData *ImgUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headUrl]];
    if (ImgUrlData.length/1000 > 32) {
        UIImage *orgialImg = [UIImage imageWithData:ImgUrlData];
        ImgUrlData = UIImageJPEGRepresentation(orgialImg, 0.1);
    }
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //message是多媒体分享(链接/网页/图片/音乐各种)
        //text是分享文本,两者只能选其一
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"直播美——主播陪你high翻天";
        message.description = @"春风十里不如在直播美陪你，美女、兄弟、游戏，怎能没有你。";
        [message setThumbImage:[UIImage imageWithData:ImgUrlData]];
        
        req.message = message;
        WXWebpageObject *ext = [WXWebpageObject object];
//        ext.webpageUrl = [SecurityModel().config.shareurl stringWithUTF8Encoding];
        ext.webpageUrl = @"";
        message.mediaObject = ext;
        //默认是Session分享给朋友,Timeline是朋友圈,Favorite是收藏
        req.scene = shareType;
        [WXApi sendReq:req];
        return YES;
    } else {
//        [UIView addAlertView:@"没有安装微信不能分享哦" tipsType:TipsTypeJG];
        //BUG 279 modify by lushuyuan 2017/09/28
        NSString  *str = [WXApi getWXAppInstallUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return NO;
    }
}


-(BOOL)shareToQQType:(QQ_SHARE_TYPE)shareType image:(UIImage *)image{

    if ([QQApiInterface isQQInstalled]) {
        NSData *data = UIImagePNGRepresentation(image);
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:data
                                                   previewImageData:data
                                                              title:@"直播美——主播陪你high翻天"
                                                        description:@"春风十里不如在直播美陪你，美女、兄弟、游戏，怎能没有你。"];
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = EQQAPISENDSUCESS;
        if (shareType == QQ_SHARE_FRIENDS_TYPE) {
            sent = [QQApiInterface sendReq:req];
        }
        if (shareType == QQ_SHARE_KONGJIAN_TYPE) {
            sent = [QQApiInterface SendReqToQZone:req];
        }
        return sent == EQQAPISENDSUCESS ? YES : NO;
    }else{
//        [UIView addAlertView:@"没有安装QQ不能分享哦" tipsType:TipsTypeJG];
        //BUG 279 modify by lushuyuan 2017/09/28
        NSString  *str = [QQApiInterface getQQInstallUrl];;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return NO;
    }
}

-(BOOL)shareToQQType:(QQ_SHARE_TYPE)shareType headUrl:(NSString *)headUrl{
    
    if ([QQApiInterface isQQInstalled]) {
        NSData *ImgUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headUrl]];
//        NSURL *shareUrl = [NSURL URLWithString:[SecurityModel().config.shareurl stringWithUTF8Encoding]];
        
        QQApiNewsObject *msgObject = [QQApiNewsObject objectWithURL:nil title:@"直播美——主播陪你high翻天" description:@"春风十里不如在直播美陪你，美女、兄弟、游戏，怎能没有你。" previewImageData:ImgUrlData];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:msgObject];
        QQApiSendResultCode sent = EQQAPISENDSUCESS;
        if (shareType == QQ_SHARE_FRIENDS_TYPE) {
            sent = [QQApiInterface sendReq:req];
        }
        if (shareType == QQ_SHARE_KONGJIAN_TYPE) {
            sent = [QQApiInterface SendReqToQZone:req];
        }
        return sent == EQQAPISENDSUCESS ? YES : NO;
    }else{
//        [UIView addAlertView:@"没有安装QQ不能分享哦" tipsType:TipsTypeJG];
        //BUG 279 modify by lushuyuan 2017/09/28
        NSString  *str = [QQApiInterface getQQInstallUrl];;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return NO;
    }
    
}

#pragma mark - QQ分享回调
-(void)onResp:(QQBaseResp *)resp{
    NSLog(@"resp.errorDescription:%@",resp.errorDescription);
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
        if (resp.errorDescription.length == 0) {
//            [UIView addAlertView:@"QQ分享成功!" tipsType:TipsTypeSucess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self notifyRoomShareMsg];
            });
//            [self performSelector:@selector(notifyRoomShareMsg) withObject:nil afterDelay:1.0];
        }else{
//            [UIView addAlertView:@"分享失败!" tipsType:TipsTypeError];
        }
    }
}



-(void)notifyRoomShareMsg{
    
}

@end
