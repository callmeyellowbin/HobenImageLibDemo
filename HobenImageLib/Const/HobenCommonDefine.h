//
//  HobenCommonDefine.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#ifndef HobenCommonDefine_h
#define HobenCommonDefine_h

#define WEAK_SELF_DECLARED              __typeof(&*self) __weak weakSelf = self;

#define STRONG_SELF_BEGIN               __typeof(&*weakSelf) strongSelf = weakSelf; \
if (strongSelf) {

#define STRONG_SELF_END                 }

#endif /* HobenCommonDefine_h */
