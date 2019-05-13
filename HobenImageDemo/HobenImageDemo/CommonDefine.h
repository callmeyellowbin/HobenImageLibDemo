//
//  CommonDefine.h
//  HobenImageDemo
//
//  Created by 黄洪彬 on 2019/4/23.
//  Copyright © 2019 netease. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define WEAK_SELF_DECLARED              __typeof(&*self) __weak weakSelf = self;

#define STRONG_SELF_BEGIN               __typeof(&*weakSelf) strongSelf = weakSelf; \
if (strongSelf) {

#define STRONG_SELF_END                 }

#endif /* CommonDefine_h */
