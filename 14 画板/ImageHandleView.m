//
//  ImageHandleView.m
//  14 画板
//
//  Created by MAC on 2017/8/1.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "ImageHandleView.h"
@interface ImageHandleView()<UIGestureRecognizerDelegate>

@property(nonatomic,weak)UIImageView * imageV;

@end
@implementation ImageHandleView

//重写set方法，展示UIImageView的图片
-(void)setImageH:(UIImage *)imageH
{
    _imageH = imageH;
    
    self.imageV.image = imageH;
}


-(UIImageView *)imageV
{
    if (_imageV == nil) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.userInteractionEnabled = YES;
        
        _imageV = imageV;
        
        //添加手势
        [self setUpGestureRecognizer];
        
        [self addSubview:imageV];
        
    }
    
    return _imageV;
}

#warning 开启这个方法就可以阻止DrawView的pan方法，这样在拖动图片时就不会画出线

-(void)panHandle
{
    NSLog(@"%s",__func__);
    
}
#pragma mark - 添加手势
-(void)setUpGestureRecognizer
{
    //添加拖动手势给ImageHandleView
    UIPanGestureRecognizer * panHandle = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle)];
    [self addGestureRecognizer:panHandle];
    
    //平移
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_imageV addGestureRecognizer:pan];
    
    //旋转
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [_imageV addGestureRecognizer:rotation];
    
    
    //缩放
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [_imageV addGestureRecognizer:pinch];
    
    //长按
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_imageV addGestureRecognizer:longPress];

    
    
    
    
    
}

-(void)pan:(UIPanGestureRecognizer*)pan
{
    //获取手指的偏移量
    CGPoint transP = [pan translationInView:self.imageV];
    //设置UIImageView的形变
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, transP.x, transP.y);
    //复位：只要想要相对于上一次就必须复位
    [pan setTranslation:CGPointZero inView:self.imageV];
    
    
}

-(void)rotation:(UIRotationGestureRecognizer*)rotation
{
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, rotation.rotation);
    //必须遵循代理才能支持多个手势
    rotation.delegate = self;
    rotation.rotation = 0;
    
}


-(void)pinch:(UIPinchGestureRecognizer*)pinch
{
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform, pinch.scale, pinch.scale);
    pinch.delegate = self;
    pinch.scale = 1;
}

-(void)longPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        //高亮效果
        [UIView animateWithDuration:0.25 animations:^{
            self.imageV.alpha = 0;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageV.alpha = 1;
            } completion:^(BOOL finished) {
               //高亮完成之后
                //把处理的图片生成一张新的图片
            //开启位图上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                //获取上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                //把控件的图层渲染到上下文
                [self.layer renderInContext:ctx];
                
                //获取图片
                UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
                //关闭上下文
                UIGraphicsEndImageContext();
                
                
                //调用block
                if (_handleCompletionBlock) {
                    _handleCompletionBlock(image);
                }
                
                //把自己从父控件移除
                [self removeFromSuperview];
                
            }];
        }];
    }
}




#pragma mark - UIGestureRecognizerDelegate

// 是否同时支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
