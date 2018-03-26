//
//  ShowControlUtilits.h
//  sisitv_ios
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 JLXX--YZG. All rights reserved.
//

#ifndef ShowControlUtilits_h
#define ShowControlUtilits_h


/**
 *  消息类型的key
 */
/*!
 * @abstract  推流状态
 */
typedef NS_ENUM(NSUInteger, YZGStreamState) {
    /// 初始化时状态为空闲
    YZGStreamStateIdle = 0,
    /// 连接中
    YZGStreamStateConnecting,
    /// 已连接
    YZGStreamStateConnected,
    /// 断开连接中
    YZGStreamStateDisconnecting,
    /// 推流出错
    YZGStreamStateError,
};

/*!
 * @abstract  连麦状态
 */
typedef NS_ENUM(NSUInteger, YZGLianMaiState) {
    /// 开始连麦
    YZGLianMaiStartCall = 0,
    /// 有人请求连麦
    YZGLianMaiStateHadCallComing,
    /// 已连接
    YZGLianMaiStateConnected,
    /// 断开连麦
    YZGLianMaiStateDisconnected,
    /// 接受连麦
    YZGLianMaiStateAnswerCall,
    /// 拒绝连麦
    YZGLianMaiStateRejectCall,
    /// 停止连麦
    YZGLianMaiStateStopCall,
    /// 连麦出错
    YZGLianMaiStateError,
    /// 连麦服务注册成功
    YZGLianMaiStateRegeistSuccess,
    /// 连麦服务注册失败
    YZGLianMaiStateRegeistError,
    /// 对方无应答
    YZGLianMaiStateNoResponder,
    /// 自己不应答((观众)不接受也不拒绝)
    YZGLianMaiStateSelfNoResponder,
};


/*!
 * @abstract  音频播放状态
 */
typedef NS_ENUM(NSUInteger, YZGBgmState) {
    /// 初始状态
    YZGBgmStateInit,
    /// 背景音正在播放
    YZGBgmStateStarting,
    /// 背景音停止
    YZGBgmStateStopped,
    /// 背景音正在播放
    YZGBgmStatePlaying,
    /// 背景音暂停
    YZGBgmStatePaused,
    /// 背景音播放出错
    YZGBgmStateError,
    /// 背景音被打断
    YZGBgmStateInterrupted
};


/*!
 * @abstract  摄像头各种状态
 */
typedef NS_ENUM(NSUInteger, YZGCameraState) {
    /// 前置摄像头
    YZGFrontCamera = 0,
    /// 后置摄像头
    YZGRearCamera,
    /// 美颜开
    YZGBeautyCamera,
    /// 美颜关
    YZGNormalCamera,
    /// 闪光灯开
    YZGTorchOnCamera,
    /// 闪光灯关
    YZGTorchOffCamera,
    /// 摄像头切换中
    YZGCameraSwitching
};

FOUNDATION_EXPORT NSString *const YZGLianMaiStateChange;

FOUNDATION_EXPORT NSString *const YZGLianMaiStateKey;

FOUNDATION_EXPORT NSString *const YZGBgmPlayStateChange;

FOUNDATION_EXPORT NSString *const YZGBgmPlayStateKey ;
/**
 CameraStateNotification
 */
static NSString *const YZGCameraStateChangeNotification = @"YZGCameraStateNotification";
/**
 YZGCameraStateChangeKey
 */
static NSString *const YZGCameraStateChangeKey = @"YZGCameraStateChangeKey";

#endif /* ShowControlUtilits_h */
