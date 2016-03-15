//
//  ViewController.m
//  EPFMSliderView
//
//  Created by enoughpower on 16/3/15.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

#import "ViewController.h"
#import "EPFMSliderView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    EPFMSliderView *slider = [[EPFMSliderView alloc]initWithFrame:CGRectMake(50, 100, 300, 300)];
    slider.MaxNumber = 108;
    slider.MinNumber = 87.5;
    //这里的value需要乘以10，比如100.7设置就是1007
    slider.value = 1007;
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    EPFMSliderView *slider1 = [[EPFMSliderView alloc]initWithFrame:CGRectMake(100, 500, 200, 200)];
    slider1.MaxNumber = 108;
    slider1.MinNumber = 87.5;
    //这里的value需要乘以10，比如100.7设置就是1007
    slider1.value = 1007;
    [self.view addSubview:slider1];
    
}

- (void)slider:(EPFMSliderView *)sender
{
    NSLog(@"%ld",(long)sender.value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
