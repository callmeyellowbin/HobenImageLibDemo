//
//  HobenImageManager.m
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import "HobenImageManager.h"
#import "HobenImageCache.h"
#import "HobenImageProcessManager.h"

@implementation HobenImageManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HobenImageManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)requestImageWithUrl:(NSString *)url
                processType:(HobenImageProcessType)processType
              progressBlock:(HobenImageProgressBlock)progressBlock
             completedBlock:(HobenImageCompletedBlock)completedBlock {
    [[HobenImageCache sharedInstance] requestImageWithUrl:url progressBlock:progressBlock completedBlock:^(UIImage * _Nullable image) {
        [[HobenImageProcessManager sharedInstance] processImage:image processType:processType completedBlock:completedBlock];
    }];
}

- (void)removeCacheWithCompletionBlock:(void (^)(void))completionBlock {
    [[HobenImageCache sharedInstance] removeCacheWithCompletionBlock:completionBlock];
}

- (void)prefetchImageWithUrlStringArray:(NSArray <NSString *> *)urlStringArray {
    [[HobenImageCache sharedInstance] prefetchImageWithUrlStringArray:urlStringArray];
}

- (void)cancelPrefetchingImage {
    [[HobenImageCache sharedInstance] cancelPrefetchingImage];
}

@end
