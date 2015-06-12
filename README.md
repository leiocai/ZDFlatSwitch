# ZDFlatSwitch

根据Swift(AIFlatSwitch)版本修改的一个OC实现.
创意设计来源自Dribble

<p><a href="url"><img src="https://s3.amazonaws.com/f.cl.ly/items/1p0w3B0E3m2I2k3e0z1Q/onoff.gif" align="left" height="150" width="200" ></a></p>
<br><br><br><br><br><br><br>

##系统平台
- iOS 7.1+
- Xcode 6.1

## 集成步骤

> **手动安装**
>
> 拖动`ZDFlatSwitch.h` 和 `ZDFlatSwitch.m` 文件到你的项目中 file directly in your project. 
>

## 使用方法:

### 创建ZDFlatSwitch 对象

- 

```objc
  // 创建对象
  ZDFlatSwitch *flatSwitch = [ZDFlatSwitch new]
  // 设置frame
  flatSwitch.frame =CGRectMake(0, 0, 50, 50);
```

### 方法

> 改变颜色属性

```objc

// 设置线宽
flatSwitch.lineWidth = 10;
// 设置√的颜色
flatSwitch.strokeColor = [UIColor whiteColor];
// 设置圆环的颜色
flatSwitch.trailStrokeColor = [UIColor greenColor];

```
- [x] IBInspectable 特性供在Storyboard使用.


## License

AIFlatSwitch is released under the MIT license. See LICENSE for details. 