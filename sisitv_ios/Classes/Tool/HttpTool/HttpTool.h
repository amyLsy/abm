//
//  HttpTool.h
//  Zhibo
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpRequsetUrlFlag) {
    //接口地址：http://show.deerlive.com/Api/SiSi/
   
    
    
    /**
     *登录
     */
    HttpRequsetUrlFlagLogin = 1,
    /**
     *第三方登录
     */
    HttpRequsetUrlFlagSendOauthUserInfo ,
    /**
     *注册
     */
    HttpRequsetUrlFlagRegeist ,
    /**
     *获取手机验证码
     */
    HttpRequsetUrlFlagGet_Phone_Varcode ,
    /**
     *检查验证码是否正确
     */
    HttpRequsetUrlFlagCheck_Varcode ,
    /**
     *修改密码
     */
    HttpRequsetUrlFlagChangePassword ,
    /**
     *忘记密码，密码重置
     */
    HttpRequsetUrlFlagRetrievePassword ,
    /**
     *添加关注
     */
    HttpRequsetUrlFlagAddAttention ,
    /**
     *取消关注
     */
    HttpRequsetUrlFlagCancelAttention ,
    /**
     *赞
     */
    HttpRequsetUrlFlagAdd_like ,
    /**
     *首页获取直播列表
     */
    HttpRequsetUrlFlagGetLive ,
    /**
     *判断直播间密码
     */
    HttpRequsetUrlFlagCheckRoomPassword,
    /**
     *首页获取关注列表
     */
    HttpRequsetUrlFlagGetAttentionLiveList,
    /**
     *进入直播间,根据房间id获取房间信息
     */
    HttpRequsetUrlFlagEnterLiveRoom,
    /**
     *获取直播间观众列表
     */
    HttpRequsetUrlFlagGetLiveRoomOnlineUserList,
    /**
     *退出直播间
     */
    HttpRequsetUrlFlagExitLiveRoom,
    /**
     *修改自己的个人资料
     */
    HttpRequsetUrlFlagChangeUserInfo ,
    /**
     *搜索
     */
    HttpRequsetUrlFlagSearchUsers ,
    /**
     *实时更新直播间在线人数和收入（APP设定5-10s请求一次）
     */
    HttpRequsetUrlFlagGetLiveRoomOnlineNumEarn ,
    /**
     *开始直播
     */
    HttpRequsetUrlFlagStartLive,
    /**
     *开始直播成功回调
     */
    HttpRequsetUrlFlagStartLivePushCallback,
    /**
     *结束直播
     */
    HttpRequsetUrlFlagStopLive,
    /**
     *赠送礼物
     */
    HttpRequsetUrlFlagSendGiftToAnchor,
    /**
     *举报主播
     */
    HttpRequsetUrlFlagSendReport,
    /**
     *禁言
     */
    HttpRequsetUrlFlagForbiddenSpeak,
    /**
     *主播设置房管
     */
    HttpRequsetUrlFlagSetLiveGuard,
    /**
     *主播取消房管
     */
    HttpRequsetUrlFlagCancelLiveGuard,
    /**
     *房管列表
     */
    HttpRequsetUrlFlagGetGuardList,
    /**
     *获取分享信息
     */
    HttpRequsetUrlFlagGetShareInfo,
    /**
     *支付套餐
     */
    HttpRequsetUrlFlagGet_recharge_package,
    /**
     *获取微信支付参数
     */
    HttpRequsetUrlFlagBegin_wxpay,
    /**
     *获取支付宝支付参数
     */
    HttpRequsetUrlFlagBegin_alipay,
    /**
     *验证苹果内购支付账单证书
     */
    HttpRequsetUrlFlagBegin_applepay,
    /**
     *获取支付方式
     */
    HttpRequsetUrlFlagCheck_pay,
    /**
     *绑定手机号
     */
    HttpRequsetUrlFlagBindingMobile,
    /**
     *发送弹幕
     */
    HttpRequsetUrlFlagSendDanmuToAnchor,
    /**
     *APP超管相关
     */
    HttpRequsetUrlFlagAdvancedManage,
    //818添加by hao big a fish..........
    /**
     *用token修改个人资料
     */
    HttpRequsetUrlFlagwChangeUserInfo ,
    /**
     *用token反馈信息
     */
    HttpRequsetUrlFlagwChangeFeedback,
    /**
     *修改密码
     */
    HttpRequsetUrlFlagwChangePassWord,
    /**
     *查看用户关注列表
     */
    HttpRequsetUrlFlagwGetUserAttentionList,
    /**
     *查看用户粉丝列表
     */
    HttpRequsetUrlFlagwGetUserFansList,
    /**
     *我的发布
     */
    HttpRequsetUrlFlagwGetMyLiveRecordList,
    /**
     *获取活动按钮
     */
    HttpRequsetUrlFlagGetActivityinfo,
    /**
     *搜索音乐
     */
    HttpRequsetUrlFlagSearchSong,
    /**
     *搜索音乐
     */
    HttpRequsetUrlFlagSearchSongLyric,
    /**
     *主播获取问题分类列表
     */
    HttpRequsetUrlFlagGetQuestionsTermList,
    /**
     *主播开始竞猜
     */
    HttpRequsetUrlFlagStartMatch,
    /**
     *主播按类型抽题集
     */
    HttpRequsetUrlFlagGetMatchQuestionList,
    /**
     *观众回答题目
     */
    HttpRequsetUrlFlagReplyQuestion,
    /**
     *观众加入竞技
     */
    HttpRequsetUrlFlagJoinMatch,
    /**
     *获取本轮游戏结果
     */
    HttpRequsetUrlFlagFinishReplyQuest,
    /**
     *观众获取当前竞猜题集
     */
    HttpRequsetUrlFlagVistGetMatchQuestionList,
    /**
     *观众押注
     */
    HttpRequsetUrlFlagStake,
    /**
     *改竞猜状态为进行中
     */
    HttpRequsetUrlFlagConvToOngoingStatus,
    /**
     *获取参赛扣费金额列表（适用于极速玩法与猜歌名）
     */
    HttpRequsetUrlFlagGetMatchPrice,
    /**
     * 用户提交答案填空题
     */
    HttpRequsetUrlFlagUserBlanks,
    /**
     * 用户提交答案填空题
     */
    HttpRequsetUrlFlagUserExcludePrice,
    /**
     * 用户提交答案填空题
     */
    HttpRequsetUrlFlagUserExcludeanswer
    ,
    /**
     * 用户上传图片
     */
    HttpRequsetUrlFlagUserUpload,
    /**
     * 获取上传视频、图片凭证与地址
     */
    HttpRequsetUrlFlagGetUploadInfo,
    /**
     * 用户点赞
     */
    HttpRequsetUrlFlagUserlike,
    /**
     * 获取sts授权
     */
    HttpRequsetUrlFlagGetSts ,
    /**
     * 用户评论
     */
    HttpRequsetUrlFlagComment ,
    /**
     *获取小视频图片
     */
    HttpRequsetUrlFlagGetviews ,
    //获取评论数据
    HttpRequsetUrlFlagGetComments,
    //添加节目
    HttpRequsetUrlFlagAddShow,
    //
    HttpRequsetUrlFlagShowStatus,
//    主播修改节目列表
    HttpRequsetUrlFlagUserhowEdit,
    //    主播修改节目列表
    HttpRequsetUrlFlagUserGetBgmTerms
    ,
    //    获取背景音乐列表
    HttpRequsetUrlFlagUserGetGgmList,
    //    获取表演的节目列表
    HttpRequsetUrlFlagOrderhowList,
    //getUerShow
    HttpRequsetUrlFlagGetUserShow,
    //观众点节目
    HttpRequsetUrlFlagDoOrderOshow,
    /**
     *获取主播状态
     */
    HttpRequsetUrlFlagGetShowStatus,
    /**
     *主播休息开关
     */
    HttpRequsetUrlFlagShowSwitch,
    /**
     * 查看个人用户资料
     */
    HttpRequsetUrlFlagGetUserInfo,
    /**
     * 用户分享统计
     */
    HttpRequsetUrlFlagShare,
    /**
     * 用户分享统计
     */
    HttpRequsetUrlFlagDoShow,
    /**
     * 用户分享统计
     */
    HttpRequsetUrlFlagUploadDelete,
    /**
     * 用户分享统计
     */
    HttpRequsetUrlFlagGetGuideMsg,
    /**
     * 获取评论的评论列表
     */
    HttpRequsetUrlFlagGetSubComments,
    /**
     * 获取上传视频、图片分类
     */
    HttpRequsetUrlFlagGetUploadTerms,
    /**
     * 点击量增加
     */
    HttpRequsetUrlFlagAddhits,
    
    /**
     * 更新用户位置
     */
    HttpRequsetUrlFlagSetLocation,
    /**
     * 修改用户的背景图片
     */
    HttpRequsetUrlFlagwChangeUserBackground,
    /**
     *  isJoinMatch
     */
    HttpRequsetUrlFlagIsJoinMatch,
    /**
     *  IsStartMatch
     */
    HttpRequsetUrlFlagIsStartMatch,
    /**
     *  检查节目是否已经处理
     */
    HttpRequsetUrlFlagCheckShowOrder,
    /*
     *  当前剩余的答题次数无用的暂时先不删除了
     */
    HttpRequsetUrlFlagCanerrortimes,
    /*
     *  当前剩余的答题次数无用的暂时先不删除了
     */
    HttpRequsetUrlFlagGetSensitiveWords,
    /*
     *  兑换活力
     */
    HttpRequsetUrlFlagPresentExchange,
    /*
     *  兑换活力
     */
    HttpRequsetUrlFlagGetPresentAreaList,
    /*
     *  根据ID获取礼物列表
     */
    HttpRequsetUrlFlagGetPresentAreaByid
    
    
};



@interface HttpTool : NSObject

+(void)requestWithUrlFlag:(HttpRequsetUrlFlag )flag param:(NSMutableDictionary *)param success:(void(^)(id responseObject))success faile:(void(^)(void))faile;
 
+(void)uploadImage:(UIImage *)image withUrlFlag:(HttpRequsetUrlFlag)flag param:(NSMutableDictionary *)param success:(void (^)(id responseObject))success;


/**
 下载音乐

 @param urlString url地址
 @param destinationPath 存储的位置
 @param progress 进度
 @param completion completion
 */
+(void)downLoadMusicWithUrl:(NSString *)urlString toPath:(NSString *)destinationPath downloadProgress:(void (^)(CGFloat))progress completion:(void (^)(BOOL isSuccess,id result))completion;

@end
