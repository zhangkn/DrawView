//
//  DrawView.m
//  14 画板
//
//  Created by MAC on 2017/7/27.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "DrawView.h"

#import "DrawPath.h"

@interface DrawView()

/**
 自定义的路径
 */
@property(nonatomic,strong)DrawPath * path;

/**路径数组*/
@property(nonatomic,strong)NSMutableArray * pathArr;

@end

@implementation DrawView
-(NSMutableArray *)pathArr
{
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}


//仅仅加载xib的时候调用
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}


/**
 初始化
 */
-(void)setUp
{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    _lineWidth = 1;
    
    _pathColor = [UIColor blackColor];
    
}

//当手指拖动的时候调用
-(void)pan:(UIPanGestureRecognizer*)pan
{
    
//    NSLog(@"%s",__func__);
    
    //获取手指当前触摸点
    CGPoint curP = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        //创建贝瑟尔路径
       _path = [[DrawPath alloc]init];
        
        //设置线宽
        _path.lineWidth = _lineWidth;
        
        //给路径设置颜色
        _path.pathSystemColor = _pathColor;
        
        //设置路径的起点
        [_path moveToPoint:curP];
        
        //保存描述好的路径
        [self.pathArr addObject:_path];
    }
    
    //添加线到当前点
    [_path addLineToPoint:curP];
    
    //重绘
    [self setNeedsDisplay];
    
}

//绘制图形
//只要调用drawRact方法就会把之前的内容全部清空
- (void)drawRect:(CGRect)rect {
    
//      NSLog(@"%s",__func__);
    
    for (DrawPath * path in self.pathArr) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            
            //绘制图片
            UIImage * image = (UIImage *)path;
            [image drawInRect:rect];
            
        }
        else{
            
            //画线
            [path.pathSystemColor set];
            
            [path stroke];
        }
       
    }
    
    
    
}


#pragma mark - 功能

//清屏
-(void)clear;

{
    [self.pathArr removeAllObjects];
    [self setNeedsDisplay];
}


//撤销
-(void)undo
{
    [self.pathArr removeLastObject];
    [self setNeedsDisplay];
}

//图片
-(void)setImageDraw:(UIImage *)imageDraw
{    //重新赋值
    _imageDraw = imageDraw;
    
    //添加到路径中
    [self.pathArr addObject:_imageDraw];
    //重绘
    [self setNeedsDisplay];
    
}

@end
