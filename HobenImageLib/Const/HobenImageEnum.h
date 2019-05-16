//
//  HobenImageEnum.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/17.
//  Copyright © 2019 netease. All rights reserved.
//

#ifndef HobenImageEnum_h
#define HobenImageEnum_h

typedef NS_ENUM(NSUInteger, HobenImageWatermarkPosition) {
    HobenImageWatermarkPositionUpLeft = 0,          // 左上
    HobenImageWatermarkPositionUpRight,             // 右上
    HobenImageWatermarkPositionCenter,              // 中间
    HobenImageWatermarkPositionDownLeft,            // 左下
    HobenImageWatermarkPositionDownRight,           // 右下
};

typedef void (^HobenImageCompletedBlock)(UIImage * _Nullable image);

typedef void (^HobenImageProgressBlock)(CGFloat progress);

typedef void (^HobenImageErrorBlock)(NSString * _Nullable errorDesc);

#endif /* HobenImageEnum_h */
