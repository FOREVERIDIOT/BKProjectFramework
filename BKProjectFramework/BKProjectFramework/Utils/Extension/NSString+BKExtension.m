//
//  NSString+BKExtension.m
//  BKProjectFramework
//
//  Created by zhaolin on 2018/7/11.
//  Copyright © 2018年 BIKE. All rights reserved.
//

#import "NSString+BKExtension.h"
#import <CommonCrypto/CommonCrypto.h>
#import "SAMKeychain.h"
#import "GTMBase64.h"

#define gkey @"1234567890123456" //自行修改16位 -->密钥
#define gIv  @"1234567890123456" //自行修改16位 -->密钥偏移量

@implementation NSString (BKExtension)

#pragma mark - 获取设备号

/**
 获取设备号UUID
 
 @return UUID
 */
+(NSString*)getDeviceUUID
{
    NSString * bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSString * identifierNumber = [SAMKeychain passwordForService:bundleId account:@"device"];
    
    if (!identifierNumber){
        [SAMKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr] forService:bundleId account:@"device"];
        identifierNumber = [SAMKeychain passwordForService:bundleId account:@"device"];
    }
    
    return identifierNumber;
}

#pragma mark - 转化拼音

/**
 转化为拼音
 
 @return 拼音
 */
-(NSString*)transformToPinyin
{
    if (self.length <= 0) {
        return self;
    }
    NSMutableString * tempStringM = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempStringM, NULL, kCFStringTransformToLatin, false);
    NSString * tempString = [tempStringM stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempString uppercaseString];
}

/**
 转化为拼音，并且取首字母
 
 @return 拼音首字母
 */
-(NSString*)takeFirstLetterOfPinyin
{
    if (self.length <= 0) {
        return self;
    }
    return [[self transformToPinyin] substringWithRange:NSMakeRange(0, 1)];
}

#pragma mark - 编码

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString
{
    NSData * data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 aes加密
 @return 加密结果
 */
- (NSString *)aesEncodeString
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    NSInteger diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSInteger newSize = 0;
    
    if(diff > 0) {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++) {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,// | kCCOptionECBMode,  // 补码方式
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData * resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingData:resultData];
        //        if (resultData && resultData.length > 0) {
        //            Byte * datas = (Byte*)[resultData bytes];
        //            NSMutableString * output = [NSMutableString stringWithCapacity:resultData.length * 2];
        //            for(int i = 0; i < resultData.length; i++){
        //                [output appendFormat:@"%02x", datas[i]];
        //            }
        //            return output;
        //        }
    }
    
    free(buffer);
    return nil;
}

/**
 aes解密
 @return 解密结果
 */
- (NSString *)aesDecodedString
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData * data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    //    unsigned char whole_byte;
    //    char byte_chars[3] = {'\0','\0','\0'};
    //    int i;
    //    for (i=0; i < [self length] / 2; i++) {
    //        byte_chars[0] = [self characterAtIndex:i*2];
    //        byte_chars[1] = [self characterAtIndex:i*2+1];
    //        whole_byte = strtol(byte_chars, NULL, 16);
    //        [data appendBytes:&whole_byte length:1];
    //    }
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,// | kCCOptionECBMode
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData * resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return nil;
}

/**
 *  md5
 *  @return md5加密结果
 */
- (NSString *)md5EncodeString
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  sha1
 *  @return sha1加密结果
 */
- (NSString *)sha1EncodeString
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
