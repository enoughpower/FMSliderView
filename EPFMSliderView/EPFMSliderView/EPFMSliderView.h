//
//  EPFMSliderView.h
//  EPFMSliderView
//
//  Created by enoughpower on 16/3/15.
//  Copyright © 2016年 enoughpower. All rights reserved.
//
#import<UIKit/UIKit.h>

@interface EPFMSliderView : UIControl
/** 范围0~1  */
@property (nonatomic, assign)CGFloat progress;
/** 根据输入的最大值和最小值取，并乘以10(便于后期使用)*/
@property (nonatomic, assign)NSInteger value;
/** 最大值*/
@property (nonatomic, assign)CGFloat MaxNumber;
/** 最小值*/
@property (nonatomic, assign)CGFloat MinNumber;
@end