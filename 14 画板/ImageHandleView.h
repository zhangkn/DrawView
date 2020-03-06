//
//  ImageHandleView.h
//  14 画板
//
//  Created by MAC on 2017/8/1.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHandleView : UIView

/**ViewController传过来的图片传给这个图片*/
@property(nonatomic,strong)UIImage * imageH;

/**图片处理完成后的block*/
@property(nonatomic,strong)void(^handleCompletionBlock)(UIImage * image);
@end
