# durian

## Prerequisite

```
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel unknown, 2.2.3, on Linux, locale en_US.utf8)
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop
[✓] Android Studio (version 2020.3)
[✓] VS Code (version 1.48.1)
[✓] Connected device (3 available)

• No issues found!
```

`durian`项目包含两个工程：
- `xml_widget`是实际用于解析解压在本地的小程序应用的容器组件，集成在手机端app内
    - `xml_widget/example`是组件的示例程序，按flutter工程目录格式

- `xml_flutter`是生成用flutter控件表示视图结构的xml文件的可执行工具，独立于app。为方便展示解析效果，应用携带GUI
    - `xml_flutter/example`是工具示例程序

运行示例程序需要先运行`xml_flutter`生成示例用`app.xml`
