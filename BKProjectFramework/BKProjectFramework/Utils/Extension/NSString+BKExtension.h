//
//  NSString+BKExtension.h
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BKExtension)

#pragma mark - 获取设备号

/**
 获取设备号UUID
 
 @return UUID
 */
+(NSString*)getDeviceUUID;

#pragma mark - 转化拼音

/**
 转化为拼音
 
 @return 拼音
 */
-(NSString*)transformToPinyin;

/**
 转化为拼音，并且取首字母
 
 @return 拼音首字母
 */
-(NSString*)takeFirstLetterOfPinyin;

#pragma mark - 编码

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;

/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

/**
 aes加密
 @return 加密结果
 */
- (NSString *)aesEncodeString;

/**
 aes解密
 @return 解密结果
 */
- (NSString *)aesDecodedString;

/**
 *  md5
 *  @return md5加密结果
 */
- (NSString *)md5EncodeString;

/**
 *  sha1
 *  @return sha1加密结果
 */
- (NSString *)sha1EncodeString;

@end
