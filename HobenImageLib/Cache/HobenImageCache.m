//
//  HobenImageCache.m
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import "HobenImageCache.h"
#import <SDWebImagePrefetcher.h>
#import <SDImageCache.h>
#import <UIImageView+WebCache.h>

@interface HobenImageCache ()

@property (nonatomic, strong) NSMutableArray *requestList;

@property (nonatomic, strong) NSMutableArray *prefetchingList;

@end

@implementation HobenImageCache

+ (instancetype)sharedInstance {
    static dispatch_once_t oncePredicate;
    static HobenImageCache *sharedInstance = nil;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initInstance];
    });
    return sharedInstance;
}

- (instancetype)initInstance {
    if (self = [super init]) {
        self.requestList = [NSMutableArray array];
    }
    return self;
}

- (void)requestImageWithUrl:(NSString *)url
              progressBlock:(HobenImageProgressBlock)progressBlock
             completedBlock:(HobenImageCompletedBlock)completedBlock {
    UIImage *image = [self _imageWithUrl:url];
    if (image) {
        if (progressBlock) {
            progressBlock(1.f);
        }
        if (completedBlock) {
            completedBlock(image);
        }
    } else {
        [self _loadImageWithUrl:url progressBlock:progressBlock completedBlock:completedBlock];
    }
}

- (UIImage *)_imageWithUrl:(NSString *)url {
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:url];
}

- (void)_loadImageWithUrl:(NSString *)url
            progressBlock:(HobenImageProgressBlock)progreeBlock
           completedBlock:(HobenImageCompletedBlock)completedBlock {
    if ([self.requestList containsObject:url]) {
        return;
    }
    [self.requestList addObject:url];
    [self _requestImageWithUrl:url progressBlock:progreeBlock completedBlock:completedBlock];
}

- (void)_requestImageWithUrl:(NSString *)url
               progressBlock:(HobenImageProgressBlock)progreeBlock
              completedBlock:(HobenImageCompletedBlock)completedBlock {
    WEAK_SELF_DECLARED
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = receivedSize * 1.f / expectedSize;
        if (progreeBlock) {
            progreeBlock(progress);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        STRONG_SELF_BEGIN
        if (image) {
            [strongSelf.requestList removeObject:url];
            if (completedBlock) {
                completedBlock(image);
            }
        } else {
            NSLog(@"Cache ERROR in URL:%@", url);
            [strongSelf.requestList removeObject:url];
            if (completedBlock) {
                completedBlock(nil);
            }
        }
        STRONG_SELF_END
    }];
}


- (void)removeCacheWithCompletionBlock:(void (^)(void))completionBlock {
    [self.requestList removeAllObjects];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completionBlock];
}

- (void)prefetchImageWithUrlStringArray:(NSArray <NSString *> *)urlStringArray {
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:urlStringArray.count];
    for (NSString *urlString in urlStringArray) {
        [urlArray addObject:[NSURL URLWithString:urlString]];
    }
    self.prefetchingList = [NSMutableArray arrayWithArray:urlStringArray];
    [self.requestList addObjectsFromArray:urlStringArray];
    WEAK_SELF_DECLARED
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urlArray progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        STRONG_SELF_BEGIN
        [strongSelf.requestList removeObjectsInArray:urlStringArray];
        [strongSelf.prefetchingList removeAllObjects];
        STRONG_SELF_END
    }];
}

- (void)cancelPrefetchingImage {
    [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
    [self.requestList removeObjectsInArray:self.prefetchingList];
    [self.prefetchingList removeAllObjects];
}

@end
