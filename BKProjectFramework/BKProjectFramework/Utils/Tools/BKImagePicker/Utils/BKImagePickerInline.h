//
//  BKImagePickerInline.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/10/8.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#ifndef BKImagePickerInline_h
#define BKImagePickerInline_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 检测是否是iPhoneX系列

/**
 判断是否是iPhone X系列
 */
NS_INLINE BOOL bk_is_iPhoneX_series() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

/**
 获取系统状态栏高度
 */
NS_INLINE CGFloat bk_get_system_statusBar_height() {
    return bk_is_iPhoneX_series() ? 44.f : 20.f;
}

/**
 获取系统导航高度
 */
NS_INLINE CGFloat bk_get_system_nav_height() {
    return bk_is_iPhoneX_series() ? (44.f+44.f) : 64.f;
}

/**
 获取系统导航UI高度
 */
NS_INLINE CGFloat bk_get_system_nav_ui_height() {
    return bk_get_system_nav_height() - bk_get_system_statusBar_height();
}

/**
 获取系统tabbar高度
 */
NS_INLINE CGFloat bk_get_system_tabbar_height() {
    return bk_is_iPhoneX_series() ? 83.f : 49.f;
}

/**
 获取系统tabbarUI高度
 */
NS_INLINE CGFloat bk_get_system_tabbar_ui_height() {
    return 49.f;
}

#endif /* BKImagePickerInline_h */
