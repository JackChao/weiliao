//
//  WLAVTool.m
//  微聊
//
//  Created by weimi on 15/8/1.
//  Copyright (c) 2015年 weimi. All rights reserved.
//

#import "WLAVTool.h"
#import <AVFoundation/AVFoundation.h>
static AVAudioRecorder *_recorder = nil;
static AVAudioPlayer *_player = nil;
@implementation WLAVTool
/** 开始录音 saveName 录音的存储文件名*/
+ (void)startRecorder:(NSString *)saveName {
    if (saveName == nil || saveName.length == 0) {
        saveName = @"null";
    }
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    /* 保存录音文件 路径 */
    
    NSURL *url = [NSURL fileURLWithPath:[self voicePathWithName:saveName]];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat: 44100.0], AVSampleRateKey,                [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,[NSNumber numberWithInt: 2], AVNumberOfChannelsKey,                [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,nil];
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (_recorder) {
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
    } else {
        NSLog(@"%@", [error description]);
    }
}
/** 停止录音*/
+ (void)stopRecorder {
    if (_recorder != nil) {
        [_recorder stop];
        _recorder = nil;
    }
}
/** 获取当前麦克风 的声音分贝等级  0 -- 1 */
+ (double)getCurrentMicDB {
    if (_recorder == nil) {
        NSLog(@"没有开始录音, 请先调用 startRecorder:");
        return 0;
    }
    [_recorder updateMeters];
    float level;
    // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f;
    // Or use -60dB, which I measured in a silent room.
    float   decibels    = [_recorder averagePowerForChannel:0];
    if (decibels < minDecibels) {
        level = 0.0f;
    } else if (decibels >= 0.0f) {
        level = 1.0f;
    } else {
        float root = 2.0f;
        float minAmp = powf(10.0f, 0.05f * minDecibels);
        float inverseAmpRange = 1.0f / (1.0f - minAmp);
        float amp  = powf(10.0f, 0.05f * decibels);
        float adjAmp = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
    }
    return level;
}
/** 播放录音 name 录音的文件名*/
+ (void)playVoice:(NSString *)name {
    NSError *playerError;
    //播放
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[self voicePathWithName:name]] error:&playerError];
    
    if (_player == nil)
    {
        NSLog(@"发生错误: %@", [playerError description]);
    }else{
        [_player play];
    }
}

+ (NSString *)voicePathWithName:(NSString *)name {
    //doc 目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString*fullPath = [path stringByAppendingPathComponent:@"voice"];
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL exists = [mgr fileExistsAtPath:fullPath isDirectory:&isDir];
    //如果目录不存在  创建目录
    if (!isDir || !exists) {
        [mgr createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *voicePath = [fullPath stringByAppendingPathComponent:name];
    return voicePath;
}
/** 删除录音*/
+ (void)deleteVoice:(NSString *)name {
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *path = [self voicePathWithName:name];
    BOOL isDir = false;
    BOOL exists = [mgr fileExistsAtPath:path isDirectory:&isDir];
    if (exists && !isDir) {
        [mgr removeItemAtPath:path error:nil];
    }
}

@end
