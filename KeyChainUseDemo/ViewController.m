//
//  ViewController.m
//  KeyChainUseDemo
//
//  Created by jiangtd on 16/1/22.
//  Copyright © 2016年 jiangtd. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self deleteData];
//    [self updateData];
//    [self findData];
//    [self findAttr];
//    [self storeDataTest];
}

-(void)deleteData
{
    NSString *key = @"pwd";
    NSString *server = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *queue = @{
                            (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:server,
                            (__bridge id)kSecAttrAccount:key
                            };
    OSStatus state = SecItemCopyMatching((__bridge CFDictionaryRef)queue, NULL);
    //存在
    if (state == errSecSuccess) {
        OSStatus deleteState = SecItemDelete((__bridge CFDictionaryRef)queue);
        if (deleteState == errSecSuccess) {
            NSLog(@"删除成功!!!");
        }
    }
}

-(void)updateData
{
    NSString *key = @"pwd";
    NSString *server = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *queue = @{
                            (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:server,
                            (__bridge id)kSecAttrAccount:key
                            };
    OSStatus state = SecItemCopyMatching((__bridge CFDictionaryRef)queue, NULL);
    //存在修改
    if (state == errSecSuccess) {
        NSString *newValue = @"new Value";
        NSData *newData = [newValue dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *paramDict = @{
                                    (__bridge id)kSecValueData:newData
                                    };
        OSStatus updateState = SecItemUpdate((__bridge CFDictionaryRef)queue, (__bridge CFDictionaryRef)paramDict);
        if (updateState == errSecSuccess) {
            NSLog(@"更新成功");
        }
    }
}

//存储数据到钥匙串中
-(void)storeData
{
    NSString *key = @"pwd";
    NSString *value = @"password";
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSString *service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = @{
                           (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                           (__bridge id)kSecAttrService:service,
                           (__bridge id)kSecAttrAccount:key,
                           (__bridge id)kSecValueData:valueData
                           };
    CFTypeRef typeResult = NULL;
    OSStatus state =  SecItemAdd((__bridge CFDictionaryRef)dict, &typeResult);
    if (state == errSecSuccess) {
        NSLog(@"store secceed");
    }
}

//查找
-(void)findAttr
{
    NSString *key = @"pwd";
    NSString *service = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = @{
                           (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                           (__bridge id)kSecAttrService:service,
                           (__bridge id)kSecAttrAccount:key,
                           (__bridge id)kSecReturnAttributes:(__bridge id)kCFBooleanTrue
                           };
    CFDictionaryRef resultDict = NULL;
    OSStatus state = SecItemCopyMatching((__bridge CFDictionaryRef)dict, (CFTypeRef*)&resultDict);
    NSDictionary *result = (__bridge_transfer NSDictionary*)resultDict;
    if (state == errSecSuccess)
    {
        NSLog(@"server:%@",result[(__bridge id)kSecAttrService]);
        NSLog(@"account:%@",result[(__bridge id)kSecAttrAccount]);
        NSLog(@"assessGroup:%@",result[(__bridge id)kSecAttrAccessGroup]);
        NSLog(@"createDate:%@",result[(__bridge id)kSecAttrCreationDate]);
        NSLog(@"modifyDate:%@",result[(__bridge id)kSecAttrModificationDate]);
    }
}

//查找数据
-(void)findData
{
    NSString *key = @"pwd";
    NSString *server = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *queueDict = @{
                                (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecAttrService:server,
                                (__bridge id)kSecAttrAccount:key,
                                (__bridge id)kSecReturnData:(__bridge id)kCFBooleanTrue
                                /*(__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll
                                 当为kSecMatchLimit时，SecItemCopyMatching第二个参数为CFArrayRef，元素为CFDataRef*/
                                };
    CFDataRef dataRef = NULL;
    OSStatus state = SecItemCopyMatching((__bridge CFDictionaryRef)queueDict, (CFTypeRef*)&dataRef);
    if (state == errSecSuccess) {
        NSString *value = [[NSString alloc] initWithData:(__bridge_transfer NSData*)dataRef encoding:NSUTF8StringEncoding];
        NSLog(@"value:%@",value);
    }
}

@end
















