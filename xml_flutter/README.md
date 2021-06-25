# xml_flutter

A console project to parse html file and generate xml file for [xml_widget](https://pub.dev/packages/xml_widget)

## Getting Started
input: html file with inline css
```xml
<view style="height: 100%; display: flex; flex-direction: column; padding: 30rpx; box-sizing: border-box;">
</view>
```
output: xml file with flutter widget node
```xml
<Container
  flutter:padding="30">
  <Column>
  </Column>
</Container>
```
