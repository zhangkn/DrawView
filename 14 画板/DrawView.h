//
//  DrawView.h
//  14 画板
//
//  Created by MAC on 2017/7/27.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

/**线宽*/
@property(nonatomic,assign)NSInteger lineWidth;

/**颜色*/
@property(nonatomic,strong)UIColor * pathColor;

/**照片*/
@property(nonatomic,strong)UIImage * imageDraw;

//清屏
-(void)clear;
//撤销
-(void)undo;


@end
