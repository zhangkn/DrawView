//
//  DrawPath.h
//  14 画板
//
//  Created by MAC on 2017/7/29.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPath : UIBezierPath

//因为 UIBezierPath 这个类没有颜色的属性，需要自己添加此属性
@property(nonatomic,strong)UIColor * pathSystemColor;

@end
