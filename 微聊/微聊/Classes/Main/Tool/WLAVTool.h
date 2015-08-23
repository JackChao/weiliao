//
//  WLAVTool.h
//  微聊
//
//  Created by weimi on 15/8/1.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAVTool : NSObject

/** 获取当前麦克风 的声音分贝等级  0 -- 1 调用前需 调用 + (void)startRecorder:(NSString *)saveName;*/
+ (double)getCurrentMicDB;
/** 停止录音*/
+ (void)stopRecorder;
/** 开始录音 saveName 录音的存储文件名*/
+ (void)startRecorder:(NSString *)saveName;
/** 播放录音 name 录音的文件名*/
+ (void)playVoice:(NSString *)name;
/** 删除录音*/
+ (void)deleteVoice:(NSString *)name;
@end
