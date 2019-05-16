//
//  HobenImageCache.h
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HobenImageCache : NSObject

+ (instancetype)sharedInstance;

- (void)requestImageWithUrl:(NSString *)url
              progressBlock:(HobenImageProgressBlock)progressBlock
             completedBlock:(HobenImageCompletedBlock)completedBlock
                 errorBlock:(HobenImageErrorBlock)errorBlock;

- (void)removeCacheWithCompletionBlock:(void (^)(void))completionBlock;

- (void)prefetchImageWithUrlStringArray:(NSArray <NSString *> *)urlStringArray;

- (void)cancelPrefetchingImage;

@end

NS_ASSUME_NONNULL_END
