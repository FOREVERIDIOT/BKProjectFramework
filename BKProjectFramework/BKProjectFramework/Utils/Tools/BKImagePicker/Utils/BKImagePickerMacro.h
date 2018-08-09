//
//  BKImagePickerMacro.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/19.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#ifndef BKImagePickerMacro_h
#define BKImagePickerMacro_h

/********************************** 相簿界面、修改图片界面 **********************************/

//导航背景颜色
#define BKNavBackgroundColor [UIColor colorWithWhite:1 alpha:0.8]
//导航字体默认颜色
#define BKNavGrayTitleColor [UIColor colorWithWhite:0.5 alpha:1]
//所有线的颜色
#define BKLineColor [UIColor colorWithWhite:0.85 alpha:1]
//选择按钮默认颜色
#define BKSelectNormalColor [UIColor colorWithWhite:0.2 alpha:0.5]
//高亮颜色
#define BKHighlightColor BK_HEX_RGB(0x2D96FA)
//发送按钮默认颜色
#define BKNavSendGrayBackgroundColor [UIColor colorWithWhite:0.8 alpha:1]

/********************************** 相机界面 **********************************/
//录制视频进度条颜色
#define BKCameraRecordVideoProgressColor BK_HEX_RGB(0x2D96FA)
//暂停录制视频进度条颜色
#define BKCameraPauseRecordVideoProgressColor [UIColor whiteColor]
//相机界面滤镜选择界面的底色
#define BKCameraFilterBackgroundColor [UIColor colorWithWhite:0 alpha:0.4]
//相机界面滤镜选择界面文字的颜色
#define BKCameraFilterTitleColor [UIColor whiteColor]
//相机界面滤镜选择界面文字的选中颜色
#define BKCameraFilterTitleSelectColor BK_HEX_RGB(0x2D96FA)
//相机界面滤镜选择界面等级按钮的颜色
#define BKCameraFilterLevelBtnBackgroundColor [UIColor blackColor]

/********************************** 常用宏定义 **********************************/

#define BK_RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define BK_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BK_SCREENW [UIScreen mainScreen].bounds.size.width
#define BK_SCREENH [UIScreen mainScreen].bounds.size.height

#define BK_POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define BK_ONE_PIXEL BK_POINTS_FROM_PIXELS(1.0)

#define BK_WEAK_SELF(obj) __weak typeof(obj) weakSelf = obj;
#define BK_STRONG_SELF(obj) __strong typeof(obj) strongSelf = weakSelf;

#define BK_IPONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define BK_SYSTEM_STATUSBAR_HEIGHT (BK_IPONEX ? 44.f : 20.f)
#define BK_SYSTEM_NAV_HEIGHT (BK_SYSTEM_STATUSBAR_HEIGHT + 44.f)
#define BK_SYSTEM_NAV_UI_HEIGHT 44.f
#define BK_SYSTEM_TABBAR_HEIGHT (BK_IPONEX ? 83.f : 49.f)
#define BK_SYSTEM_TABBAR_UI_HEIGHT 49.f

#endif /* BKImagePickerMacro_h */
