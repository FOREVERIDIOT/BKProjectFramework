//
//  BKMacro.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#ifndef BKMacro_h
#define BKMacro_h

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGB_A(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define ONE_PIXEL POINTS_FROM_PIXELS(1.0)

#define WEAK_SELF(obj) __weak typeof(obj) weakSelf = obj;
#define STRONG_SELF(obj) __strong typeof(obj) strongSelf = weakSelf;

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define SYSTEM_STATUSBAR_HEIGHT (iPhoneX ? 44.f : 20.f)
#define SYSTEM_NAV_HEIGHT (iPhoneX ? (44.f+44.f) : 64.f)
#define SYSTEM_NAV_UI_HEIGHT SYSTEM_NAV_HEIGHT - SYSTEM_STATUSBAR_HEIGHT
#define SYSTEM_TABBAR_HEIGHT (iPhoneX ? 83.f : 49.f)
#define SYSTEM_TABBAR_UI_HEIGHT 49.f

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif /* BKMacro_h */
