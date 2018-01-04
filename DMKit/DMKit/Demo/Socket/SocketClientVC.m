//
//  Socket.m
//  DMKit
//
//  Created by 西安旺豆电子信息有限公司 on 2018/1/4.
//  Copyright © 2018年 呆木出品. All rights reserved.
//

#import "SocketClientVC.h"
#import <sys/Socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface SocketClientVC ()

@end

@implementation SocketClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self socketDemo];
}

- (void)socketDemo
{
    //1.创建socket
    
//    af：一个地址描述。目前仅支持AF_INET格式，也就是说ARPA Internet地址格式。
//    type：指定socket类型TCP（SOCK_STREAM）和UDP（SOCK_DGRAM）。
//    protocol：指定协议。套接口所用的协议。如调用者不想指定，可用0。常用的协议有，IPPROTO_TCP、IPPROTO_UDP、IPPROTO_STCP、IPPROTO_TIPC等，它们分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议。
    
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (clientSocket > 0) {
        NSLog(@"创建socket成功:%d",clientSocket);
    } else {
        NSLog(@"创建socket失败:%d",clientSocket);
        return;
    }
    
    //终端创建服务器命令   nc -lk 12345
    //2.连接到服务器
    
    
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(12345);
    serverAddr.sin_addr.s_addr = inet_addr("192.168.100.111");
    //    s：标识一个未连接socket
    //    name：指向要连接套接字的sockaddr结构体的指针
    //    namelen：sockaddr结构体的字节长度
    int connectResult = connect(clientSocket, (const struct sockaddr *)&serverAddr, sizeof(serverAddr));
    
    if (connectResult == 0) {
        NSLog(@"连接服务器成功!");
    }else{
        NSLog(@"连接服务器失败:%d",connectResult);
        return;
    }
    
    //发送接收
    NSString *sendMsg = @"Hello socket!";
    size_t sendLen = send(clientSocket, sendMsg.UTF8String, strlen(sendMsg.UTF8String), 0);
    
    NSLog(@"发送%ld字节",sendLen);
    
    //关闭
    
}



@end
