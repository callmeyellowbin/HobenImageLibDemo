//
//  HobenImageProcessManager.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HobenImageProcessManager : NSObject

+ (instancetype)sharedInstance;

- (void)processGaussianImage:(UIImage *)image
              completedBlock:(HobenImageCompletedBlock)completeBlock;

- (void)processWatermarkImage:(UIImage *)image
                         text:(NSString *)text
                     position:(HobenImageWatermarkPosition)position
               completedBlock:(HobenImageCompletedBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
