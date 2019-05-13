//
//  ViewController.m
//  HobenImageDemo
//
//  Created by 黄洪彬 on 2019/4/23.
//  Copyright © 2019 netease. All rights reserved.
//

#import "ViewController.h"
#import "CommonDefine.h"
#import "PreviewController.h"
#import <HobenImageLib/HobenImageLib.h>
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UIButton                  *commonSelectButton;

@property (nonatomic, strong) UIButton                  *gaussianSelectButton;

@property (nonatomic, strong) UIButton                  *watermarkSelectButton;

@property (nonatomic, strong) UIButton                  *prefetchButton;

@property (nonatomic, assign) HobenImageProcessType     processType;

@property (nonatomic, strong) UIButton                  *firstImageButton;

@property (nonatomic, strong) UIButton                  *secondImageButton;

@property (nonatomic, strong) UIButton                  *thirdImageButton;

@property (nonatomic, strong) UIButton                  *fourthImageButton;

@property (nonatomic, strong) NSArray <NSString *>      *urlArray;

@property (nonatomic, strong) UIProgressView            *progressView;

@property (nonatomic, strong) UILabel                   *progressLabel;

@property (nonatomic, strong) UIButton                  *removeCacheButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
}

- (void)_setup {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.processType = HobenImageProcessTypeCommon;
    
    [self.view addSubview:self.commonSelectButton];
    [self.view addSubview:self.gaussianSelectButton];
    [self.view addSubview:self.watermarkSelectButton];
    [self.view addSubview:self.prefetchButton];
    [self.view addSubview:self.firstImageButton];
    [self.view addSubview:self.secondImageButton];
    [self.view addSubview:self.thirdImageButton];
    [self.view addSubview:self.fourthImageButton];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.removeCacheButton];
    
    [@[self.commonSelectButton, self.gaussianSelectButton, self.watermarkSelectButton, self.prefetchButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5.f leadSpacing:5.f tailSpacing:5.f];
    
    [@[self.commonSelectButton, self.gaussianSelectButton, self.watermarkSelectButton, self.prefetchButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [@[self.firstImageButton, self.secondImageButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10.f leadSpacing:10.f tailSpacing:10.f];
    
    [@[self.firstImageButton, self.secondImageButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commonSelectButton.mas_bottom).offset(10.f);
        make.height.mas_equalTo(100.f);
    }];
    
    [@[self.thirdImageButton, self.fourthImageButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10.f leadSpacing:10.f tailSpacing:10.f];
    
    [@[self.thirdImageButton, self.fourthImageButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstImageButton.mas_bottom).offset(10.f);
        make.height.mas_equalTo(100.f);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.mas_equalTo(10.f);
        make.top.equalTo(self.thirdImageButton.mas_bottom).offset(20.f);
    }];
    
    [self.removeCacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40.f);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Clicked

- (void)btn_clicked:(UIButton *)button {
    if (button == self.commonSelectButton) {
        self.processType = HobenImageProcessTypeCommon;
    } else if (button == self.gaussianSelectButton) {
        self.processType = HobenImageProcessTypeGaussian;
    } else if (button == self.watermarkSelectButton) {
        self.processType = HobenImageProcessTypeWatermark;
    } else if (button == self.removeCacheButton) {
        WEAK_SELF_DECLARED
        [[HobenImageManager sharedInstance] removeCacheWithCompletionBlock:^{
            STRONG_SELF_BEGIN
            [strongSelf showAlertWithMessage:@"清除缓存成功"];
            STRONG_SELF_END
        }];
    } else if (button == self.prefetchButton) {
        button.selected = !button.selected;
        if (button.selected) {
            [self showAlertWithMessage:@"已启动预加载功能"];
            [[HobenImageManager sharedInstance] prefetchImageWithUrlStringArray:self.urlArray];
        } else {
            [self showAlertWithMessage:@"已取消预加载功能"];
            [[HobenImageManager sharedInstance] cancelPrefetchingImage];
        }
    } else {
        NSInteger index = 0;
        if (button == self.firstImageButton) {
            index = 0;
        } else if (button == self.secondImageButton) {
            index = 1;
        } else if (button == self.thirdImageButton) {
            index = 2;
        } else if (button == self.fourthImageButton) {
            index = 3;
        }
        NSString *url = [self.urlArray objectAtIndex:index];
        
        WEAK_SELF_DECLARED
        void (^progressBlock)(CGFloat progress) = ^(CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                STRONG_SELF_BEGIN
                NSLog(@"progress: %lf", progress);
                [strongSelf setProgressLabelValue:progress];
                strongSelf.progressView.progress = progress;
                STRONG_SELF_END
            });
        };
        
        void (^completedBlock)(UIImage * _Nullable image) = ^(UIImage * _Nullable image) {
            STRONG_SELF_BEGIN
            PreviewController *vc = [[PreviewController alloc] initWithImage:image];
            [strongSelf.navigationController pushViewController:vc animated:YES];
            STRONG_SELF_END
        };
        
        [[HobenImageManager sharedInstance] requestImageWithUrl:url
                                                    processType:self.processType
                                                  progressBlock:progressBlock
                                                 completedBlock:completedBlock];
        
        
    }
}

- (void)showAlertWithMessage:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:msg
                                          message:nil
                                          preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction: cancelAction];
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}

- (void)setProcessType:(HobenImageProcessType)processType {
    if (_processType == processType) {
        return;
    }
    _processType = processType;
    
    self.commonSelectButton.selected = processType == HobenImageProcessTypeCommon;
    self.gaussianSelectButton.selected = processType == HobenImageProcessTypeGaussian;
    self.watermarkSelectButton.selected = processType == HobenImageProcessTypeWatermark;
    
}

- (void)setProgressLabelValue:(CGFloat)progress {
    NSString *progressText = [NSString stringWithFormat:@"Current progress is: %d%%", (int)(progress * 100)];
    self.progressLabel.text = progressText;
    [self.progressLabel sizeToFit];
    [self.progressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.progressView.mas_bottom).offset(10.f);
    }];
}

#pragma mark - Getter

- (UIButton *)commonSelectButton {
    if (!_commonSelectButton) {
        _commonSelectButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"ratio_button_unselected"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ratio_button_selected"] forState:UIControlStateSelected];
            [button setTitle:@"普通" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button sizeToFit];
            button.selected = YES;
            button;
        });
    }
    return _commonSelectButton;
}

- (UIButton *)gaussianSelectButton {
    if (!_gaussianSelectButton) {
        _gaussianSelectButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"ratio_button_unselected"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ratio_button_selected"] forState:UIControlStateSelected];
            [button setTitle:@"高斯模糊" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button sizeToFit];
            button;
        });
    }
    return _gaussianSelectButton;
}

- (UIButton *)watermarkSelectButton {
    if (!_watermarkSelectButton) {
        _watermarkSelectButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"ratio_button_unselected"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ratio_button_selected"] forState:UIControlStateSelected];
            [button setTitle:@"水印" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button sizeToFit];
            button;
        });
    }
    return _watermarkSelectButton;
}

- (UIButton *)prefetchButton {
    if (!_prefetchButton) {
        _prefetchButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"ratio_button_unselected"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ratio_button_selected"] forState:UIControlStateSelected];
            [button setTitle:@"预加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button sizeToFit];
            button;
        });
    }
    return _prefetchButton;
}

- (UIButton *)firstImageButton {
    if (!_firstImageButton) {
        _firstImageButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"image_first"] forState:UIControlStateNormal];
            button;
        });
    }
    return _firstImageButton;
}

- (UIButton *)secondImageButton {
    if (!_secondImageButton) {
        _secondImageButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"image_second"] forState:UIControlStateNormal];
            button;
        });
    }
    return _secondImageButton;
}

- (UIButton *)thirdImageButton {
    if (!_thirdImageButton) {
        _thirdImageButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"image_third"] forState:UIControlStateNormal];
            button;
        });
    }
    return _thirdImageButton;
}

- (UIButton *)fourthImageButton {
    if (!_fourthImageButton) {
        _fourthImageButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"image_fourth"] forState:UIControlStateNormal];
            button;
        });
    }
    return _fourthImageButton;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = ({
            UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.trackTintColor = [UIColor redColor];
            progressView.progressTintColor = [UIColor greenColor];
            progressView;
        });
    }
    return _progressView;
}

- (NSArray<NSString *> *)urlArray {
    if (!_urlArray) {
        _urlArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555482918200&di=640aaa94a3c471ab3db74246b8ec72d1&imgtype=0&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20140822%2Fmusejingsefengjing_2939709.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555482973386&di=1a238747922e3b2eac2617b00c7f8c27&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ftg%2F369%2F480%2F749%2Ffb6e6b1f88154a838a9197531ac1deb9.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555483035418&di=fe52ca9b966ce8793162bdf39f69454a&imgtype=0&src=http%3A%2F%2Fpic60.nipic.com%2Ffile%2F20150226%2F9448607_111924718001_2.jpg", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555483105228&di=f2590f84997a6c6fbdaf0634c9d85fc5&imgtype=0&src=http%3A%2F%2Fpic41.nipic.com%2F20140601%2F18681759_143805185000_2.jpg"];
    }
    return _urlArray;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15.f];
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _progressLabel;
}

- (UIButton *)removeCacheButton {
    if (!_removeCacheButton) {
        _removeCacheButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"清除缓存" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [button sizeToFit];
            button;
        });
    }
    return _removeCacheButton;
}

@end
