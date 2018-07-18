# BKProjectFramework
未来自己使用的框架（一步步更新中）

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

## IJKPlayer模拟器+真机合并下载地址
提示:IJKPlayer太大，所以项目中未上传IJKPlayer，我把IJKPlayer上传到百度云盘，链接如下
链接:- [IJKPlayer](https://pan.baidu.com/s/10qUR69T2FwgDrSVLE4gVCg)    密码:hlat
