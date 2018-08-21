//
//  ViewController.m
//  抽屉效果
//
//  Created by corepress on 2018/8/21.
//  Copyright © 2018年 corepress. All rights reserved.
//

#import "ViewController.h"

//自动提示宏
#define keyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))
#define screenWidht [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSetMainViewFrame)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self setupViews];
}

- (void)reSetMainViewFrame {
    [UIView animateWithDuration:0.25 animations:^{
        _mainView.frame = self.view.bounds;
    }];
}

- (void)setupViews {
    //左边
    _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _leftView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:_leftView];
    
    //右边
    _rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _rightView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:_rightView];

    //中间
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _mainView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_mainView];
    
    //监听_mainView的frame改变
//    [_mainView addObserver:self forKeyPath:keyPath(_mainView, frame)  options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (_mainView.frame.origin.x > 0) {  //右滑
        _rightView.hidden = YES;
    }else if(_mainView.frame.origin.x < 0) { //左滑
        _rightView.hidden = NO;
    }
    
}

#define kTargetR 275
#define kTargetL -250
- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    
    //判断pan手势的状态停止滑动 定位_mainView的frame
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        //左滑超过屏幕一半
        CGFloat translation_maxX = 0;
        if (_mainView.frame.origin.x > screenWidht * 0.5) {
            
            translation_maxX = kTargetR;
            
        }else if(_mainView.frame.origin.x < -screenWidht * 0.5){ //右滑超过屏幕一半
            
            translation_maxX = kTargetL;
            
        }

        if (translation_maxX == 0) { //复原
            [UIView animateWithDuration:0.25 animations:^{
                _mainView.frame = self.view.bounds;
            }];
        }else {
//            //计算偏移量
            CGFloat autoTranslation_x = translation_maxX - _mainView.frame.origin.x;
            
            CGRect frame = [self translationMainViewWithPanOffSet:autoTranslation_x];
            
            [UIView animateWithDuration:0.25 animations:^{
                 _mainView.frame = frame;
            }];
            
        }
        
       
    }
    CGFloat offSet_X = [pan translationInView:self.view].x;
    
    [self translationMainViewWithPanOffSet:offSet_X];
    
    [pan setTranslation:CGPointZero inView:self.view];
    
    CGRect frame = [self translationMainViewWithPanOffSet:offSet_X];
    
    _mainView.frame = frame;

    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
}

//改变_mainView.frame
#define KmaxY 80.0
- (CGRect)translationMainViewWithPanOffSet:(CGFloat)offSet_X {
    CGRect f = self.mainView.frame;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //x每平移一点 y需要移动
    CGFloat offSetY = offSet_X * KmaxY /screenWidht;
    //获取上一次的高度
    CGFloat preH = f.size.height;
    //获取上一次的宽度
    CGFloat preW = f.size.width;
    //获取当前的高度
    CGFloat curH = preH - 2*offSetY;
    if (f.origin.x < 0) { //往左移动
        curH = preH + 2*offSetY;
    }
    //获取尺寸缩放比例
    CGFloat scale = curH / preH;
    //获取当前的宽度
    CGFloat curW = preW * scale;
    //后去当前的X
    f.origin.x += offSet_X;
    //获取当前的y
    CGFloat y = (screenHeight - curH) / 2;
    f.origin.y = y;
    f.size.height = curH;
    f.size.width = curW;
    
    return f;
    
}

@end
