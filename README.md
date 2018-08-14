# BKProjectFramework
未来自己使用的框架（一步步更新中）

## IJKPlayer模拟器+真机合并下载地址
提示:IJKPlayer太大，所以项目中未上传IJKPlayer，我把IJKPlayer上传到百度云盘，链接如下
链接:[IJKPlayer下载链接](https://pan.baidu.com/s/10qUR69T2FwgDrSVLE4gVCg)    密码:hlat

## 记录坑点
1. 运行时赋值object_setIvar(id  _Nullable obj, Ivar  _Nonnull ivar, id  _Nullable value) 该方法不执行setter方法 
2. [obj setValue:(nullable id) forKey:(nonnull NSString *)] 若forKey传入的属性名前加下划线不会执行setter方法
3. IJKPlayer安装步骤坑点一: 执行 ./compile-ffmpeg.sh all 这个命令出现了 C compiler test failed 错误。 原因是找不到电脑中ios版本。 解决方法在终端输入 sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer 这条命令就可以解决    [[参考链接](https://www.jianshu.com/p/5dd511223fc1)]
4. IJKPlayer安装步骤坑点二: 执行 ./compile-ffmpeg.sh all 这个命令出现了下面这个错误
    ```
    ./libavutil/arm/asm.S:50:9: error: unknown directive
        .arch armv7-a
        ^
    make: *** [libavcodec/arm/aacpsdsp_neon.o] Error 1
   ```
   是因为最新的 Xcode 已经弱化了对 32 位的支持, 解决方法:在 compile-ffmpeg.sh 中删除 armv7 , 修改如: FF_ALL_ARCHS_IOS8_SDK="arm64 i386 x86_64" 再重新执行出现错误的命令: ./compile-ffmpeg.sh all    [[参考链接](https://www.jianshu.com/p/9743a68c2939)]
5. IJKPlayer安装步骤坑点三: 按github官网步骤添加完系统库，并把IJKMediaFramework导入项目中出现了下面这个错误
   ```
   Undefined symbols for architecture arm64:
   "operator delete(void*)", referenced from:
   _ijk_map_destroy in IJKMediaFramework(ijkstl.o)
   std::__1::__tree<std::__1::__value_type<long long, void*>, std::__1::__map_value_compare<long long, std::__1::__value_type<long long, void*>, std::__1::less<long long>, true>, std::__1::allocator<std::__1::__value_type<long long, void*> > >::destroy(std::__1::__tree_node<std::__1::__value_type<long long, void*>, void*>*) in IJKMediaFramework(ijkstl.o)
   std::__1::__tree<std::__1::__value_type<long long, void*>, std::__1::__map_value_compare<long long, std::__1::__value_type<long long, void*>, std::__1::less<long long>, true>, std::__1::allocator<std::__1::__value_type<long long, void*> > >::erase(std::__1::__tree_const_iterator<std::__1::__value_type<long long, void*>, std::__1::__tree_node<std::__1::__value_type<long long, void*>, void*>*, long>) in IJKMediaFramework(ijkstl.o)
   "operator new(unsigned long)", referenced from:
   _ijk_map_create in IJKMediaFramework(ijkstl.o)
   std::__1::pair<std::__1::__tree_iterator<std::__1::__value_type<long long, void*>, std::__1::__tree_node<std::__1::__value_type<long long, void*>, void*>*, long>, bool> std::__1::__tree<std::__1::__value_type<long long, void*>, std::__1::__map_value_compare<long long, std::__1::__value_type<long long, void*>, std::__1::less<long long>, true>, std::__1::allocator<std::__1::__value_type<long long, void*> > >::__emplace_unique_key_args<long long, std::__1::piecewise_construct_t const&, std::__1::tuple<long long const&>, std::__1::tuple<> >(long long const&, std::__1::piecewise_construct_t const&&&, std::__1::tuple<long long const&>&&, std::__1::tuple<>&&) in IJKMediaFramework(ijkstl.o)
   ld: symbol(s) not found for architecture arm64
   clang: error: linker command failed with exit code 1 (use -v to see invocation)
   ```
   解决方法：添加系统依赖库libc++.dylib(tbd)，然后重新编译就可以了。    [[参考链接](https://www.jianshu.com/p/93b8379c35f8)]
6. 猜想CABasicAnimation和dispatch_source_t定时器(定时器以0.01s执行一次)同时开始进行 CABasicAnimation比dispatch_source_t定时器执行快0.01s。原因未知。
7. 小数点精度不准 CGFloat类型0.8 = 0.80000000000000004
8. GPUImage录制视频 GPUImageVideoCamera创建的对象必须调用- (BOOL)addAudioInputsAndOutputs方法 避免录制显示闪屏bug
9. GPUImage录像捕捉当前显示图像 以以下方法获取报错
   ```objc
   //    方法
   GPUImagePicture * imageSource = [[GPUImagePicture alloc] initWithImage:currentImage];
   [imageSource addTarget:self.beautyFilter];
   [imageSource processImage];
   UIImage * resultImage = [self.beautyFilter imageFromCurrentFramebuffer];
   [self.beautyFilter useNextFrameForImageCapture];

   //    报错
   Assertion failure in -[GPUImageFramebuffer unlock]
   Tried to overrelease a framebuffer, did you forget to call -useNextFrameForImageCapture before using -imageFromCurrentFramebuffer?
   ```
   改用以下方法捕捉当前图像 
   ```objc
   __block BOOL next = YES;
   [self.beautyFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
       if (next) {
           next = NO;
           UIImage * resultImage = [output imageFromCurrentFramebuffer];
           [output useNextFrameForImageCapture];
           if (complete) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   complete(resultImage);
               });
           }
       }
   }];
   ```
   该方法有弊端会一直调用 需在外部加一判断 经测试该方法暂时不会报错 时间长了也会报同样的错 需要在GPUImage中GPUImageFrameburrer.m文件中 -(void)unlock方法修改成如下
   ```objc
   - (void)unlock;
   {
       if (referenceCountingDisabled)
       {
           return;
       }
   
       if (framebufferReferenceCount < 1) {
           return;
       }
   
       NSAssert(framebufferReferenceCount > 0, @"Tried to overrelease a framebuffer, did you forget to call -useNextFrameForImageCapture before using -imageFromCurrentFramebuffer?");
       framebufferReferenceCount--;
       if (framebufferReferenceCount < 1)
       {
           [[GPUImageContext sharedFramebufferCache] returnFramebufferToCache:self];
       }
   }
   ```
10. GPUImage录制视频时第一帧和最后一帧有时候是黑屏 所以把视频的第一帧和最后一帧删除
    为了多视频合成看起来更顺滑 所以删除每个视频的前两帧和最后两帧
11. GPUImageVideoCameraDelegate代理方法 备注+代码如下
      ```objc
      -(void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
      {
      //    用此方法把CMSampleBufferRef转CIImage再转UIImage此时image方向不对 调整方向需要UIImage转CGImageRef这时转的CGImageRef为空
      //    需要提前把CIImage转成CGImageRef调整方向 最后转成UIImage
            CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
            self.currentCIImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
      
      //    用GPUImage录像下面方法报错 [Unknown process name] CGBitmapContextCreate: invalid data bytes/row: should be at least 7680 for 8 integer bits/component, 3 components, kCGImageAlphaPremultipliedFirst
      //    自己写的录像代理方法中下面方法没错
      //    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
      //    CVPixelBufferLockBaseAddress(imageBuffer, 0);
      //    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
      //    size_t width = CVPixelBufferGetWidth(imageBuffer);
      //    size_t height = CVPixelBufferGetHeight(imageBuffer);
      //    if (width == 0 || height == 0) {
      //        return nil;
      //    }
      //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      //    void * baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
      //
      //    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
      //    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
      //    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
      //    CGContextRelease(context);
      //    CGColorSpaceRelease(colorSpace);
      //
      //    UIImage * image = [UIImage imageWithCGImage:quartzImage];
      //    CGImageRelease(quartzImage);
      //    return image;
      }
     ```
