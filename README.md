####  AVFoundation学习笔记

```
  本博文内容:
  1. 实现二维码扫描
  2. 实现自定义相机拍照功能
  3. 实现图片捕捉功能
  4. 附加: 手电筒的打开 关闭
```

##### 捕捉设备
AVCaptureDevice为诸如摄像头或麦克风等物理设备定义了一个接口。针对物理设备定义了大量控制方法，包括对焦、白平衡、曝光等。最常用的方法是
```
+ (nullable AVCaptureDevice *)defaultDeviceWithMediaType:(AVMediaType)mediaType
```
##### 捕捉会话
 AVCaptureSession(媒体捕捉的核心类),用于连接输入输出的资源。捕捉会话有一个会话预设值，用于控制捕捉数据的格式和质量，默认为AVCaptureSessionPresentHigh

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/WEBRESOURCEd8d7067f19e643d30aeac993ae730ae0/1758)

基础使用:

```
备注:  AVCaptureSession的开启和停止,在完全开启或完全结束之前都会阻塞线程, 因此这里必须放在后台线程中处理，否则，就会导致界面不响.
```

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/847E7C362C1043259E7005F216BB55BE/1814)

##### 捕捉设备的输入
在使用捕捉设备进行处理前，首先要添加一个输入设备，不过一个捕捉设备不能直接添加到AVCaptureSession，但可以将它封装到AVCaptureDeviceInput实例中来添加，使用-deviceInputWithDevice:error:方法

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/DB4B28BA62ED44EEAFA2F485CF7FE0E5/1774)

##### 捕捉的输出
AVCaptureOutput是一个抽象基类，用于为从捕捉会话得到的数据输入到目的地。应使用这个类的一些派生类如：

``` 
  1. AVCaptureStillImageOuptut 静态图片输出(拍照)
  2. AVCaptureMovieFileOutput  视频输出(视频录制)
  3. AVCaptureVideoDataOutput  视频数据输出(连拍,视频录制)
  4. AVCaptureAudioDataOutput:音频数据输出
```

##### 捕捉预览
AVCaptureVideoPreviewLayer可满足在捕捉时的实时预览，类似于AVPlayerLayer的角色，支持重力概念，可控制视频内容渲染和缩放、拉伸效果.

##### 手电筒的打开、关闭
基本方法:

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/5A8F7AE6B4D54026A52B2D6C879EE866/1863)

##### 实现二维码扫描
AVCaptureMetadataOutput 用于处理AVCaptureSession产生的定时元数据的捕获输出，继承自 AVCaptureOutput

AVMetadataObjectType,元数据类型,主要如下:
![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/7B556725977A4C22903889B3CCB6389D/1787)

遵从协议AVCaptureMetadataOutputObjectsDelegate

```
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
```

基础代码如下:

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/5D2F788A0AF34FB7AFFE81318C6EF61D/1803)

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/21E3CE4EDFCC4ADC9CE10E52B2745DB1/1805)

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/E9A2739ED1714B75A9DC563C4E10CEE4/1807)

##### 自定义拍照

基础方法:

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/283A79E36DB74F1488FC47BD995E5AA2/1831)

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/A7EDA26A550842F786A63CED14504F61/1825)


##### 实现连拍
AVCaptureVideoDataOutput,原始视频帧，用于获取实时图像以及视频录制
遵从协议:AVCaptureVideoDataOutputSampleBufferDelegate

```
//AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
```
基础方法:

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/F8AA61D53EEC4376AC1146A91E23AF35/1841)

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/B8E11CE6F815418889ABD15064678852/1845)

![](https://note.youdao.com/yws/public/resource/b4c14e56820f65411c455996604366b0/xmlnote/1BA1F4EAC4514FAD913EED8633B2E069/1843)

