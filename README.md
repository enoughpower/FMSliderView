# FMSliderView
基于UIControl实现FM调频效果的Slider

##使用方法
```
EPFMSliderView *slider = [[EPFMSliderView alloc]initWithFrame:CGRectMake(50, 100, 300, 300)];
// 最大数值
slider.MaxNumber = 108;
// 最小数值
slider.MinNumber = 87.5;
//这里的value需要乘以10，比如100.7设置就是1007
slider.value = 1007;
// 添加事件
[slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
[self.view addSubview:slider];
```

##效果图

![截图](http://ac-j38u14vo.clouddn.com/5bee867b58fdce2f.png)
