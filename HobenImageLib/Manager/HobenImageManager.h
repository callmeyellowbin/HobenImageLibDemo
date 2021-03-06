//
//  HobenImageManager.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HobenImageEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface HobenImageManager : NSObject

+ (instancetype)sharedInstance;

/**
*
 根据处理类型下载图片
 
 @param url             图片的URL地址
 @param progressBlock   包含CGFloat类型的下载进度回调
 @param completedBlock  包含UIImage类型的下载完成回调
 @param errorBlock      包含NSString类型异常信息的加载异常回调
*
**/
- (void)requestImageWithUrl:(NSString *)url
              progressBlock:(HobenImageProgressBlock)progressBlock
             completedBlock:(HobenImageCompletedBlock)completedBlock
                 errorBlock:(HobenImageErrorBlock)errorBlock;

/**
 *
 高斯模糊图片
 
 @param image           原图
 @param completeBlock   包含UIImage类型的处理完成回调
 *
 **/
- (void)processGaussianImage:(UIImage *)image
              completedBlock:(HobenImageCompletedBlock)completeBlock;

/**
 *
 水印处理图片
 
 @param image           原图
 @param text            水印文字
 @param completeBlock   包含UIImage类型的处理完成回调
 *
 **/
- (void)processWatermarkImage:(UIImage *)image
                         text:(NSString *)text
                     position:(HobenImageWatermarkPosition)position
               completedBlock:(HobenImageCompletedBlock)completeBlock;

/**
 *
 清除图片缓存
 
 @param completionBlock  清除缓存成功后的回调
 *
 **/
- (void)removeCacheWithCompletionBlock:(void (^)(void))completionBlock;

/**
 *
 预加载图片
 
 @param urlStringArray  图片的URL地址数组
 *
 **/
- (void)prefetchImageWithUrlStringArray:(NSArray <NSString *> *)urlStringArray;

/**
 *
 停止预加载图片
 
 *
 **/
- (void)cancelPrefetchingImage;

@end

NS_ASSUME_NONNULL_END
