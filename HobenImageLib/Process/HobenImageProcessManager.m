//
//  HobenImageProcessManager.m
//  HobenImageLib
//
//  Created by 黄洪彬 on 2019/4/18.
//  Copyright © 2019 netease. All rights reserved.
//

#import "HobenImageProcessManager.h"
#import <Accelerate/Accelerate.h>

@implementation HobenImageProcessManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HobenImageProcessManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)processGaussianImage:(UIImage *)image
              completedBlock:(void (^)(UIImage * _Nullable image))completeBlock {
    CGFloat blur = 0.5f;
    int boxSize = (int)(blur * 40);
    
    // 确保为奇数
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imageRef = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    // 从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    // 设置从CGImage获取对象的属性
    pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) * CGImageGetHeight(imageRef));
    
    outBuffer.width = inBuffer.width = CGImageGetWidth(imageRef);
    outBuffer.height = inBuffer.height = CGImageGetHeight(imageRef);
    outBuffer.rowBytes = inBuffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    outBuffer.data = pixelBuffer;
    
    // 均值模糊
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"Error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, CGImageGetBitmapInfo(imageRef));
    CGImageRef resultImageRef = CGBitmapContextCreateImage(context);
    UIImage *resultImage = [UIImage imageWithCGImage:resultImageRef];
    
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(resultImageRef);
    
    if (completeBlock) {
        completeBlock(resultImage);
    }
}

- (void)processWatermarkImage:(UIImage *)image
                         text:(NSString *)text
                     position:(HobenImageWatermarkPosition)position
               completedBlock:(HobenImageCompletedBlock)completeBlock {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIFont *font = [UIFont boldSystemFontOfSize:image.size.height / 10];
    
    NSDictionary *dictionary = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: font};
    
    CGFloat watermarkX = 0.f;
    CGFloat watermarkY = 0.f;
    
    CGFloat fontSize = font.pointSize * 4;
    CGFloat fontHeight = font.pointSize;
    
    switch (position) {
        case HobenImageWatermarkPositionUpLeft: {
            watermarkX = 0.f;
            watermarkY = 0.f;
        }
            break;
        case HobenImageWatermarkPositionUpRight: {
            watermarkX = image.size.width - fontSize;
            watermarkY = 0.f;
        }
            break;
        case HobenImageWatermarkPositionCenter: {
            watermarkX = image.size.width / 2 - fontSize / 2;
            watermarkY = image.size.height / 2 - fontHeight / 2;
        }
            break;
        case HobenImageWatermarkPositionDownLeft: {
            watermarkX = 0.f;
            watermarkY = image.size.height - fontHeight;
        }
            break;
        case HobenImageWatermarkPositionDownRight: {
            watermarkX = image.size.width - fontSize;
            watermarkY = image.size.height - fontHeight;
        }
            break;
            
    }
    
    [text drawAtPoint:CGPointMake(watermarkX, watermarkY) withAttributes:dictionary];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (completeBlock) {
        completeBlock(resultImage);
    }
}

@end
