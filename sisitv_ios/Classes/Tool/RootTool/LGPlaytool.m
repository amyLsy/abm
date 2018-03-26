//
//  LGPlaytool.m
//  sisitv_ios
//
//  Created by Ming on 2018/1/3.
//  Copyright © 2018年 JLXX--YZG. All rights reserved.
//

#import "LGPlaytool.h"
#import "AlertTool.h"

@implementation LGPlaytool


- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            [AlertTool Hidden];
            
            //播放视频首帧显示出来时触发
            
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            break;
        case AliyunVodPlayerEventFirstFrame:
            
            
            break;
        case AliyunVodPlayerEventPause:
            
            //视频暂停时触发
            break;
        case AliyunVodPlayerEventStop:
            
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            break;
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            break;
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            break;
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            break;
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(ALPlayerVideoErrorModel *)errorModel;{
    
    [AlertTool Hidden];
}


- (void)prepareUrl:(NSString *)url{
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.aliPlayer prepareWithURL:[NSURL URLWithString:url]];
    });
}




- (void)startPlay{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.aliPlayer start];
       
    });
    
}

- (void)pausePlay{
    [self.aliPlayer pause];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}

- (void)stopPlay{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.aliPlayer stop];
    });
}

- (void)releasePlayer{
    [self.aliPlayer releasePlayer];
   
}




-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        //        _aliPlayer.displayMode = AliyunVodPlayerDisplayModeFitWithCropping;
        //        });
    }
    return _aliPlayer;
}






@end
