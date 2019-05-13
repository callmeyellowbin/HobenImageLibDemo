//
//  HobenImageEnum.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/17.
//  Copyright © 2019 netease. All rights reserved.
//

#ifndef HobenImageEnum_h
#define HobenImageEnum_h

typedef NS_ENUM(NSUInteger, HobenImageProcessType) {
    HobenImageProcessTypeCommon = 0,        // 不处理
    HobenImageProcessTypeGaussian,          // 高斯模糊
    HobenImageProcessTypeWatermark,         // 水印
};

typedef void (^HobenImageCompletedBlock)(UIImage * _Nullable image);

typedef void (^HobenImageProgressBlock)(CGFloat progress);

#endif /* HobenImageEnum_h */
