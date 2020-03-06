//
//  ViewController.m
//  14 画板
//
//  Created by MAC on 2017/7/25.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "ImageHandleView.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet DrawView *drawView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 清屏
- (IBAction)clear:(id)sender {
    
    [_drawView clear];
    
}
#pragma mark - 撤销
- (IBAction)undo:(id)sender {
    
    [_drawView undo];
}

#pragma mark - 橡皮擦
- (IBAction)eraser:(id)sender {
    
    _drawView.pathColor = _drawView.backgroundColor;
    
}
#pragma mark - 选择照片
- (IBAction)pickPhoto:(id)sender {
    
    //弹出系统相册
    //选择控制器
    UIImagePickerController * pickerVc = [[UIImagePickerController alloc]init];
    //设置选择控制器来源
    pickerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    pickerVc.delegate = self;
    
    [self presentViewController:pickerVc animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
//当用户选择一张图片的时候调用
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取原始大小的图片
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    //初始化imageHandleV
    ImageHandleView * imageHandleV = [[ImageHandleView alloc]initWithFrame:self.drawView.bounds];
    
    //当用户长按图片后，会执行这个block,把图片赋值给drawView
    imageHandleV.handleCompletionBlock = ^(UIImage *image) {
      
        _drawView.imageDraw = image;
    };
    
    [self.drawView addSubview:imageHandleV];
    
    //把图片传过去
    imageHandleV.imageH = image;
    
    
    //把选中的照片画到画板上(这句是没有加图片操作之前的代码，可以删掉)
//    _drawView.imageDraw = image;
    
    //退出相册
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 保存
- (IBAction)save:(id)sender {
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //渲染图层
    [_drawView.layer renderInContext:ctx];
    
    //获取上下文中的图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    // 保存画板的内容放入相册
    // image:写入的图片
    // completionTarget图片保存监听者
    // 注意：以后写入相册方法中，想要监听图片有没有保存完成，保存完成的方法不能随意乱写
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    
}

//监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片成功");
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"保存成功!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - 线宽控制
- (IBAction)valueChange:(UISlider *)sender {
    
    _drawView.lineWidth = sender.value;
    
}

#pragma mark - 颜色控制

- (IBAction)colorChange:(UIButton *)sender {
    
    _drawView.pathColor = sender.backgroundColor;
    
    
}




@end
