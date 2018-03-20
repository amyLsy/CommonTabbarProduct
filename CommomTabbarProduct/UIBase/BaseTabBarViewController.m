//
//  BaseTabBarViewController.m
//  ZhiBoMei
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 com.xunyun.zhibomei. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "MMHomeViewController.h"
#import "MMMineViewController.h"
#import "MMFollowViewController.h"
#import "MMMessageViewController.h"
#import "CommomUIUtils.h"
#import "AppConfig.h"
#import <Masonry.h>

@class HLTabBar;

@protocol HLTabBarDelegate<NSObject>

@required
- (void)tabbarSelectMidButton:(UIButton *)midButton tabbar:(HLTabBar *)tabbar;

@end




@interface HLTabBar : UITabBar
@property (weak , nonatomic)   id<HLTabBarDelegate> hlTabarDelegate;
@property (strong , nonatomic) UIButton *liveBtn;
@end

@implementation HLTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemPositioning = UITabBarItemPositioningFill;
        
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [self setBackgroundImage:img];
        
        [self setShadowImage:img];
        
        [self setBackgroundColor:[UIColor orangeColor]];
        self.translucent = NO;
        [self addChildViewMiddleBtn];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
    [self bringSubviewToFront:self.liveBtn];
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@1.2,@1.30,@1.2,@1.1,@1.0];
            animation.duration = 0.4;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}


//添加推流按钮b
- (void)addChildViewMiddleBtn {
    
    self.liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.liveBtn setImage:[UIImage imageNamed:@"home_btn_live_normal"] forState:UIControlStateNormal];
    [self.liveBtn setImage:[UIImage imageNamed:@"home_btn_live_press"] forState:UIControlStateHighlighted];
    self.liveBtn.imageView.contentMode = UIViewContentModeCenter;
    self.liveBtn.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    [self.liveBtn addTarget:self action:@selector(onLiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.liveBtn.frame = CGRectZero;
    [self addSubview:self.liveBtn];
    [_liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(60);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH / 5);
    }];
    
}

#pragma mark - Action Methods
-(void)onLiveButtonClicked:(id)sender {
    
    if (self.hlTabarDelegate) {
        [self.hlTabarDelegate tabbarSelectMidButton:sender tabbar:self];
    }
}

@end

@interface BaseTabBarViewController ()<HLTabBarDelegate,UITabBarControllerDelegate>

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setupTabbar {
    HLTabBar *tabbar = [[HLTabBar alloc] init];
    tabbar.hlTabarDelegate = self;
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if (tabBarController.selectedIndex == 3) {
//        [tabBarController.tabBar hideBadgeOnItemIndex:3];
    }
}

- (void)setup {
    [self setupTabbar];
    MMHomeViewController *homeVc = [[CommomUIUtils getStoryBoard:@"Home"] instantiateViewControllerWithIdentifier:@"MMHomeViewController"];
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:homeVc];
    [self addChildViewController:nc1 imageName:@"home_btn_phb_normal" selectedImageName:@"home_btn_phb_press" title:@"首页"];
    
    MMFollowViewController *followVc = [[CommomUIUtils getStoryBoard:@"Follow"] instantiateViewControllerWithIdentifier:@"MMFollowViewController"];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:followVc];
    [self addChildViewController:nc2 imageName:@"home_btn_livelist_press" selectedImageName:@"home_btn_livelist_normal" title:@"关注"];
    
    MMMessageViewController *msgVc = [[CommomUIUtils getStoryBoard:@"IM"] instantiateViewControllerWithIdentifier:@"MMMessageViewController"];
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:msgVc];
    [self addChildViewController:nc3 imageName:@"home_btn_msg_normal" selectedImageName:@"home_btn_msg_press" title:@"消息"];
    
    MMMineViewController *mineVc = [[CommomUIUtils getStoryBoard:@"Mine"] instantiateViewControllerWithIdentifier:@"MMMineViewController"];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:mineVc];
    [self addChildViewController:nc4 imageName:@"home_btn_user_normal" selectedImageName:@"home_btn_user_press" title:@"我的"];
    [self setSelectedIndex:0];
    self.delegate = self;
}


- (void)addChildViewController:(UIViewController *)childController imageName:(NSString *)normalImg selectedImageName:(NSString *)selectImg title:(NSString *)title {
    childController.tabBarItem.image = [[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, -6.0, 0);
    childController.title = title;
//    childController.tabBarItem.titl
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Marion-Italic" size:10]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont fontWithName:@"Marion-Italic" size:10]} forState:UIControlStateSelected];
    [self addChildViewController:childController];
}

#pragma mark - 点击中间按钮的事件
- (void)tabbarSelectMidButton:(UIButton *)midButton tabbar:(HLTabBar *)tabbar {
    
}


@end
