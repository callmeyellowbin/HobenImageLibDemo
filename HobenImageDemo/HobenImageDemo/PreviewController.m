//
//  PreviewController.m
//  HobenImageDemo
//
//  Created by 黄洪彬 on 2019/4/23.
//  Copyright © 2019 netease. All rights reserved.
//

#import "PreviewController.h"
#import <Masonry.h>

@interface PreviewController ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PreviewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.and.width.mas_equalTo(250.f);
    }];
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
    }
    return _imageView;
}

@end
