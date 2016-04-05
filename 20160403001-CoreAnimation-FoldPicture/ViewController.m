//
//  ViewController.m
//  20160403001-CoreAnimation-FoldPicture
//
//  Created by Rainer on 16/4/3.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UIView *gestureRecognizerView;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.这里使用两个图片视图来展示一张图片
    
    // 1.1.这里可以控制图片视图显示内容的范围
    self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.bottomImageView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    
    // 1.2.设置图片视图的锚点让两个视图拼接成一个
    self.topImageView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomImageView.layer.anchorPoint = CGPointMake(0.5, 0);

    // 2.设置底部图片视图渐变图层
    // 2.1.创建一个渐变图层
    self.gradientLayer = [[CAGradientLayer alloc] init];
    
    // 2.2.设置渐变图层透明度
    self.gradientLayer.opacity = 0;
    // 2.3.设置渐变图层渐变色
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    // 2.4.设置渐变图层的尺寸
    self.gradientLayer.frame = self.bottomImageView.bounds;
    
    // 2.5.将渐变图层添加到底部图片视图上
    [self.bottomImageView.layer addSublayer:self.gradientLayer];
    
    // 3.添加滑动手势（添加到透明视图上）
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self.gestureRecognizerView addGestureRecognizer:panGestureRecognizer];
}

/**
 *  滑动手势处理事件:拖动手指的时候折叠（旋转）图片
 */
-(void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取当前手指偏移量
    CGPoint currentPoint = [panGestureRecognizer translationInView:self.gestureRecognizerView];
    
    // 2.算出旋转角度
    CGFloat angle = -currentPoint.y / self.gestureRecognizerView.bounds.size.height * M_PI;
    
    // 3.设置上半部分的旋转属性
    CATransform3D transform3D = CATransform3DMakeRotation(angle, 1, 0, 0);
    // 3.1.增强3D效果：旋转的立体感，近大远小，d：距离图层的距离
    transform3D.m34 = -1 / 500.0;
    
    self.topImageView.layer.transform = transform3D;
    
    // 4.增加阴影渐变色
    self.gradientLayer.opacity = currentPoint.y * 1 / self.gestureRecognizerView.bounds.size.height;
    
    // 4.当手指停止拖动回弹旋转
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // usingSpringWithDamping:弹性系数，该值越小，弹簧效果越明显
        // initialSpringVelocity:弹簧初始速度
        // options:动画效果（是否均匀）
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.gradientLayer.opacity = 0;
            self.topImageView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }

    
    NSLog(@"%@", NSStringFromCGPoint(currentPoint));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
