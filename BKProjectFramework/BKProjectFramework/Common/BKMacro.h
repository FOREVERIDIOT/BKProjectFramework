//
//  BKMacro.h
//  BKProjectFramework
//
//  Created by BIKE on 2018/7/6.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#ifndef BKMacro_h
#define BKMacro_h

#pragma mark - 默认头像

#define DEFAULT_USER_HEADER [UIImage imageNamed:@""]

#pragma mark - 屏幕宽高

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#pragma mark - 颜色

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGB_A(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#pragma mark - 常用定义

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define ONE_PIXEL POINTS_FROM_PIXELS(1.0)

#define WEAK_SELF(obj) __weak typeof(obj) weakSelf = obj;
#define STRONG_SELF(obj) __strong typeof(obj) strongSelf = weakSelf;

#endif /* BKMacro_h */
