# 输入

`xml_flutter`的输入文件为一个融合了`wxml`与`wxss`的xml文件，也就是应用了CSS属性的html文件，需要利用已有的nodejs工具`juice`。

开发阶段可直接利用[在线工具](https://automattic.github.io/juice/)。

**TODO**: 需要进一步将CSS的简写属性再打碎成单个CSS属性，如`flex: 1`变成`flex-grow: 1`，`font: italic bold .8em/1.2 Arial, sans-serif;`变成：
```css
font-style: italic;
font-weight: bold;
font-size: .8em;
line-height: 1.2;
font-family: Arial, sans-serif;
```

`xml_flutter`最关键的工作就是根据CSS属性生成合适的flutter控件
