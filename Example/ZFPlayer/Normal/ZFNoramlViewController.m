//
//  ZFNoramlViewController.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/3/21.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFNoramlViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface ZFNoramlViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation ZFNoramlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (IBAction)changeVideo:(UIButton *)sender {
    NSString *URLString = [@"https://ylmtst.yejingying.com/asset/video/20180525184959_mW8WVQVd.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:proxyURLString];
}

- (IBAction)playClick:(UIButton *)sender {
    [self.controlView resetControlView];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.shouldAutoPlay = YES;
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager];
    self.player.controlView = self.controlView;
    self.player.containerView = self.containerView;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self.view endEditing:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player stop];
        });
//        [self.controlView resetControlView];
//        [self.controlView showTitle:@"视频标题" coverURLString:@"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg" fullScreenMode:ZFFullScreenModeLandscape];
//        [self.player.currentPlayerManager replay];
    };
    NSString *URLString = [@"http://tb-video.bdstatic.com/tieba-video/7_517c8948b166655ad5cfb563cc7fbd8e.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    playerManager.assetURL = [NSURL URLWithString:proxyURLString];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - about keyboard orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        [_controlView showTitle:@"视频标题" coverURLString:@"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg" fullScreenMode:ZFFullScreenModeLandscape];
    }
    return _controlView;
}


@end
